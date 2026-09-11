"""Validate the generic C++17 / Python / Bash scheduling research skill."""
from __future__ import annotations

import json
import os
import py_compile
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

from render_agents import render, write_project


SKILL_ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_ROOT = SKILL_ROOT / "code_templates"
SKILL_NAME = "mip-scheduling-project-generator-skill"

CPP_REQUIRED = [
    "CMakeLists.txt.tpl",
    "cpp/include/scheduling/core/domain.hpp.tpl",
    "cpp/include/scheduling/io/instance_loader.hpp.tpl",
    "cpp/include/scheduling/io/result_writer.hpp.tpl",
    "cpp/include/scheduling/algorithms/algorithms.hpp.tpl",
    "cpp/include/scheduling/registry.hpp.tpl",
    "cpp/src/io/instance_loader.cpp.tpl",
    "cpp/src/io/result_writer.cpp.tpl",
    "cpp/include/scheduling/evaluation/evaluator.hpp.tpl",
    "cpp/include/scheduling/algorithms/search_support.hpp.tpl",
    "cpp/src/evaluation/evaluator.cpp.tpl",
    "cpp/src/algorithms/search_support.cpp.tpl",
    *[f"cpp/src/algorithms/{name}.cpp.tpl" for name in
      ("random_search", "sa_basic", "ig_basic", "ts_basic", "ga_basic", "ma_basic")],
    "cpp/src/registry.cpp.tpl",
    "cpp/apps/solver_run.cpp.tpl",
    "cpp/tests/smoke_test.cpp.tpl",
]
AUXILIARY_REQUIRED = [
    "python/analysis/analyze_results.py.tpl",
    "python/math_models/solve_cplex.py.tpl",
    "python/tools/generate_instances.py.tpl",
]
SCRIPT_REQUIRED = [
    "scripts/build.sh.tpl",
    "scripts/generate_instances.sh.tpl",
    "scripts/run_single.sh.tpl",
    "scripts/run_batch.sh.tpl",
    "scripts/run_all.sh.tpl",
    "scripts/run_mip.sh.tpl",
    "scripts/analyze.sh.tpl",
    "scripts/audit.sh.tpl",
    "scripts/format.sh.tpl",
    "scripts/check_project_contracts.py.tpl",
    ".clang-format.tpl",
    "scripts/audit_project.py.tpl",
    "scripts/lib/allocate_result_root.sh.tpl",
]
SEED_REQUIRED = ["configs/seeds/solve_seeds.txt.tpl"]
FORBIDDEN_FILES = [
    "cpp/include/scheduling/decoding/eval_cache.hpp.tpl",
    "cpp/include/scheduling/math_models/cplex_model.hpp.tpl",
    "cpp/src/math_models/cplex_model.cpp.tpl",
    "cpp/apps/cplex_run.cpp.tpl",
    "math_models/gurobi_model.py.tpl",
    "scripts/mip/run_gurobi_mip.py.tpl",
    "metaheuristics/decoding/eval_cache.py.tpl",
]
FORBIDDEN_CORE_TOKENS = ("gurobi", "gurobipy", "docplex", "evalcache", "eval_cache")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read_seed_template(relative: str) -> list[int]:
    path = TEMPLATE_ROOT / relative
    seeds: list[int] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        value = raw.split("#", 1)[0].strip()
        if not value:
            continue
        require(value.isdecimal(), f"invalid seed in {relative}: {value}")
        seeds.append(int(value))
    require(seeds, f"{relative} contains no seeds")
    require(len(seeds) == len(set(seeds)), f"{relative} contains duplicate seeds")
    return seeds


def validate_metadata() -> None:
    content = (SKILL_ROOT / "SKILL.md").read_text(encoding="utf-8")
    require(content.startswith("---\n"), "SKILL.md must start with YAML frontmatter")
    end = content.find("\n---\n", 4)
    require(end != -1, "SKILL.md frontmatter is not closed")
    frontmatter = content[4:end]
    lines = {line.split(":", 1)[0] for line in frontmatter.splitlines() if ":" in line}
    require(
        lines <= {"name", "description", "license", "allowed-tools", "metadata"},
        f"frontmatter contains unsupported keys: {sorted(lines)}",
    )
    require(f"name: {SKILL_NAME}" in frontmatter, "frontmatter name is missing or incorrect")
    description = next(
        (
            line.split(":", 1)[1].strip()
            for line in frontmatter.splitlines()
            if line.startswith("description:")
        ),
        "",
    )
    require(description and len(description) <= 1024, "frontmatter description is missing or too long")
    for token in ("C++17", "Python", "CPLEX", "Bash"):
        require(token in description, f"frontmatter description must mention {token}")

    openai_yaml = (SKILL_ROOT / "agents" / "openai.yaml").read_text(encoding="utf-8")
    require(f"${SKILL_NAME}" in openai_yaml, "openai.yaml default_prompt must mention the skill")
    for relative in CPP_REQUIRED + AUXILIARY_REQUIRED + SCRIPT_REQUIRED + SEED_REQUIRED:
        require((TEMPLATE_ROOT / relative).is_file(), f"missing template: {relative}")
    require((TEMPLATE_ROOT / "docs/convergence_protocol.md.tpl").is_file(), "missing convergence protocol template")
    for relative in FORBIDDEN_FILES:
        require(not (TEMPLATE_ROOT / relative).exists(), f"obsolete template still exists: {relative}")

    manifest = json.loads((SKILL_ROOT / "manifest.json").read_text(encoding="utf-8"))
    require(manifest.get("name") == SKILL_NAME, "manifest name is incorrect")
    require(manifest.get("core_language") == "C++17", "manifest core_language must be C++17")
    require(
        str(manifest.get("auxiliary_language", "")).startswith("Python 3"),
        "manifest auxiliary_language must start with Python 3",
    )
    require("CPLEX" in manifest.get("default_solver", ""), "manifest default solver must be CPLEX")
    require(manifest.get("orchestration") == "Bash", "manifest orchestration must be Bash")
    require(manifest.get("evaluation_cache") == "disabled", "evaluation cache must be disabled")
    require((SKILL_ROOT / manifest["structure_spec"]).is_file(), "manifest structure_spec is dangling")


def validate_templates() -> None:
    errors: list[str] = []
    for path in sorted(SKILL_ROOT.rglob("*.py.tpl")):
        try:
            compile(path.read_text(encoding="utf-8"), str(path), "exec")
        except SyntaxError as exc:
            errors.append(f"{path.relative_to(SKILL_ROOT)}: {exc}")
    require(not errors, "Python template syntax errors: " + "; ".join(errors))

    cmake = (TEMPLATE_ROOT / "CMakeLists.txt.tpl").read_text(encoding="utf-8")
    require("CMAKE_CXX_STANDARD 17" in cmake, "CMake template must require C++17")
    require("scheduling_core" in cmake and "scheduling_smoke" in cmake, "CMake targets are missing")
    require("SCHED_WITH_CPLEX" not in cmake and "CPLEX_ROOT" not in cmake, "CMake must not configure Concert C++")

    domain = (TEMPLATE_ROOT / "cpp/include/scheduling/core/domain.hpp.tpl").read_text(encoding="utf-8")
    require("FlowShopInstance" in domain and "instance_seed" in domain, "reference problem model is incomplete")
    algorithms = "\n".join(path.read_text(encoding="utf-8")
                           for path in (TEMPLATE_ROOT / "cpp/src/algorithms").glob("*.cpp.tpl"))
    require("config.solve_seed" in algorithms, "algorithms must use the explicit solve seed")
    require(not any(token in algorithms.lower() for token in FORBIDDEN_CORE_TOKENS), "algorithm core contains forbidden cache/solver tokens")

    cplex_python = (TEMPLATE_ROOT / "python/math_models/solve_cplex.py.tpl").read_text(encoding="utf-8")
    for token in (
        "import cplex",
        "cplex.Cplex()",
        "parameters.timelimit.set",
        "parameters.threads.set(1)",
        "parameters.randomseed.set(solve_seed)",
        "solution.MIP.get_best_objective()",
        '"instance_seed": instance.instance_seed',
    ):
        require(token in cplex_python, f"CPLEX Python template is missing: {token}")

    registry = (TEMPLATE_ROOT / "cpp/src/registry.cpp.tpl").read_text(encoding="utf-8")
    for name in ("random_search", "sa_basic", "ma_basic", "ig_basic", "ga_basic", "ts_basic"):
        require(f'"{name}"' in registry, f"reference registry is missing {name}")

    generator = (TEMPLATE_ROOT / "python/tools/generate_instances.py.tpl").read_text(encoding="utf-8")
    require('required=True, dest="instance_seed"' in generator, "instance seed must be required")
    require("instance_seed.txt" in generator and '"instance_seed"' in generator, "generator must persist instance_seed")

    batch = (TEMPLATE_ROOT / "scripts/run_batch.sh.tpl").read_text(encoding="utf-8")
    require("duplicate solve seed" in batch and "round=$((index + 1))" in batch, "batch seed contract is incomplete")
    allocator = (TEMPLATE_ROOT / "scripts/lib/allocate_result_root.sh.tpl").read_text(encoding="utf-8")
    require("outputs/formal/$script_id" in allocator, "formal result directory must derive from script id")
    require('candidate="${base}_${rerun}"' in allocator, "unchanged reruns need numeric suffixes")
    runner = (TEMPLATE_ROOT / "cpp/apps/solver_run.cpp.tpl").read_text(encoding="utf-8")
    require("outputs/tmp/unclassified" in runner and "SCHED_OUTPUT_ROOT" in runner, "runner output fallback is unsafe")
    agents, _ = render()
    for token in ("outputs/tmp/", "outputs/formal/", "每 2 小时", "T_init", "INIT", "IMPROVE", "100 点"):
        require(token in agents, f"generated AGENTS.md is missing rule: {token}")
    for relative in SCRIPT_REQUIRED:
        path = TEMPLATE_ROOT / relative
        if path.suffixes[-2:] == [".sh", ".tpl"]:
            shell = path.read_text(encoding="utf-8")
            require(shell.startswith("#!/usr/bin/env bash\n"), f"{relative} needs a Bash shebang")
            require("set -euo pipefail" in shell, f"{relative} needs strict Bash mode")

    solve_seeds = read_seed_template("configs/seeds/solve_seeds.txt.tpl")
    require(len(solve_seeds) == 10, "reference 10-round seed file must contain exactly 10 seeds")


def materialize(project_root: Path) -> None:
    for template in TEMPLATE_ROOT.rglob("*.tpl"):
        relative = template.relative_to(TEMPLATE_ROOT)
        destination = project_root / Path(str(relative)[:-4])
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(template, destination)
        if destination.suffix == ".sh":
            destination.chmod(destination.stat().st_mode | 0o111)
    write_project(project_root)
    demo = project_root / "data" / "demo" / "demo_01_10_5"
    shutil.copytree(SKILL_ROOT / "examples" / "demo_01_10_5", demo)


def validate_contract_regressions(project_root: Path) -> None:
    """Ensure real omissions/minified bodies fail, with valid C++ edge cases accepted."""
    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "contract_check", project_root / "scripts/check_project_contracts.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    require(module.check_rules(project_root)[1] == "PASS", "full AGENTS rejected")
    agents_path = project_root / "AGENTS.md"
    original = agents_path.read_text(encoding="utf-8")
    _, sections = render()
    try:
        # Remove individual substantive rules, not merely section headings.
        for body in sections.values():
            bullet = next(line for line in body.splitlines() if line.startswith("- ")) if any(
                line.startswith("- ") for line in body.splitlines()) else body.splitlines()[0]
            agents_path.write_text(original.replace(bullet, "", 1), encoding="utf-8")
            require(module.check_rules(project_root)[1] == "FAIL", "omitted rule escaped audit")
    finally:
        agents_path.write_text(original, encoding="utf-8")

    source = project_root / "cpp/src/algorithms/sa_basic.cpp"
    content = source.read_text(encoding="utf-8")
    try:
        source.write_text(content + '\nSolveResult solve_extra(const X& x) { return {}; }\n', encoding="utf-8")
        checks = module.check_cpp(project_root)
        require(checks[0][1] == "FAIL", "multiple algorithm bodies escaped audit")
    finally:
        source.write_text(content, encoding="utf-8")

    formatter = shutil.which(os.environ.get("CLANG_FORMAT", "clang-format"))
    require(formatter is not None, "clang-format required to validate new formatting gate")
    probe = project_root / "cpp/tests/format_probe.cpp"
    try:
        probe.write_text('void f(){int n=0;n++;for(int i=0;i<2;++i){n+=i;}const char* s="a;b";}\n', encoding="utf-8")
        require(module.check_cpp(project_root)[1][1] == "FAIL", "minified statements escaped audit")
        formatted = subprocess.run([formatter, "--style=file", "-i", str(probe)], capture_output=True)
        require(formatted.returncode == 0, "format fixture failed")
        require(module.check_cpp(project_root)[1][1] == "PASS", "valid for header/string semicolon rejected")
    finally:
        probe.unlink(missing_ok=True)
    print("PASS regressions: each rule section, merged algorithms, minified statements, for/string semicolons")


def validate_integration() -> None:
    smoke_parent = SKILL_ROOT / "outputs/tmp"
    smoke_parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="skill_validation_", dir=smoke_parent) as temporary:
        project_root = Path(temporary)
        materialize(project_root)
        validate_contract_regressions(project_root)
        build = project_root / "build"
        configure_command = [
            "cmake",
            "-S",
            str(project_root),
            "-B",
            str(build),
            "-DCMAKE_BUILD_TYPE=Release",
        ]
        if os.name == "nt":
            configure_command[1:1] = ["-G", "MinGW Makefiles"]
        configure = subprocess.run(
            configure_command,
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(configure.returncode == 0, f"CMake configure failed:\n{configure.stdout}\n{configure.stderr}")
        compiled = subprocess.run(
            ["cmake", "--build", str(build), "--config", "Release"],
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(compiled.returncode == 0, f"C++ build failed:\n{compiled.stdout}\n{compiled.stderr}")
        ctest_env = os.environ.copy()
        ctest_env["SCHED_OUTPUT_ROOT"] = "outputs/tmp/smoke/skill_validation_ctest"
        ctest = subprocess.run(
            ["ctest", "--test-dir", str(build), "--output-on-failure"],
            cwd=project_root,
            env=ctest_env,
            text=True,
            capture_output=True,
            check=False,
        )
        require(ctest.returncode == 0, f"C++ tests failed:\n{ctest.stdout}\n{ctest.stderr}")

        executable_name = "solver_run.exe" if os.name == "nt" else "solver_run"
        runner = build / executable_name
        if not runner.is_file():
            runner = build / "Release" / executable_name
        require(runner.is_file(), "C++ runner executable is missing")

        demo = project_root / "data" / "demo" / "demo_01_10_5"
        smoke_root = project_root / "outputs" / "tmp" / "smoke" / "skill_validation"
        run_env = os.environ.copy()
        run_env["SCHED_OUTPUT_ROOT"] = "outputs/tmp/smoke/skill_validation"
        run = subprocess.run(
            [str(runner), str(demo), "sa_basic", "104729", "1"],
            cwd=project_root,
            env=run_env,
            text=True,
            capture_output=True,
            check=False,
        )
        require(run.returncode == 0, f"C++ runner failed:\n{run.stdout}\n{run.stderr}")
        result_dir = (
            project_root
            / "outputs"
            / "tmp"
            / "smoke"
            / "skill_validation"
            / "demo_01_10_5"
            / "sa_basic"
            / "round_1_seed_104729"
        )
        result_path = result_dir / "result.json"
        require(result_path.is_file(), "runner did not write result.json")
        payload = json.loads(result_path.read_text(encoding="utf-8"))
        require(payload["instance_seed"] == 42, "result instance_seed is incorrect")
        require(payload["solve_seed"] == 104729 and payload["round"] == 1, "result solve seed metadata is incorrect")
        require((result_dir / "solution.json").is_file(), "runner did not write solution.json")

        bad = subprocess.run(
            [str(runner), str(project_root / "missing_instance"), "sa_basic", "104729", "1"],
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(
            bad.returncode != 0 and "solver_run error:" in bad.stderr,
            "runner must report invalid input without an unhandled exception",
        )

        generated = project_root / "data" / "generated" / "generated_01"
        generation = subprocess.run(
            [
                sys.executable,
                str(project_root / "python/tools/generate_instances.py"),
                "--output",
                str(generated),
                "--jobs",
                "4",
                "--stages",
                "3",
                "--seed",
                "2027",
            ],
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(generation.returncode == 0, f"instance generation failed:\n{generation.stderr}")
        require((generated / "instance_seed.txt").read_text(encoding="utf-8").strip() == "2027", "generated seed is missing")

        analysis = subprocess.run(
            [
                sys.executable,
                str(project_root / "python/analysis/analyze_results.py"),
                "--input",
                str(smoke_root),
                "--output",
                str(project_root / "outputs" / "tmp" / "analysis_summary.csv"),
            ],
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(analysis.returncode == 0, f"Python analysis failed:\n{analysis.stdout}\n{analysis.stderr}")
        require((project_root / "outputs" / "tmp" / "analysis_summary.csv").is_file(), "analysis summary is missing")

        audit = subprocess.run(
            [sys.executable, str(project_root / "scripts" / "audit_project.py")],
            cwd=project_root,
            text=True,
            capture_output=True,
            check=False,
        )
        require(audit.returncode == 0, f"project audit failed:\n{audit.stdout}\n{audit.stderr}")
        audit_text = (project_root / "PROJECT_AUDIT.md").read_text(encoding="utf-8")
        require("Overall: PASS" in audit_text, "project audit did not record PASS")


def main() -> None:
    checks = [
        ("metadata", validate_metadata),
        ("templates", validate_templates),
        ("integration", validate_integration),
    ]
    for name, check in checks:
        check()
        print(f"PASS {name}")
    print("SKILL VALIDATION PASSED")


if __name__ == "__main__":
    main()

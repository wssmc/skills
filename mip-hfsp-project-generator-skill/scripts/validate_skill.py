"""Validate the C++-core / Python-auxiliary HFSP skill package."""
from __future__ import annotations

import json
import os
import py_compile
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


SKILL_ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_ROOT = SKILL_ROOT / "code_templates"
CPP_REQUIRED = [
    "CMakeLists.txt.tpl",
    "cpp/include/hfsp/core/domain.hpp.tpl",
    "cpp/include/hfsp/decoding/eval_cache.hpp.tpl",
    "cpp/include/hfsp/io/instance_loader.hpp.tpl",
    "cpp/include/hfsp/metaheuristics/algorithms.hpp.tpl",
    "cpp/include/hfsp/math_models/gurobi_model.hpp.tpl",
    "cpp/src/math_models/gurobi_model.cpp.tpl",
    "cpp/include/hfsp/registry.hpp.tpl",
    "cpp/src/io/instance_loader.cpp.tpl",
    "cpp/src/metaheuristics/algorithms.cpp.tpl",
    "cpp/src/registry.cpp.tpl",
    "cpp/apps/hfsp_run.cpp.tpl",
    "cpp/tests/smoke_test.cpp.tpl",
]
AUXILIARY_REQUIRED = [
    "python/analysis/analyze_results.py.tpl",
    "python/tools/generate_instances.py.tpl",
]
SCRIPT_REQUIRED = [
    "scripts/build.sh.tpl",
    "scripts/run_single.sh.tpl",
    "scripts/run_batch.sh.tpl",
    "scripts/analyze_results.py.tpl",
    "scripts/audit_project.py.tpl",
]
LEGACY_TEMPLATE_DIRS = {
    "core",
    "data",
    "math_models",
    "metaheuristics",
    "scripts",
    "tests",
    "visualization",
}
GENERATED_SCRIPT_TEMPLATES = {
    "build.sh.tpl",
    "run_single.sh.tpl",
    "run_batch.sh.tpl",
    "analyze_results.py.tpl",
    "audit_project.py.tpl",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def validate_metadata() -> None:
    content = (SKILL_ROOT / "SKILL.md").read_text(encoding="utf-8")
    require(content.startswith("---\n"), "SKILL.md must start with YAML frontmatter")
    end = content.find("\n---\n", 4)
    require(end != -1, "SKILL.md frontmatter is not closed")
    frontmatter = content[4:end]
    lines = {line.split(":", 1)[0] for line in frontmatter.splitlines() if ":" in line}
    require(lines <= {"name", "description", "license", "allowed-tools", "metadata"},
            f"frontmatter contains unsupported keys: {sorted(lines)}")
    require("name: mip-hfsp-project-generator-skill" in frontmatter,
            "frontmatter name is missing or incorrect")
    description = next((line.split(":", 1)[1].strip() for line in frontmatter.splitlines()
                        if line.startswith("description:")), "")
    require(description and len(description) <= 1024, "frontmatter description is missing or too long")
    require("C++17" in description and "Python" in description,
            "frontmatter must declare the C++/Python architecture")
    openai_yaml = SKILL_ROOT / "agents" / "openai.yaml"
    require(openai_yaml.is_file(), "agents/openai.yaml is missing")
    require("$mip-hfsp-project-generator-skill" in openai_yaml.read_text(encoding="utf-8"),
            "agents/openai.yaml default_prompt must mention the skill explicitly")
    for relative in CPP_REQUIRED + AUXILIARY_REQUIRED + SCRIPT_REQUIRED:
        require((TEMPLATE_ROOT / relative).is_file(), f"missing template: {relative}")
    required_config_templates = {
        "problem_statement.md.tpl",
        "constraints_spec.md.tpl",
        "algorithm_requirements.md.tpl",
        "experiment_plan.md.tpl",
        "conventions.md.tpl",
        "problem_fingerprint.json.tpl",
    }
    config_templates = {path.name for path in (SKILL_ROOT / "templates" / "configs").glob("*.tpl")}
    require(config_templates == required_config_templates,
            f"config template set drifted: {sorted(config_templates)}")
    manifest = json.loads((SKILL_ROOT / "manifest.json").read_text(encoding="utf-8"))
    require(manifest.get("core_language") == "C++17", "manifest core_language must be C++17")
    require(manifest.get("auxiliary_language") == "Python 3", "manifest auxiliary_language must be Python 3")
    require((SKILL_ROOT / manifest["structure_spec"]).is_file(), "manifest structure_spec is dangling")


def validate_templates() -> None:
    errors = []
    for path in sorted(SKILL_ROOT.rglob("*.py.tpl")):
        try:
            compile(path.read_text(encoding="utf-8"), str(path), "exec")
        except SyntaxError as exc:
            errors.append(f"{path.relative_to(SKILL_ROOT)}: {exc}")
    require(not errors, "Python template syntax errors: " + "; ".join(errors))

    cmake = (TEMPLATE_ROOT / "CMakeLists.txt.tpl").read_text(encoding="utf-8")
    require("CMAKE_CXX_STANDARD 17" in cmake, "CMake template must require C++17")
    require("hfsp_core" in cmake and "hfsp_smoke" in cmake, "CMake template is missing core/smoke targets")
    domain = (TEMPLATE_ROOT / "cpp/include/hfsp/core/domain.hpp.tpl").read_text(encoding="utf-8")
    require("struct Instance" in domain and "struct Schedule" in domain and "void validate" in domain,
            "C++ domain template is incomplete")
    cache = (TEMPLATE_ROOT / "cpp/include/hfsp/decoding/eval_cache.hpp.tpl").read_text(encoding="utf-8")
    require("capacity = 500" in cache and "std::deque" in cache and "make_eval_key" in cache,
            "C++ EvalCache template is missing FIFO/key contract")
    registry = (TEMPLATE_ROOT / "cpp/src/registry.cpp.tpl").read_text(encoding="utf-8")
    for name in ("random_search", "sa_basic", "ma_basic", "ig_basic", "ga_basic", "ts_basic"):
        require(f'"{name}"' in registry, f"C++ registry is missing {name}")
    analysis = (TEMPLATE_ROOT / "python/analysis/analyze_results.py.tpl").read_text(encoding="utf-8")
    require("*_result.json" in analysis and "write_summary" in analysis,
            "Python analysis template must consume result JSON")

    # The old shell templates are still syntax-checked as repository assets, but
    # they are intentionally not materialized into the new C++ project.
    if (TEMPLATE_ROOT / "scripts/sh_batch_instances_algorithms.sh.tpl").is_file():
        batch = (TEMPLATE_ROOT / "scripts/sh_batch_instances_algorithms.sh.tpl").read_text(encoding="utf-8")
        require("--unified-cache" not in batch and "|| true" not in batch,
                "legacy batch template must not advertise unsafe cache/failure behavior")


def materialize(project_root: Path) -> None:
    for template in TEMPLATE_ROOT.rglob("*.tpl"):
        relative = template.relative_to(TEMPLATE_ROOT)
        if relative.parts and relative.parts[0] == "scripts" and relative.name not in GENERATED_SCRIPT_TEMPLATES:
            continue
        if relative.parts and relative.parts[0] in LEGACY_TEMPLATE_DIRS and relative.parts[0] != "scripts":
            continue
        output_relative = Path(str(relative)[:-4])
        destination = project_root / output_relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(template, destination)
    demo = project_root / "data" / "demo" / "demo_01_10_5"
    shutil.copytree(SKILL_ROOT / "examples" / "demo_01_10_5", demo)


def validate_integration() -> None:
    with tempfile.TemporaryDirectory(prefix="mip_hfsp_skill_validation_") as temporary:
        project_root = Path(temporary)
        materialize(project_root)
        build = project_root / "build"
        configure_command = ["cmake", "-S", str(project_root), "-B", str(build), "-DCMAKE_BUILD_TYPE=Release"]
        if os.name == "nt":
            configure_command[1:1] = ["-G", "MinGW Makefiles"]
        configure = subprocess.run(
            configure_command,
            cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(configure.returncode == 0,
                f"CMake configure failed:\n{configure.stdout}\n{configure.stderr}")
        compile_result = subprocess.run(
            ["cmake", "--build", str(build), "--config", "Release"],
            cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(compile_result.returncode == 0,
                f"C++ build failed:\n{compile_result.stdout}\n{compile_result.stderr}")
        ctest = subprocess.run(
            ["ctest", "--test-dir", str(build), "--output-on-failure"],
            cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(ctest.returncode == 0,
                f"C++ smoke failed:\n{ctest.stdout}\n{ctest.stderr}")

        runner = build / ("hfsp_run.exe" if os.name == "nt" else "hfsp_run")
        if not runner.is_file():
            runner = build / "Release" / ("hfsp_run.exe" if os.name == "nt" else "hfsp_run")
        require(runner.is_file(), "C++ runner executable is missing")
        run_result = subprocess.run(
            [str(runner)], cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(run_result.returncode == 0,
                f"C++ runner failed:\n{run_result.stdout}\n{run_result.stderr}")
        result_dir = project_root / "outputs" / "single" / "demo_cpp"
        require((result_dir / "sa_basic_result.json").is_file(), "C++ runner did not write result JSON")
        bad_run = subprocess.run(
            [str(runner), str(project_root / "missing_instance"), "sa_basic"],
            cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(bad_run.returncode != 0 and "hfsp_run error:" in bad_run.stderr,
                "C++ runner must report invalid input without an unhandled exception")
        analysis = subprocess.run(
            [sys.executable, str(project_root / "python/analysis/analyze_results.py"),
             "--input", str(project_root / "outputs"),
             "--output", str(project_root / "outputs/analysis_summary.csv")],
            cwd=project_root, text=True, capture_output=True, check=False,
        )
        require(analysis.returncode == 0,
                f"Python analysis validation failed:\n{analysis.stdout}\n{analysis.stderr}")
        require((project_root / "outputs/analysis_summary.csv").is_file(),
                "Python analysis did not write summary CSV")


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

"""Audit the generated C++/Python/Bash research project."""
from __future__ import annotations

import ast
import json
import os
import py_compile
import re
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "CMakeLists.txt",
    "cpp/include/scheduling/core/domain.hpp",
    "cpp/include/scheduling/registry.hpp",
    "cpp/include/scheduling/io/result_writer.hpp",
    "cpp/apps/solver_run.cpp",
    "cpp/tests/smoke_test.cpp",
    "python/tools/generate_instances.py",
    "python/math_models/solve_cplex.py",
    "python/analysis/analyze_results.py",
    "configs/seeds/solve_seeds.txt",
    "docs/convergence_protocol.md",
    "AGENTS.md",
    "README.md",
]
BASH_SCRIPTS = [
    "scripts/build.sh",
    "scripts/generate_instances.sh",
    "scripts/run_single.sh",
    "scripts/run_batch.sh",
    "scripts/run_all.sh",
    "scripts/run_mip.sh",
    "scripts/analyze.sh",
    "scripts/audit.sh",
    "scripts/lib/allocate_result_root.sh",
]
FORBIDDEN_PATHS = [
    "python/solvers",
    "python/metaheuristics",
    "python/decoding",
    "cpp/include/scheduling/decoding/eval_cache.hpp",
    "cpp/include/scheduling/math_models/cplex_model.hpp",
    "cpp/src/math_models/cplex_model.cpp",
    "cpp/apps/cplex_run.cpp",
    "outputs/raw",
]
FORBIDDEN_TOKENS = ("gurobi", "gurobipy", "docplex", "evalcache", "eval_cache")


def read_seeds(relative: str) -> list[int]:
    path = ROOT / relative
    seeds: list[int] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        value = raw.split("#", 1)[0].strip()
        if not value:
            continue
        if not value.isdecimal():
            raise ValueError(f"invalid seed in {relative}: {value}")
        seeds.append(int(value))
    if not seeds:
        raise ValueError(f"{relative} contains no seeds")
    if len(seeds) != len(set(seeds)):
        raise ValueError(f"{relative} contains duplicate seeds")
    return seeds


def bash_syntax(script: Path) -> tuple[str, str]:
    bash = shutil.which("bash")
    if bash:
        run = subprocess.run([bash, "-n", str(script)], capture_output=True, text=True)
        return ("PASS", "bash -n") if run.returncode == 0 else ("FAIL", run.stderr.strip())
    if os.name == "nt" and shutil.which("wsl.exe"):
        converted = subprocess.run(
            ["wsl.exe", "wslpath", "-a", str(script)],
            capture_output=True,
            text=True,
        )
        if converted.returncode == 0:
            run = subprocess.run(
                ["wsl.exe", "bash", "-n", converted.stdout.strip()],
                capture_output=True,
                text=True,
            )
            return ("PASS", "wsl bash -n") if run.returncode == 0 else ("FAIL", run.stderr.strip())
    content = script.read_text(encoding="utf-8")
    static_ok = content.startswith("#!/usr/bin/env bash\n") and "set -euo pipefail" in content
    return ("NOT_RUN", "bash unavailable; static contract present") if static_ok else ("FAIL", "invalid Bash header")


def audit() -> list[tuple[str, str, str]]:
    checks: list[tuple[str, str, str]] = []
    missing = [path for path in REQUIRED + BASH_SCRIPTS if not (ROOT / path).is_file()]
    checks.append(("Required paths", "PASS" if not missing else "FAIL", ", ".join(missing) or "all present"))

    forbidden_paths = [path for path in FORBIDDEN_PATHS if (ROOT / path).exists()]
    checks.append(("Forbidden paths", "PASS" if not forbidden_paths else "FAIL", ", ".join(forbidden_paths) or "none"))

    script_ids: dict[str, list[str]] = {}
    for script in sorted((ROOT / "scripts").rglob("*.sh")):
        script_ids.setdefault(script.stem, []).append(str(script.relative_to(ROOT)))
    duplicate_ids = {key: value for key, value in script_ids.items() if len(value) > 1}
    formal_errors: list[str] = []
    formal_root = ROOT / "outputs" / "formal"
    if formal_root.is_dir():
        for result_dir in sorted(path for path in formal_root.iterdir() if path.is_dir()):
            test_id = result_dir.name.split("__", 1)[0]
            if test_id not in script_ids:
                rerun_base = re.sub(r"_\d+$", "", test_id)
                if rerun_base in script_ids:
                    test_id = rerun_base
            if test_id not in script_ids:
                formal_errors.append(f"{result_dir.name}: no matching scripts/**/{test_id}.sh")
    if duplicate_ids:
        formal_errors.extend(f"duplicate script id {key}: {value}" for key, value in duplicate_ids.items())
    checks.append(
        (
            "Formal script/result mapping",
            "PASS" if not formal_errors else "FAIL",
            "; ".join(formal_errors) or "all formal directory prefixes map to one script id",
        )
    )

    agents_text = (ROOT / "AGENTS.md").read_text(encoding="utf-8") if (ROOT / "AGENTS.md").is_file() else ""
    convergence_text = (
        (ROOT / "docs/convergence_protocol.md").read_text(encoding="utf-8")
        if (ROOT / "docs/convergence_protocol.md").is_file()
        else ""
    )
    rule_tokens = ("outputs/tmp/", "outputs/formal/", "T_init", "INIT", "IMPROVE", "100")
    missing_rules = [token for token in rule_tokens if token not in agents_text + convergence_text]
    checks.append(
        (
            "Output / convergence rules",
            "PASS" if not missing_rules else "FAIL",
            "rules present" if not missing_rules else "missing: " + ", ".join(missing_rules),
        )
    )

    token_hits: list[str] = []
    scan_roots = [ROOT / "cpp", ROOT / "python"]
    for scan_root in scan_roots:
        for path in sorted(scan_root.rglob("*")):
            if path.is_file() and path.suffix.lower() in {".hpp", ".cpp", ".py"}:
                lowered = path.read_text(encoding="utf-8").lower()
                if any(token in lowered for token in FORBIDDEN_TOKENS):
                    token_hits.append(str(path.relative_to(ROOT)))
    checks.append(("Forbidden core tokens", "PASS" if not token_hits else "FAIL", ", ".join(token_hits) or "none"))

    py_errors: list[str] = []
    silent: list[str] = []
    for path in sorted((ROOT / "python").rglob("*.py")):
        try:
            py_compile.compile(str(path), doraise=True)
            tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
            for node in ast.walk(tree):
                if isinstance(node, ast.ExceptHandler) and len(node.body) == 1 and isinstance(node.body[0], ast.Pass):
                    silent.append(str(path.relative_to(ROOT)))
        except (OSError, SyntaxError) as exc:
            py_errors.append(f"{path}: {exc}")
    checks.append(("Python / CPLEX syntax", "PASS" if not py_errors else "FAIL", "; ".join(py_errors) or "compiled"))
    checks.append(("Silent exception handlers", "PASS" if not silent else "FAIL", ", ".join(silent) or "none"))

    try:
        solve_seeds = read_seeds("configs/seeds/solve_seeds.txt")
        checks.append(("Fixed solve-seed contract", "PASS", f"rounds={len(solve_seeds)}"))
    except (OSError, ValueError) as exc:
        checks.append(("Fixed solve-seed contract", "FAIL", str(exc)))

    instance_errors: list[str] = []
    instance_count = 0
    for index_path in sorted((ROOT / "data").rglob("index.json")):
        instance_count += 1
        directory = index_path.parent
        try:
            metadata = json.loads(index_path.read_text(encoding="utf-8"))
            seed_text = (directory / "instance_seed.txt").read_text(encoding="utf-8").strip()
            if not seed_text.isdecimal() or int(seed_text) != metadata.get("instance_seed"):
                raise ValueError("instance_seed.txt and index.json disagree")
        except (OSError, ValueError, TypeError) as exc:
            instance_errors.append(f"{directory.relative_to(ROOT)}: {exc}")
    checks.append(
        (
            "Per-instance seed metadata",
            "PASS" if instance_count and not instance_errors else "FAIL",
            "; ".join(instance_errors) or f"checked {instance_count} instance(s)",
        )
    )

    bash_results = [bash_syntax(ROOT / relative) for relative in BASH_SCRIPTS]
    if any(status == "FAIL" for status, _ in bash_results):
        status = "FAIL"
    elif any(status == "NOT_RUN" for status, _ in bash_results):
        status = "NOT_RUN"
    else:
        status = "PASS"
    checks.append(("Bash syntax", status, "; ".join(sorted({note for _, note in bash_results}))))

    build = ROOT / "build"
    configure_command = ["cmake", "-S", str(ROOT), "-B", str(build)]
    if os.name == "nt":
        configure_command[1:1] = ["-G", "MinGW Makefiles"]
    configure = subprocess.run(configure_command, cwd=ROOT, capture_output=True, text=True)
    compile_result = (
        subprocess.run(
            ["cmake", "--build", str(build), "--config", "Release"],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        if configure.returncode == 0
        else configure
    )
    build_note = (compile_result.stdout or compile_result.stderr).strip()[-300:]
    checks.append(("CMake/C++ build", "PASS" if compile_result.returncode == 0 else "FAIL", build_note))

    ctest_env = os.environ.copy()
    ctest_env["SCHED_OUTPUT_ROOT"] = "outputs/tmp/smoke/audit"
    ctest = (
        subprocess.run(
            ["ctest", "--test-dir", str(build), "--output-on-failure"],
            cwd=ROOT,
            env=ctest_env,
            capture_output=True,
            text=True,
        )
        if compile_result.returncode == 0
        else compile_result
    )
    test_note = (ctest.stdout or ctest.stderr).strip()[-300:]
    checks.append(("C++ tests / CTest", "PASS" if ctest.returncode == 0 else "FAIL", test_note))
    cplex_import = subprocess.run(
        [os.environ.get("PYTHON", sys.executable), "-c", "import cplex"],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    checks.append(
        (
            "CPLEX Python API import",
            "PASS" if cplex_import.returncode == 0 else "NOT_RUN",
            "import cplex succeeded" if cplex_import.returncode == 0 else "IBM CPLEX Python API is not configured",
        )
    )
    checks.append(("CPLEX solve/license", "NOT_RUN", "run scripts/run_mip.sh on a licensed environment"))
    return checks


def main() -> None:
    checks = audit()
    overall = "FAIL" if any(status == "FAIL" for _, status, _ in checks) else "PASS"
    lines = [
        "# Project Audit",
        "",
        f"Overall: {overall}",
        "",
        "| Check | Result | Notes |",
        "|---|---|---|",
    ]
    for name, status, notes in checks:
        safe_notes = notes.replace("|", "\\|").replace("\n", " ")
        lines.append(f"| {name} | {status} | {safe_notes} |")
    (ROOT / "PROJECT_AUDIT.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    for name, status, notes in checks:
        print(f"{status} {name}: {notes}")
    raise SystemExit(1 if overall == "FAIL" else 0)


if __name__ == "__main__":
    main()

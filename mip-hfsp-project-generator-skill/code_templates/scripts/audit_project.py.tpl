"""Audit the generated project; never repair or rewrite solver results."""
from __future__ import annotations

import ast
import os
import py_compile
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "CMakeLists.txt",
    "cpp/include/hfsp/core/domain.hpp",
    "cpp/include/hfsp/registry.hpp",
    "cpp/apps/hfsp_run.cpp",
    "cpp/tests/smoke_test.cpp",
    "python/analysis/analyze_results.py",
    "AGENTS.md",
    "README.md",
]
FORBIDDEN = ["src", "gurobipy", "python/metaheuristics", "python/solvers"]


def audit() -> tuple[bool, list[tuple[str, bool, str]]]:
    checks: list[tuple[str, bool, str]] = []
    missing = [path for path in REQUIRED if not (ROOT / path).exists()]
    checks.append(("Required paths", not missing, ", ".join(missing) or "all present"))
    forbidden = [path for path in FORBIDDEN if (ROOT / path).exists()]
    checks.append(("Forbidden paths", not forbidden, ", ".join(forbidden) or "none"))
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
    checks.append(("Python auxiliary syntax", not py_errors, "; ".join(py_errors) or "compiled"))
    checks.append(("Silent exception handlers", not silent, ", ".join(silent) or "none"))
    build = ROOT / "build"
    configure_command = ["cmake", "-S", str(ROOT), "-B", str(build)]
    if os.name == "nt":
        configure_command[1:1] = ["-G", "MinGW Makefiles"]
    configure = subprocess.run(configure_command, cwd=ROOT, capture_output=True, text=True)
    compile_result = subprocess.run(["cmake", "--build", str(build), "--config", "Release"], cwd=ROOT, capture_output=True, text=True) if configure.returncode == 0 else configure
    checks.append(("CMake/C++ build", compile_result.returncode == 0, compile_result.stdout.strip()[-300:] or compile_result.stderr.strip()[-300:]))
    ctest = subprocess.run(["ctest", "--test-dir", str(build), "--output-on-failure"], cwd=ROOT, capture_output=True, text=True) if compile_result.returncode == 0 else compile_result
    checks.append(("C++ smoke / CTest", ctest.returncode == 0, ctest.stdout.strip()[-300:] or ctest.stderr.strip()[-300:]))
    return all(result for _, result, _ in checks), checks


def main() -> None:
    passed, checks = audit()
    lines = [
        "# Project Audit",
        "",
        f"Overall: {'PASS' if passed else 'FAIL'}",
        "",
        "| Check | Result | Notes |",
        "|---|---|---|",
    ]
    for name, result, notes in checks:
        safe_notes = notes.replace("|", "\\|").replace("\n", " ")
        lines.append(f"| {name} | {'PASS' if result else 'FAIL'} | {safe_notes} |")
    (ROOT / "PROJECT_AUDIT.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    for name, result, notes in checks:
        print(f"{'PASS' if result else 'FAIL'} {name}: {notes}")
    raise SystemExit(0 if passed else 1)


if __name__ == "__main__":
    main()

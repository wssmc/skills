"""对生成的基础 HFSP 项目执行可重复审计并生成 PROJECT_AUDIT.md。"""
from __future__ import annotations

import ast
import py_compile
import subprocess
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent
REQUIRED_PATHS = [
    "configs/problem_statement.md",
    "configs/problem_fingerprint.json",
    "data/generate.py",
    "data/loader.py",
    "src/core/domain.py",
    "src/metaheuristics/registry.py",
    "src/metaheuristics/decoding/list_decoder.py",
    "src/metaheuristics/decoding/feasibility_checker.py",
    "src/metaheuristics/decoding/eval_cache.py",
    "scripts/run_baselines.py",
    "tests/smoke_test.py",
    "AGENTS.md",
    "README.md",
]
FORBIDDEN_DIRS = [
    "src/algorithms",
    "src/solvers",
    "src/io",
    "src/evaluation",
]


def find_silent_handlers(path: Path) -> list[str]:
    findings = []
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    for node in ast.walk(tree):
        if isinstance(node, ast.ExceptHandler) and len(node.body) == 1 and isinstance(node.body[0], ast.Pass):
            findings.append(f"{path.relative_to(PROJECT_ROOT)}:{node.lineno}")
    return findings


def run_audit() -> tuple[bool, list[tuple[str, bool, str]]]:
    checks = []
    missing = [path for path in REQUIRED_PATHS if not (PROJECT_ROOT / path).exists()]
    checks.append(("Required paths", not missing, ", ".join(missing) or "all present"))

    forbidden = [path for path in FORBIDDEN_DIRS if (PROJECT_ROOT / path).exists()]
    checks.append(("Forbidden directories", not forbidden, ", ".join(forbidden) or "none"))

    syntax_errors = []
    silent_handlers = []
    for path in sorted(PROJECT_ROOT.rglob("*.py")):
        if "outputs" in path.parts:
            continue
        try:
            py_compile.compile(str(path), doraise=True)
            silent_handlers.extend(find_silent_handlers(path))
        except Exception as exc:
            syntax_errors.append(f"{path.relative_to(PROJECT_ROOT)}: {exc}")
    checks.append(("Python syntax", not syntax_errors, "; ".join(syntax_errors) or "compiled"))
    checks.append(("Silent exception handlers", not silent_handlers, ", ".join(silent_handlers) or "none"))

    smoke = subprocess.run(
        [sys.executable, str(PROJECT_ROOT / "tests" / "smoke_test.py")],
        cwd=PROJECT_ROOT,
        text=True,
        capture_output=True,
        check=False,
    )
    smoke_notes = smoke.stdout.strip().splitlines()[-1] if smoke.returncode == 0 else smoke.stderr.strip()
    checks.append(("Smoke test", smoke.returncode == 0, smoke_notes or f"exit={smoke.returncode}"))

    sys.path[:0] = [str(PROJECT_ROOT), str(PROJECT_ROOT / "src")]
    try:
        from metaheuristics.registry import ALGORITHM_REGISTRY, ALGORITHM_STATUS
        registry_ok = set(ALGORITHM_REGISTRY) == set(ALGORITHM_STATUS)
        registry_notes = f"registered={sorted(ALGORITHM_REGISTRY)}"
    except Exception as exc:
        registry_ok = False
        registry_notes = str(exc)
    checks.append(("Algorithm registry", registry_ok, registry_notes))
    return all(passed for _, passed, _ in checks), checks


def write_report(passed: bool, checks: list[tuple[str, bool, str]]) -> None:
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
    lines.append("")
    (PROJECT_ROOT / "PROJECT_AUDIT.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    passed, checks = run_audit()
    write_report(passed, checks)
    for name, result, notes in checks:
        print(f"{'PASS' if result else 'FAIL'} {name}: {notes}")
    raise SystemExit(0 if passed else 1)


if __name__ == "__main__":
    main()

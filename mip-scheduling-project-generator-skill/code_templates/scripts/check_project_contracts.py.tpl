"""Read-only checks of complete AGENTS rules, C++ module separation and formatting."""
from __future__ import annotations

import json
import os
import re
import shutil
import subprocess
from pathlib import Path


def check_rules(root: Path) -> tuple[str, str, str]:
    try:
        baseline = json.loads((root / "configs/required_agent_rules.json").read_text(encoding="utf-8"))
        sections = baseline["sections"]
        if not isinstance(sections, dict) or not sections:
            raise ValueError("empty rule baseline")
        text = " ".join((root / "AGENTS.md").read_text(encoding="utf-8").split())
        missing = [title for title, body in sections.items() if " ".join(body.split()) not in text]
        return ("AGENTS rule coverage", "FAIL" if missing else "PASS",
                "missing/modified sections: " + ", ".join(missing) if missing else f"{len(sections)} complete sections")
    except (OSError, ValueError, KeyError, TypeError, AttributeError) as exc:
        return "AGENTS rule coverage", "FAIL", str(exc)


def check_cpp(root: Path) -> list[tuple[str, str, str]]:
    sources = sorted(path for path in (root / "cpp").rglob("*")
                     if path.suffix in {".cpp", ".hpp", ".h"})
    # Contract-specific structural check, not a C++ parser: solve_* bodies are
    # conventionally named and must reside in separate algorithm source files.
    bodies = re.compile(r"\bSolveResult\s+(solve_\w+)\s*\([^;{}]*\)\s*\{")
    issues = []
    count = 0
    for path in sources:
        content = path.read_text(encoding="utf-8")
        names = bodies.findall(content)
        count += len(names)
        if len(names) > 1:
            issues.append(f"{path.relative_to(root)}: multiple algorithm bodies {names}")
        if names and (path.suffix != ".cpp" or "algorithms" not in path.parts):
            issues.append(f"{path.relative_to(root)}: algorithm body outside algorithms/*.cpp")
    if not count:
        issues.append("no solve_* implementation found; adapt structural check to documented project interface")
    checks = [("C++ module separation", "FAIL" if issues else "PASS",
               "; ".join(issues) or f"{count} separate algorithm bodies; review shared responsibilities manually")]
    formatter = shutil.which(os.environ.get("CLANG_FORMAT", "clang-format"))
    if not (root / ".clang-format").is_file():
        checks.append(("C++ formatting", "FAIL", "missing .clang-format"))
    elif not formatter:
        checks.append(("C++ formatting", "NOT_RUN", "clang-format unavailable; manual review required"))
    else:
        failures = []
        for path in sources:
            run = subprocess.run([formatter, "--style=file", "--dry-run", "--Werror", str(path)],
                                 capture_output=True, text=True)
            if run.returncode:
                failures.append(f"{path.relative_to(root)}: {run.stderr.strip()[:300]}")
        checks.append(("C++ formatting", "FAIL" if failures else "PASS",
                       "; ".join(failures) or f"{len(sources)} files checked"))
    return checks


def check_contracts(root: Path) -> list[tuple[str, str, str]]:
    return [check_rules(root), *check_cpp(root)]


if __name__ == "__main__":
    results = check_contracts(Path(__file__).resolve().parents[1])
    for name, status, note in results:
        print(f"{status} {name}: {note}")
    raise SystemExit(1 if any(status == "FAIL" for _, status, _ in results)
                     else 3 if any(status == "NOT_RUN" for _, status, _ in results) else 0)

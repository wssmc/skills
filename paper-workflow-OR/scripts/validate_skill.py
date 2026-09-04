#!/usr/bin/env python3
"""Validate the paper-workflow-or skill package before distribution."""

from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / "SKILL.md"
BILINGUAL_GLOSSARY = ROOT / "roles/translator/scheduling-terminology-zh-en.md"

REQUIRED = [
    SKILL,
    ROOT / "structures/scheduling-metaheuristic.md",
    ROOT / "writing-specification/abstract.md",
    ROOT / "writing-specification/introduction.md",
    ROOT / "writing-specification/related-work.md",
    ROOT / "writing-specification/problem-and-model.md",
    ROOT / "writing-specification/solution-method.md",
    ROOT / "writing-specification/experiments.md",
    ROOT / "writing-specification/conclusion.md",
    ROOT / "element-guidance/figures.md",
    ROOT / "element-guidance/tables.md",
    ROOT / "element-guidance/pseudocode.md",
    ROOT / "truthfulness/evidence-status.md",
    ROOT / "truthfulness/literature-and-novelty.md",
    ROOT / "truthfulness/code-method-consistency.md",
    ROOT / "truthfulness/experimental-results.md",
    BILINGUAL_GLOSSARY,
]

CJK = re.compile(r"[\u3400-\u9fff]")
PATH_REF = re.compile(r"`([^`\n]+\.md)`")


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    sys.exit(1)


def validate_frontmatter() -> None:
    text = SKILL.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        fail("SKILL.md must start with YAML frontmatter")
    parts = text.split("---", 2)
    if len(parts) < 3:
        fail("SKILL.md frontmatter is not closed")
    fm = parts[1]
    if "name:" not in fm or "description:" not in fm:
        fail("SKILL.md frontmatter must contain name and description")


def validate_required_files() -> None:
    missing = [str(p.relative_to(ROOT)) for p in REQUIRED if not p.exists()]
    if missing:
        fail("Missing required files: " + ", ".join(missing))
    if (ROOT / "examples").exists():
        fail("examples/ must not be included in the current package")


def validate_language() -> None:
    offenders = []
    for path in ROOT.rglob("*.md"):
        if path == BILINGUAL_GLOSSARY:
            continue
        text = path.read_text(encoding="utf-8")
        match = CJK.search(text)
        if match:
            line = text[: match.start()].count("\n") + 1
            offenders.append(f"{path.relative_to(ROOT)}:{line}")
    if offenders:
        fail("Non-English CJK text found outside the bilingual glossary: " + ", ".join(offenders))


def validate_refs() -> None:
    missing_refs = []
    for path in ROOT.rglob("*.md"):
        text = path.read_text(encoding="utf-8")
        for match in PATH_REF.finditer(text):
            ref = match.group(1)
            if "/" not in ref:
                continue
            target = ROOT / ref
            if not target.exists():
                missing_refs.append(f"{path.relative_to(ROOT)} -> {ref}")
    if missing_refs:
        fail("Missing referenced markdown files: " + "; ".join(missing_refs))


def main() -> None:
    validate_frontmatter()
    validate_required_files()
    validate_language()
    validate_refs()
    print("PASS: paper-workflow-or skill package is structurally valid.")


if __name__ == "__main__":
    main()

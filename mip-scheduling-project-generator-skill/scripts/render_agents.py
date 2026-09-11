"""Render the complete rule block from canonical templates, never an LLM summary."""
from __future__ import annotations

import argparse
import json
from pathlib import Path

TEMPLATES = Path(__file__).resolve().parents[1] / "code_templates"
BEGIN = "<!-- BEGIN REQUIRED RESEARCH RULES -->"
END = "<!-- END REQUIRED RESEARCH RULES -->"


def render() -> tuple[str, dict[str, str]]:
    text = (TEMPLATES / "AGENTS.md.tpl").read_text(encoding="utf-8")
    protocol = (TEMPLATES / "docs/convergence_protocol.md.tpl").read_text(encoding="utf-8")
    # Embed the complete protocol, with headings nested under the AGENTS section.
    body = protocol.split("\n", 1)[1].strip().replace("\n## ", "\n### ")
    if body.startswith("## "):
        body = "#" + body
    text = text.replace("{{CONVERGENCE_PROTOCOL}}", body)
    block = text.split(BEGIN, 1)[1].split(END, 1)[0].strip()
    sections: dict[str, str] = {}
    for section in ("\n" + block).split("\n## ")[1:]:
        title, content = section.split("\n", 1)
        sections[title] = content.strip()
    return text, sections


def write_project(root: Path) -> None:
    text, sections = render()
    destination = root / "AGENTS.md"
    # Existing user content must be merged explicitly rather than overwritten.
    if destination.exists():
        existing = destination.read_text(encoding="utf-8")
        template = (TEMPLATES / "AGENTS.md.tpl").read_text(encoding="utf-8")
        if existing not in (template, text):
            raise ValueError("AGENTS.md already customized; use --check and merge missing rules explicitly")
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(text, encoding="utf-8")
    baseline = root / "configs/required_agent_rules.json"
    baseline.parent.mkdir(parents=True, exist_ok=True)
    baseline.write_text(json.dumps({"schema_version": 1, "sections": sections},
                                   ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        _, sections = render()
        text = (args.project / "AGENTS.md").read_text(encoding="utf-8")
        normalized = " ".join(text.split())
        missing = [title for title, content in sections.items()
                   if " ".join(content.split()) not in normalized]
        if missing:
            raise SystemExit("FAIL missing/modified rules: " + ", ".join(missing))
        print("PASS canonical AGENTS rules")
    else:
        write_project(args.project)


if __name__ == "__main__":
    main()

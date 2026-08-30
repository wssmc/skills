#!/usr/bin/env python3
"""Validate the paper-workflow-or skill package."""

from __future__ import annotations

import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote


ROOT = Path(__file__).resolve().parents[1]
errors: list[str] = []


def fail(message: str) -> None:
    errors.append(message)


def read_utf8(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except (OSError, UnicodeError) as exc:
        fail(f"Cannot read {path.relative_to(ROOT)} as UTF-8: {exc}")
        return ""


for relative in ("SKILL.md", "manifest.json"):
    if not (ROOT / relative).is_file():
        fail(f"Missing required root file: {relative}")

skill_path = ROOT / "SKILL.md"
skill_text = read_utf8(skill_path) if skill_path.is_file() else ""

frontmatter_match = re.match(r"^---\n(.*?)\n---(?:\n|$)", skill_text, flags=re.S)
skill_name = ""
skill_version = ""
if not frontmatter_match:
    fail("SKILL.md has invalid or missing YAML frontmatter.")
else:
    frontmatter = frontmatter_match.group(1)
    name_match = re.search(r"^name:\s*([^\n]+?)\s*$", frontmatter, flags=re.M)
    description_match = re.search(r"^description:\s*([^\n]+?)\s*$", frontmatter, flags=re.M)
    version_match = re.search(
        r"^\s+version:\s*[\"']?([^\"'\n]+?)[\"']?\s*$",
        frontmatter,
        flags=re.M,
    )
    if not name_match:
        fail("SKILL.md frontmatter is missing name.")
    else:
        skill_name = name_match.group(1).strip("\"'")
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", skill_name):
            fail(f"Skill name is not lowercase hyphen-case: {skill_name}")
    if not description_match or not description_match.group(1).strip():
        fail("SKILL.md frontmatter is missing a non-empty one-line description.")
    if not version_match:
        fail("SKILL.md metadata is missing version.")
    else:
        skill_version = version_match.group(1).strip()

manifest_path = ROOT / "manifest.json"
manifest: dict[str, object] = {}
if manifest_path.is_file():
    try:
        parsed = json.loads(read_utf8(manifest_path))
        if not isinstance(parsed, dict):
            fail("manifest.json root must be an object.")
        else:
            manifest = parsed
    except json.JSONDecodeError as exc:
        fail(f"manifest.json is invalid JSON: {exc}")

if manifest:
    if manifest.get("name") != skill_name:
        fail("manifest.json name does not match SKILL.md name.")
    if str(manifest.get("version", "")) != skill_version:
        fail("manifest.json version does not match SKILL.md metadata.version.")
    if manifest.get("main_file") != "SKILL.md":
        fail("manifest.json main_file must be SKILL.md.")
    languages = manifest.get("languages")
    if not isinstance(languages, list) or not {"en", "zh-CN"}.issubset(languages):
        fail("manifest.json languages must include en and zh-CN.")

reference_root = ROOT / "references"
en_files = {path.name for path in (reference_root / "en").glob("*.md")}
zh_files = {path.name for path in (reference_root / "zh").glob("*.md")}
if not en_files:
    fail("No English references found.")
if en_files != zh_files:
    missing_zh = sorted(en_files - zh_files)
    missing_en = sorted(zh_files - en_files)
    if missing_zh:
        fail(f"Missing Chinese mirror references: {', '.join(missing_zh)}")
    if missing_en:
        fail(f"Missing English mirror references: {', '.join(missing_en)}")

markdown_link_pattern = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
linked_relative_paths: set[str] = set()
for markdown_path in ROOT.rglob("*.md"):
    markdown = read_utf8(markdown_path)
    for raw_target in markdown_link_pattern.findall(markdown):
        target = raw_target.strip().split()[0]
        if not target or target.startswith(("#", "http://", "https://", "mailto:")):
            continue
        target = unquote(target.split("#", 1)[0])
        candidate = (markdown_path.parent / target).resolve()
        try:
            candidate.relative_to(ROOT)
        except ValueError:
            fail(
                f"Link escapes the skill package in {markdown_path.relative_to(ROOT)}: "
                f"{raw_target}"
            )
            continue
        if not candidate.is_file():
            fail(
                f"Broken link in {markdown_path.relative_to(ROOT)}: {raw_target}"
            )
        elif markdown_path == skill_path:
            linked_relative_paths.add(candidate.relative_to(ROOT).as_posix())

for filename in sorted(en_files):
    expected = f"references/en/{filename}"
    if expected not in linked_relative_paths:
        fail(f"English reference is not routed from SKILL.md: {expected}")

for template_path in sorted((ROOT / "templates").glob("*.md")):
    expected = template_path.relative_to(ROOT).as_posix()
    if expected not in linked_relative_paths:
        fail(f"Template is not routed from SKILL.md: {expected}")

for markdown_path in ROOT.rglob("*.md"):
    markdown = read_utf8(markdown_path)
    fences = len(re.findall(r"^[ \t]*(?:`{3,}|~{3,})", markdown, flags=re.M))
    if fences % 2:
        fail(f"Unbalanced Markdown code fence: {markdown_path.relative_to(ROOT)}")

if errors:
    print("Validation failed:")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print("paper-workflow-or validation passed.")
print(f"Root: {ROOT}")
print(f"References per language: {len(en_files)}")
print(f"Templates routed: {len(list((ROOT / 'templates').glob('*.md')))}")
print(f"Markdown files: {sum(1 for _ in ROOT.rglob('*.md'))}")

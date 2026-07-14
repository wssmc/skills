#!/usr/bin/env python3
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
required_root = ['SKILL.md', 'README.md', 'CHANGELOG.md', 'MANIFEST.md']
mirrors = [
    'intake-and-routing.md',
    'manuscript-architecture.md',
    'introduction-and-related-work.md',
    'problem-model-and-complexity.md',
    'solution-method.md',
    'computational-study.md',
    'figures-and-tables.md',
    'audit-and-integrity.md',
    'latex-project-editing.md',
    'polishing-and-translation.md',
]
errors = []

for name in required_root:
    if not (ROOT / name).is_file():
        errors.append(f'Missing root file: {name}')

skill = ROOT / 'SKILL.md'
if skill.is_file():
    text = skill.read_text(encoding='utf-8')
    if not text.startswith('---\n'):
        errors.append('SKILL.md is missing YAML front matter.')
    for key in ['name: paper-workflow-OR', 'description:', 'version:']:
        if key not in text:
            errors.append(f'SKILL.md front matter missing: {key}')

for lang in ['en', 'zh']:
    for name in mirrors:
        if not (ROOT / 'references' / lang / name).is_file():
            errors.append(f'Missing {lang} reference: {name}')

for path in ROOT.rglob('*.md'):
    text = path.read_text(encoding='utf-8')
    fences = len(re.findall(r'^```', text, flags=re.M))
    if fences % 2:
        errors.append(f'Unbalanced Markdown code fence: {path.relative_to(ROOT)}')

if errors:
    print('Validation failed:')
    for err in errors:
        print(f'- {err}')
    sys.exit(1)

print('paper-workflow-OR validation passed.')
print(f'Root: {ROOT}')
print(f'Markdown files: {sum(1 for _ in ROOT.rglob("*.md"))}')

# paper-workflow-OR

`paper-workflow-OR` is a bilingual Codex/ChatGPT skill for method-driven operations research papers. It supports architecture design, manuscript drafting, direct LaTeX revision, academic English polishing, Chinese-English translation, external literature research, figure/table caption planning, and full manuscript audits.

## Default behavior

- Domain: operations research and optimization only.
- Default manuscript output: English.
- Discussion language: follows the user.
- Chinese and English rule sets: included under `references/zh` and `references/en`.
- Missing project information: ask a concise grouped intake question before drafting.
- Target journal: ask first; inspect a supplied journal LaTeX template before restructuring.

## Installation

Copy the `paper-workflow-OR` directory into the skills directory used by your agent environment. Keep `SKILL.md` at the package root.

## Main package structure

```text
paper-workflow-OR/
├── SKILL.md
├── README.md
├── CHANGELOG.md
├── MANIFEST.md
├── references/
│   ├── en/
│   └── zh/
├── templates/
├── examples/
└── scripts/
```

## Validation

Run:

```bash
python scripts/validate_skill.py
```

The validator checks the package structure, front matter, bilingual mirror files, and unresolved malformed Markdown fences.

## Evidence policy

The skill never fabricates references, experiment results, statistical significance, hardware, algorithm components, or real-case claims. Planning language is kept distinct from completed-study language.

# paper-workflow-or

`paper-workflow-or` is a bilingual skill for method-driven operations-research manuscripts. It routes architecture, drafting, revision, direct LaTeX editing, polishing/translation, literature/evidence work, and integrity audits while preserving the problem-model-method-evidence chain.

## Default behavior

- Domain: operations research and optimization only.
- Default manuscript output: English.
- Discussion language: follows the user.
- Chinese and English rule sets: included under `references/zh` and `references/en`.
- Missing information: inspect supplied material first, then ask only for blockers to the requested deliverable.
- Target journal/template: apply when relevant to the requested scope; a supplied official template overrides generic structure.
- Evidence: distinguish provided, verified, derivable, planned, missing, and prohibited-to-infer content.

## Installation

The skill's canonical name is `paper-workflow-or`. This repository retains the legacy folder spelling `paper-workflow-OR` for path compatibility; when installing elsewhere, prefer a `paper-workflow-or` directory. Keep `SKILL.md` and `manifest.json` at the package root.

## Main package structure

```text
paper-workflow-or/
├── SKILL.md
├── manifest.json
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

The package validator checks frontmatter/manifest consistency, bilingual mirror sets, routed references/templates, local links, and Markdown fences. The standard skill validator should also pass.

## Evidence policy

The skill never fabricates references, experiment results, statistical significance, hardware, algorithm components, or real-case claims. Planning language is kept distinct from completed-study language, and material neutral/adverse evidence is not selectively hidden.

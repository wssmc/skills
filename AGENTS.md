# AGENTS.md — Skills Repository

## What this repo is

A collection of OpenCode skills for scheduling/OR research. **Not a code project** — no build, test, lint, or typecheck system.

## Skill chain (use in order)

```
problem-decomposition-skill
  → literature-matrix-review-skill-v2.1
    → mip-hfsp-project-generator-skill
```

- `problem-decomposition-skill` — refine vague ideas into structured problem description + `problem_fingerprint.json`
- `literature-matrix-review-skill-v2.1` — literature search, matrix construction, gap reasoning, baseline suggestions
- `mip-hfsp-project-generator-skill` — generate Gurobi-based HFSP research project (src, data, scripts, LaTeX)

## Other skills (standalone)

| Skill | Entry | Notes |
|---|---|---|
| `code-reading-assistant-skill` | `SKILL.md` | Lightweight code reading helper |
| `paper-workflow-or` | `paper-workflow-OR/SKILL.md` | Bilingual OR paper writing; repository folder keeps its legacy spelling. Validate with `python scripts/validate_skill.py` |
| `paper-repro-agent-skills` | `README.md` | 4 sub-skills for reproducing scheduling papers (0→flow-reconstruction, 1→reproduction, 2→verification, 3→adaptation) |
| `scheduling-writing-workflow` | `要求.md` | Writing tips for scheduling papers (Chinese) |
| `thirdPartSkills` | `thirdPartSkills.md` | Catalog of external OR/scheduling skills |

## Key conventions

- **Primary language**: zh-CN (Chinese). `paper-workflow-or` is bilingual (en/zh).
- **Each skill is self-contained**: `manifest.json` + `SKILL.md` + optional templates/examples.
- **No lockfiles, no dev server, no CI** — this repo only stores skill definitions.
- **Direct push to `main`** — no PR workflow. Commit messages in simple English.
- **`.gitignore`** excludes `mip-hfsp-project-generator-skill/项目通用结构总结.md` and `*revision_plan.md`.

## If unsure

Read `README.md` for the skill chain, then `manifest.json` for inputs/outputs, then `SKILL.md` for the actual instructions.

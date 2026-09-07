# Upstream Contract for mip-hfsp-project-generator-skill

This skill should prefer inputs produced by the first two skills in the chain:

```text
problem-decomposition-skill
→ literature-matrix-review-skill-v2.1
→ mip-hfsp-project-generator-skill
```

## From problem-decomposition-skill

```text
refined_problem_description.md
problem_fingerprint.json
modeling_elements.md
assumption_log.md
open_questions.md
data_requirement.md
handoff_to_mip_skill.md
```

Use these files to define:

- problem type;
- data format;
- sets and parameters;
- objective;
- constraints;
- assumptions;
- extension points.

## From literature-matrix-review-skill-v2.1

```text
problem_feature_table.md
method_matrix_table.md
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
paper_reading_cards.md
```

Use these files to define:

- constraints that must be implemented;
- baseline algorithms;
- proposed algorithm modules;
- ablation variants;
- experiment settings;
- contribution-oriented visualizations.

## Rules

- Do not ignore `assumption_log.md`; assumptions should appear in README and `configs/` docs.
- If `problem_feature_table.md` marks a feature as central to this study, implement it or create a clearly named extension stub.
- If `recommended_baselines.md` is present, create corresponding C++ files under `cpp/src/metaheuristics/baselines/`.
- If `method_design_hints.md` is present, create corresponding C++ modules under `cpp/src/metaheuristics/{algo}/`.
- Default solver is **Gurobi C++ API**, not CPLEX/docplex; Python `gurobipy` is not a core fallback.
- All algorithms must be registered to `cpp/include/hfsp/registry.hpp` and `cpp/src/registry.cpp`.
- Python is limited to `python/tools/`, `python/analysis/`, `python/statistics/` and `python/visualization/`; it must not implement a second solver or decoder.
- The generated root `AGENTS.md` is the project-level system prompt and must be read before generation, edits or audits.
- Algorithm naming follows basic → study → branch three-tier convention.

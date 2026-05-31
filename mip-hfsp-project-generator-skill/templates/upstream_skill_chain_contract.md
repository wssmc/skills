# Upstream Contract for mip-hfsp-project-generator-skill

This skill should prefer inputs produced by the first two skills in the chain:

```text
problem-decomposition-skill
→ literature-matrix-review-skill
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

## From literature-matrix-review-skill

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

- Do not ignore `assumption_log.md`; assumptions should appear in README and config files.
- If `problem_feature_table.md` marks a feature as central to this study, implement it or create a clearly named extension stub.
- If `recommended_baselines.md` is present, create corresponding files under `src/algorithms/baselines/`.
- If `method_design_hints.md` is present, create corresponding modules under `src/algorithms/proposed/`.

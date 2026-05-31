# Downstream Contract: literature-matrix-review-skill → mip-hfsp-project-generator-skill

The literature skill should export the following outputs for MIP and algorithm implementation:

```text
problem_feature_table.md
method_matrix_table.md
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
paper_reading_cards.md
references.bib
```

## What the MIP skill should use

- `problem_feature_table.md`: decide which constraints must be implemented.
- `method_matrix_table.md`: decide baseline and proposed algorithm components.
- `novelty_gap_summary.md`: decide what is the claimed contribution.
- `recommended_baselines.md`: generate scripts under `algorithms/baselines/`.
- `method_design_hints.md`: generate modules under `algorithms/proposed/`.

## Rules

- If a constraint is central to the novelty gap, mark it as `must_implement`.
- If a baseline is repeatedly used in related papers, mark it as `recommended_baseline`.
- If a method component is only inspired by literature, mark it as `optional_design_hint`.

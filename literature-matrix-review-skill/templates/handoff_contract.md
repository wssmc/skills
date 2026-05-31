# Skill Handoff Contract

## From problem-decomposition-skill to literature-matrix-review-skill

Expected files:

```text
refined_problem_description.md
problem_fingerprint.json
assumption_log.md
open_questions.md
```

The literature skill should use `problem_fingerprint.json` to generate search terms and use `refined_problem_description.md` as the narrative problem statement.

## From literature-matrix-review-skill to mip-hfsp-project-generator-skill

Expected files:

```text
problem_fingerprint.json
problem_feature_table.md
method_matrix_table.md
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
```

The implementation skill should use these outputs to:

- choose baseline algorithms;
- design encoding / decoding;
- identify constraints that must be implemented;
- align experiments with the literature;
- write result comparison sections.

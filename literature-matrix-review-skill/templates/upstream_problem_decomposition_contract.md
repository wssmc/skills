# Upstream Contract: problem-decomposition-skill → literature-matrix-review-skill

The literature skill should first look for the following upstream outputs:

```text
refined_problem_description.md
problem_fingerprint.json
assumption_log.md
open_questions.md
handoff_to_literature_skill.md
```

## Priority of inputs

1. `problem_fingerprint.json` is the primary structured input.
2. `refined_problem_description.md` is the primary narrative input.
3. `assumption_log.md` tells which items are assumptions rather than confirmed facts.
4. `open_questions.md` tells which items should be treated as uncertain.
5. `handoff_to_literature_skill.md` provides initial keywords and screening rules.

## Rules

- Do not treat assumptions as confirmed facts in review tables.
- If a constraint is unclear, use `Unclear` instead of `Yes`.
- Search queries should be generated from problem type, objective, constraints and method direction.
- The final outputs should be suitable for handoff to `mip-hfsp-project-generator-skill`.

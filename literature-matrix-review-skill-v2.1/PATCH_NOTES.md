# Patch Notes: v2 → v2.1

## Main changes requested by user

1. Chapter 3 should be handled separately as problem description rather than overloaded with all modeling/method details.
2. Chapter 2 should contain a compressed paper-ready literature matrix, not the full internal matrix.
3. Literature search must mark potential baseline papers during screening.
4. Chapter 5 should only provide an experiment framework before real data/results are available. Only Section 5.1 can be drafted in advance.
5. Chapter 4 should be written by the researcher; this skill only provides checklists and interfaces.

## Files added

```text
templates/problem_feature_table_paper.md
templates/baseline_candidates.csv
templates/section_3_problem_description_outline.md
templates/section_4_model_or_method_checklist.md
templates/experiment_section_framework.md
templates/baseline_comparison_plan.md
templates/ablation_plan.md
templates/sensitivity_analysis_plan.md
templates/result_table_templates.md
```

## Manual patch steps

```bash
cp -r literature-matrix-review-skill-v2.1/* skills/literature-matrix-review-skill/
git add skills/literature-matrix-review-skill
git commit -m "Upgrade literature matrix review skill to v2.1"
```

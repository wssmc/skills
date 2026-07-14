# Figures and tables

This version prioritizes figure/table necessity, evidence role, manuscript location, and caption naming. Use sentence case and noun-phrase captions. End captions with a period when the journal style does so.

## Default figure/table set

### Related work

- Literature matrix: `Table X. Comparison of representative related studies and this study.`

### Problem and formulation

- `x` illustrative-instance input tables: `Table X. [Data category] of the illustrative instance.`
- One explanatory Gantt/network/route figure.
- Notation table: `Table X. Notation for the MIP model.`

### Solution method

- Overall framework: `Figure X. Overall framework of the proposed [method name].`
- Optional mechanism illustration when text/pseudocode is insufficient.

### Parameter calibration

- parameter levels;
- DOE combinations and responses;
- main-effects plot;
- factor-response analysis.

### Overall performance

- algorithm comparison table(s);
- statistical comparison table;
- convergence curve;
- small-scale exact/reference comparison when applicable.

### Component analysis

- at least one controlled comparison table or plot for each central claimed component when feasible.

## Caption grammar patterns

Tables:

- `Comparison of ...`
- `Levels of ...`
- `Notation for ...`
- `... of the illustrative instance`
- `... under [setting]`
- `Statistical comparison of ...`
- `Sensitivity results under ...`

Figures:

- `Overall framework of ...`
- `Overall workflow of ...`
- `Illustration of ...`
- `Main effects plot for ...`
- `Representative convergence behavior under ...`
- `[Metric] improvement of ... over ...`
- `Sensitivity of ... to ...`

Avoid generic captions such as `Experimental results`, `Algorithm comparison`, `Ablation results`, or `Example` without objects and conditions.

## Source-derived caption library

The following naming patterns were extracted from the source LaTeX manuscript and generalized where needed:

1. `Comparison of representative related studies and this study.`
2. `Processing times and due windows of the illustrative instance.`
3. `Machine unavailability periods of the illustrative instance.`
4. `Gantt chart for permutation sequence [solution sequence] in the example.`
5. `Notation for the MIP model.`
6. `Overall framework of the proposed two-phase solution approach.`
7. `Illustration of the two-phase schedule construction and refinement mechanisms.`
8. `Levels of the calibrated [algorithm name] parameters.`
9. `Orthogonal parameter combinations and average response values of [algorithm name].`
10. `Main effects plot for the mean normalized objective.`
11. `Factor-response analysis for the mean normalized objective.`
12. `Algorithm comparison on large-scale instances under [setting].`
13. `Representative convergence behavior under [selected scenario combinations].`
14. `Small-scale comparison between [exact model] and [proposed algorithm].`
15. `Comparison of initialization rules.`
16. `Comparison of [component] strategies.`
17. `[Performance metric] improvement of different [component] strategies over [ablation baseline].`
18. `[Component] comparison under all [scenario families].`

## Caption audit

For every caption, verify:

- the compared objects are named;
- the metric or evidence type is clear;
- the experimental setting is included when needed;
- abbreviations are defined in the text/table note;
- the caption does not overstate significance or causality;
- manuscript text cites and interprets the item;
- numbers match the source result file and all manuscript mentions.

## Figure/table discussion pattern

Use:

```text
introduce the question answered
-> identify the displayed data/metrics
-> report the dominant result
-> compare important methods/settings
-> explain the mechanism or trade-off
-> state the bounded conclusion
```

Do not narrate every cell or point. Do not infer a mechanism from a plot without supporting analysis.

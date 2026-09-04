# Figures Guidance

Before writing about a figure, confirm:
- research question;
- x-axis;
- y-axis;
- experimental unit;
- aggregation;
- metric direction;
- series/color/marker meaning;
- plotted population;
- related experiment/table.

If these semantics are unknown, do not produce a formal scientific interpretation.

## Common figure types

| Figure type | Main purpose | Main narrative focus |
|---|---|---|
| Problem/process structure | explain entities, flow, constraints | objects, links, structural difficulty |
| Gantt chart | show schedule feasibility/structure | assignment, order, waiting, special constraints, objective |
| Algorithm flowchart | show control/information flow | main loop, trigger, return path, stopping |
| Representation/neighborhood illustration | show before/after transformation | selected objects, move, feasibility |
| Boxplot | compare distributions | median, IQR, overlap, outliers |
| Heatmap | compare two-dimensional result pattern | dominant regions, reversals, scale pattern |
| Convergence curve | compare search evolution | initial quality, early improvement, crossing, stagnation, final quality |
| Sensitivity/main-effects plot | show response vs factor | trend, turning point, stable/sensitive region |
| Bar chart | compare discrete categories | ranking, magnitude gap, near ties |
| Scatter plot | show relationship | association, clusters, dispersion, outliers |
| Critical-difference diagram | show rank groups | average ranks, statistically indistinguishable groups |

## Problem/process structure diagram

Narrative order:

```text
what the diagram represents
→ what nodes/links mean
→ key relation
→ how the relation changes scheduling feasibility/decisions
```

Sentence stems:

> `Figure X illustrates the operational structure of the considered problem.`

> `A directed link from A to B indicates that ...`

> `Unlike the technological precedence within a job, these links represent ...`

## Gantt chart

Confirm:
- time unit;
- row meaning;
- bar meaning;
- color/label meaning;
- whether the schedule is illustrative, optimal, best heuristic, or real-case.

Narrative order:

```text
schedule scope/objective
→ machine assignment
→ technological order
→ waiting/release constraints
→ resource competition
→ objective formation
```

Sentence stems:

> `Figure X presents a feasible schedule for the illustrative instance, with an objective value of ...`

> `The delayed start of operation ... is caused by ... rather than machine unavailability.`

> `The schedule therefore illustrates how ... and ... jointly determine ...`

## Algorithm flowchart

Do not narrate every box.

Use:

> `Figure X summarizes the overall search flow of the proposed algorithm.`

> `After initialization, the method repeatedly ...`

> `When [trigger] is satisfied, [mechanism] is invoked before control returns to the main search.`

## Representation/neighborhood illustration

Narrative order:

```text
before state
→ selected element(s)
→ transformation
→ feasibility restriction
→ resulting candidate
```

## Boxplot

Confirm what one observation represents.

Instance-level boxplot:
- one observation = one instance-level aggregate;
- dispersion describes between-instance behavior.

Run-level boxplot:
- one observation = one independent run;
- dispersion reflects run-level variability (and possibly mixed instance effects if pooled).

Reading order:

```text
metric/unit
→ median/mean
→ IQR
→ distribution shift/overlap
→ outliers
→ connection to aggregate table
→ bounded conclusion
```

Sentence stems:

> `Figure X compares the distribution of [metric] across [experimental units] for the evaluated algorithms.`

> `[Method A] exhibits the lowest median [metric], followed by [Method B].`

> `The comparatively narrow interquartile range of [Method A] indicates more consistent performance across the tested instances.`

> `Although the two distributions overlap, the central mass of [Method A] remains shifted toward lower values.`

> `This distributional pattern is consistent with the aggregate [metric] reported in Table X.`

Example paragraph:

> `Figure X compares the distribution of instance-level mean RPD across the evaluated Small instances, with lower values indicating better solution quality. Method A exhibits the lowest median and mean RPD, while Method B forms the nearest competing distribution. In addition to its lower central tendency, Method A shows a relatively compact interquartile range, indicating more consistent performance across the tested instances. The two distributions partially overlap, so the advantage is not uniform on every instance; however, the central mass of Method A remains shifted toward lower RPD values. A few high-RPD outliers persist, showing that some instances remain difficult. Overall, the distributional evidence is consistent with the aggregate ARPD reported in Table X and suggests that the observed advantage is broadly distributed rather than driven by only a few favorable cases.`

## Heatmap

Confirm rows, columns, cell metric, color direction, and aggregation.

Sentence stems:

> `Figure X summarizes the group-level [metric], with rows representing [groups] and columns representing [methods].`

> `[Method A] maintains the best or near-best values across most groups, indicating that its aggregate advantage is not confined to a narrow subset.`

> `A reversal appears in [group], where [Method B] becomes competitive.`

## Convergence curve

Confirm:
- x-axis = CPU / wall time / evaluations / iterations / normalized time;
- whether initialization is included;
- y-axis = current / best-so-far / mean / median / RPD / objective;
- single run vs aggregated curve.

Narrative order:

```text
initial quality
→ early improvement
→ crossing
→ stagnation
→ late improvement
→ final quality
→ effort-quality implication
```

Sentence stems:

> `Figure X compares the best-so-far [metric] as a function of [search effort].`

> `[Method B] reaches an early plateau, whereas [Method A] continues to improve in the later search stage.`

Do not call an algorithm computationally faster unless the x-axis is a comparable effort measure.

## Critical-difference diagram

Do not equate better rank with statistical significance.

Use:

> `[Method A] obtains the best average rank; however, the connection between [A] and [B] indicates that their difference is not statistically distinguishable under the adopted procedure.`

## Figure discussion checklist

- semantics confirmed;
- experimental unit confirmed;
- aggregation confirmed;
- metric direction confirmed;
- dominant pattern stated;
- material exception reported;
- observation separated from explanation;
- conclusion limited to plotted data.

# Tables Guidance

Before discussing a table, confirm:
- what one row represents;
- what one column represents;
- aggregation level;
- reference value for RPD/ARPD;
- W/T/L comparator and tie rule;
- runtime definition;
- meaning of `TL`, `NA`, `—`, `*`, bold, underline.

## Common table types

| Table type | Main purpose | Narrative focus |
|---|---|---|
| Literature comparison | position research gap | covered/uncovered technical dimensions |
| Notation | define symbols | lookup only, not row-by-row prose |
| Illustrative instance | reconstruct small example | data needed for structure/Gantt |
| Instance generation | summarize benchmark | factors, scale, grouping, counts |
| Parameter / Taguchi | calibration design | tested factors/levels and final setting |
| Baseline configuration | comparison transparency | source, parameters, adaptation |
| MIP comparison | exact/reference comparison | optimum/incumbent/bound/gap/time |
| Main performance | primary algorithm comparison | overall, strongest baseline, scale pattern, reversal |
| Statistical | inferential support | ranks, W/T/L, p-values/effects |
| Component analysis | mechanism evidence | full/remove/replace/alternative effect |

## Literature comparison table

Do not narrate each row.

Use:

> `Table X compares representative studies in terms of [problem dimensions].`

> `Most existing studies address [A] or [B] separately, whereas only a limited subset includes [C].`

> `The closest studies share [structure] with the present problem but differ in [key dimension].`

## Instance-generation table

Discuss:
- benchmark size;
- factor levels/ranges;
- Small/Large grouping;
- coverage of key problem characteristics.

## Baseline-configuration table

Recommended columns:
- Algorithm;
- Reference;
- Implementation source;
- Main parameters;
- Parameter source;
- Adaptation.

Use:

> `Published parameter values are retained whenever directly applicable; problem-specific adaptations are limited to ...`

## MIP comparison table

Discuss:

```text
certified-optimal count
→ heuristic deviation on certified optima
→ exact-solver time/gap growth
→ time-limit cases
→ bounded conclusion
```

Do not call a time-limit incumbent an optimum.

## Main performance table

Use:

```text
overall
→ strongest comparator
→ group/scale pattern
→ tie/reversal
→ runtime-quality trade-off if relevant
→ conclusion
```

Sentence stems:

> `[Method A] achieves the lowest overall ARPD, followed by [Method B].`

> `The performance gap is modest on smaller groups but becomes more pronounced as scale increases.`

> `A notable reversal occurs in group ...`

## Statistical table

Report:
- test;
- analysis unit;
- ranks/effect;
- adjusted p-value when applicable;
- practical interpretation.

Do not report p-values without explaining what comparison they support.

## Component-analysis table

Discuss:
- controlled variant;
- magnitude of quality change;
- cost change;
- scale dependence;
- statistical support;
- whether the evidence is positive, neutral, or negative.

Use direct wording when a component is not supported:

> `The comparison provides no clear evidence that component C improves the complete method under the tested setting.`

## Table discussion checklist

- row/column semantics confirmed;
- aggregation confirmed;
- comparator/reference confirmed;
- no row-by-row reading;
- strongest baseline identified;
- material tie/reversal reported;
- runtime and quality interpreted separately;
- conclusion limited to table scope.

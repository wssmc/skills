# Figures and tables

Select figures and tables by evidence function, then follow the target journal's placement and caption style. Sentence-case noun phrases are a useful default, not a universal rule.

## Evidence-first selection

| Evidence need | Candidate artifact | Omit or merge when |
|---|---|---|
| Structured literature positioning | Literature matrix | prose already exposes the comparison or coding is unverified/sparse |
| Problem/feasibility explanation | illustrative data table plus schedule/network/route/timeline | the problem and mapping from inputs to a feasible solution are already transparent |
| Dense notation | notation table | symbols are few and locally defined |
| Method interfaces/information flow | framework or mechanism figure | concise prose/pseudocode is clearer |
| Parameter selection | calibration design/results table or effects plot | parameters were not empirically calibrated or the artifact adds no decision evidence |
| Overall performance | comparison table/plot | a more compact artifact answers the same question without hiding variability |
| Statistical uncertainty | interval/distribution plot or test table | the claim is descriptive and the design does not support inferential analysis |
| Search behavior | convergence/profile plot | effort is not comparable or selected instances would be misleading |
| Component contribution | controlled ablation/factorial comparison | the component cannot be isolated; then narrow causal language |
| Practical stability | case, sensitivity, or robustness artifact | no corresponding practical or robustness claim is made |

Every main artifact should answer one stated question. Prefer one well-designed artifact over several views of the same result, and retain enough source data or identifiers to audit every plotted/table value.

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

## Caption, canvas, and in-text roles

- **Canvas:** normally keep only axes/units, legend, panel labels, reference lines/bands, and essential annotations. Omit a redundant in-figure title unless the outlet or another use case requires it.
- **Caption:** identify the object/artifact, comparison or mechanism, data/instance/scenario scope, and any nonstandard encoding needed to interpret it. Add metric direction or uncertainty meaning only when not clear from axes/legend/notes.
- **In-text reference:** state the question answered before interpreting the dominant observation, material exceptions, uncertainty, and bounded implication.
- **Table notes:** define abbreviations, denominators, significance markers, tie/best-value formatting, and missing-value codes below the table rather than inside its title.

Do not repeat the same phrase in an in-figure title, caption, and first in-text sentence. A concise caption can be enough when axes, legend, and nearby text already provide the details.

Examples to adapt, not copy mechanically:

- `Comparison of representative related studies and this study.`
- `Notation for the MIP model.`
- `Overall framework of the proposed [method name].`
- `Algorithm comparison on [instance group] under equal [time/evaluation] budgets.`
- `Time-normalized convergence profiles on [selection rule or instance group].`
- `Effect of [component] on [metric] across [scope].`

## Caption audit

For every caption, verify:

- the compared objects are named;
- the metric or evidence type is clear;
- the experimental setting is included when needed;
- abbreviations are defined in the text/table note;
- the caption does not overstate significance or causality;
- manuscript text cites and interprets the item;
- numbers match the source result file and all manuscript mentions.
- panel/series selection does not conceal material counterexamples or failed runs;
- color, line style, symbols, and ordering remain distinguishable in print and accessible rendering.

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

# Fixed-title Chapter 5 blueprint for scheduling heuristics

Use this house branch for computational evaluation of scheduling heuristics or metaheuristics unless the target journal or an existing manuscript fixes a different structure. The titles define experimental responsibilities; they are not claimed to be universal literature numbering. The numbers below show the full default branch. Keep the English titles for every retained module, omit unsupported conditional modules, and renumber consecutively only after the evidence plan is settled.

## Chapter 5: `Computational Experiments`

| No. | Fixed English section title | What it must establish | Main evidence artifact |
|---|---|---|---|
| 5.1 | `Experimental Setup` | Research questions; benchmark/generated/real-data roles and provenance; instance groups; implementation environment; stopping and computing budgets; seeds and repetitions; comparator rationale; metrics, formulas, direction, and analysis unit. | `Benchmark instances and experimental roles` plus `Implementation and evaluation protocol`. |
| 5.2 | `Parameter Calibration` | Factors and ranges/levels, calibration instances, design, response, selection rule, and final settings. Separate calibration from final testing when feasible. Omit if values were fixed a priori or inherited, and report their source in 5.1 instead. | `Parameter calibration design and selected settings`; add an effects plot only when it changes the decision. |
| 5.3 | `Component Analysis` | Controlled comparisons of initialization, neighborhoods, guidance/adaptation, acceptance/search control, or other claimed components. Change one interpretable factor at a time or use a disclosed factorial design; keep the remaining protocol fixed. | `Comparison of algorithmic components` or a compact ablation/factorial plot. |
| 5.4 | `Comparison with Benchmark Algorithms` | Full-method performance under fair budgets, including quality, variability, runtime, failures, ties, scale effects, and material reversals. Put small-scale exact/reference comparisons here and distinguish optimum, best known, bound, and experiment-best. Use `Comparison with State-of-the-Art Methods` only when that status is verified. | Consolidated main comparison table; one complementary profile only if the table cannot expose the key pattern. |
| 5.5 | `Statistical Analysis` | Hypotheses, experimental unit, pairing, sample size, test choice, multiplicity control, effect size or confidence interval, and practical significance. Omit inferential claims when the design does not support them. | Statistical comparison table or uncertainty plot. |
| 5.6 | `Search Behavior and Computational Efficiency` | Initial quality, improvement trajectory, stagnation, runtime, scalability, and budget trade-offs under comparable effort. Include only evidence tied to a search-behavior or efficiency claim. | Time-normalized convergence/performance profile and/or runtime-scaling table. |
| 5.7 | `Sensitivity and Robustness Analysis` | Response to algorithm parameters, problem characteristics, uncertainty, budgets, or perturbations beyond the calibration question. Report neutral, adverse, and non-monotonic behavior. | Sensitivity curve, interval plot, or compact robustness table. |
| 5.8 | `Discussion` | Answer each research question, connect component evidence to overall results, explain trade-offs and exceptions, state scope limits, and avoid introducing new numerical evidence. | Usually prose; a summary table only if it resolves several claim-to-evidence mappings. |

Insert `Real-World Case Study` immediately before `Discussion` only when genuine case data, an operational comparator, and the offline/deployment boundary are available. In the full branch it becomes 5.8 and shifts `Discussion` to 5.9. Constructed instances are not a real case.

## Required writing order inside an empirical section

Use this order whenever results are discussed:

```text
question or claim
→ comparison design and artifact
→ dominant result with uncertainty
→ important tie, reversal, failure, or subgroup
→ mechanism or trade-off supported by the design
→ bounded conclusion
```

Do not narrate every table cell. Do not infer a component's causal effect from the full-algorithm comparison when no controlled component experiment exists.

## Minimum artifact plan

| Artifact | What readers must learn | Minimum contents |
|---|---|---|
| Benchmark table | What was tested and why each group exists. | Source, problem class, scale, number of instances, experimental role, and modifications. |
| Protocol table | Whether comparisons are reproducible and fair. | Hardware/software, threads, stopping rule, budget, seeds, repetitions, comparator configuration, metric definitions, and analysis unit. |
| Calibration table (conditional) | How final settings were selected without test leakage. | Factors, ranges/levels, calibration set, design, response, selection rule, and selected values. |
| Component table/figure (conditional) | Which claimed design choices add value and at what cost. | Named variants, controlled factors, quality, variability, runtime, and scope. |
| Main comparison table | Whether the complete method is competitive. | Per-group or per-instance quality, dispersion, time, gap/reference status, tie rule, and failed-run notation. |
| Statistical artifact (conditional) | Whether comparative evidence exceeds random/run variation. | Unit, pairing, statistic, sample size, adjusted values when needed, and effect/interval. |
| Search/sensitivity figure (conditional) | How performance changes with effort or a controlled factor. | Fair x-axis, aggregation and uncertainty, selection rule, and all material counter-patterns. |

One artifact may serve two adjacent purposes when it remains readable. Do not create several plots from the same results merely to fill sections.

## Adaptive-SA test mapping

For the supplied Adaptive SA example, plan the chapter as follows without inventing values or results:

- 5.1 defines benchmark groups, credible comparators, equal time/evaluation budgets, independent random seeds, repetitions, makespan-based metrics, and the instance as the main comparative unit.
- 5.2 calibrates only empirically selected settings such as initial temperature, cooling rate, reaction factor, update-window length, reward values, and iteration/time budget; inherited or fixed values are simply disclosed.
- 5.3 tests named mechanisms through controlled variants: initialization alternatives when claimed, individual versus combined neighborhoods, fixed equal operator weights versus adaptive selection, reward/update variants, and the complete Adaptive SA versus the same SA without adaptation.
- 5.4 compares the complete method with NEH, standard SA, and verified scheduling baselines under matched budgets; exact or best-known references are labelled by status.
- 5.5 uses paired instance-level analysis when supported; repeated runs on one instance are not treated as independent problem instances.
- 5.6 examines time-normalized search behavior and runtime/scalability only on a disclosed representative set or across all instance groups.
- 5.7 separates sensitivity to temperature, reaction, window, or budget from the parameter-selection exercise in 5.2.
- 5.8 states where adaptation helps, where it does not, its computational cost, and the tested scope.

## Planning and drafting boundary

For an architecture request, provide the section map and mark unavailable datasets, protocols, baselines, result files, or statistical designs as `planned` or `missing`; do not stop to ask for every value. For manuscript-ready result writing, absent source results or provenance are blockers: draft only supported setup text and keep planned experiments outside completed-study prose.

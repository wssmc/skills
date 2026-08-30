# Computational study

Design the section from validation questions, not from a fixed list of plots:

```text
claim or research question
-> dataset/instance role
-> comparator and fair budget
-> metric and unit of analysis
-> statistical or analytical method
-> result, uncertainty, exception, and boundary
```

## Chapter opening

**Guide:** validation purpose -> data roles -> implementation and computing environment -> chapter evidence map

State what the experiments validate and identify benchmark, generated/modified, and real-case data. Report enough implementation and computing information to interpret and reproduce the budgets: language/runtime, hardware, OS/container when relevant, solver/version/interface, threads, time limit, stopping tolerances, seeds, repetitions, and whether preprocessing/training is included. Do not fill in unavailable details from typical hardware descriptions.

Template:

`All algorithms were implemented in [programming language] and executed on a personal computer equipped with [CPU model and clock speed], [RAM capacity], and [operating system]. [Solver name and version] was used where applicable, with [thread setting], [time limit], and [optimality-gap setting].`

## 5.1 Experimental design

### Data and settings

**Guide:** data source -> instance structure -> scenarios/factors -> baselines -> budgets -> metrics

Explain why each dataset is used, instance scales, generation/modification rules, train/calibration/test separation when applicable, baseline rationale, budget fairness, fixed seeds/repetitions, and metric formulas/units/denominators. Identify the unit of analysis (run, instance, scenario, or dataset) and prevent the same data from serving incompatible calibration and final-test roles without disclosure.

### Parameter calibration / DOE (conditional)

Omit when parameters were fixed a priori or inherited. Report fixed settings and their source in the data/settings subsection. If calibration is performed, separate calibration instances from final evaluation when feasible and disclose the selection criterion.

**Guide:** factors -> levels -> calibration instances -> DOE -> response -> main effects -> selected settings

Possible evidence when DOE is used:

- `Table X. Levels of the calibrated [algorithm name] parameters.`
- `Table X. Orthogonal parameter combinations and average response values of [algorithm name].`
- `Figure X. Main effects plot for the mean normalized objective.`
- `Table X. Factor-response analysis for the mean normalized objective.`

Use the actual design name; do not call a design orthogonal unless it is. Explain the response, aggregation, interactions considered, and why final settings may differ from the single best observed combination. Avoid overclaiming general robustness from a small calibration set.

## 5.2 Overall performance and statistical comparison

### Large-scale algorithm comparison

Use one consolidated table or separate setting-specific tables.

Caption patterns:

- `Table X. Algorithm comparison on large-scale instances under [setting].`
- `Table X. Algorithm comparison across different experimental settings.`

Report central tendency, variability/uncertainty, runtime, and relevant domain metrics appropriate to the design. Use best-hit counts only with a defined tie rule and reference value. Explain performance by scale and scenario, including material ties, reversals, failures, and trade-offs rather than only stating winners.

### Statistical significance

When stochastic algorithms or multiple instances support comparative claims, choose tests from the experimental unit, pairing, distribution, number of methods, and multiplicity structure. Preserve run-level data when available and avoid treating repeated runs on one instance as independent problem instances.

Caption patterns:

- `Table X. Statistical comparison of the proposed and benchmark algorithms.`
- `Table X. Friedman rankings and Holm-adjusted pairwise comparisons of the compared algorithms.`
- `Table X. Pairwise Wilcoxon signed-rank test results for the compared algorithms.`

Report hypotheses, unit of analysis, pairing, statistic, sample size, raw/adjusted p-values where applicable, and effect size or confidence interval. Separate statistical from practical significance. Do not select a test after inspecting which one yields significance, and do not call a difference significant without the reported analysis.

### Convergence

Caption patterns:

- `Figure X. Representative convergence behavior under [selected scenario combinations].`
- `Figure X. Time-normalized convergence profiles of the compared algorithms.`

Use a fair x-axis: equal wall-clock time or clearly justified effort units. State how representative instances were selected; do not cherry-pick only favorable curves. Discuss initial quality, early improvement, late search, stagnation, variability across runs, and consistency or reversals across scales/settings.

### Small-scale exact/reference comparison

This block may appear before large-scale results, after them, or be merged with the main comparison depending on the paper's logic and journal space.

Caption:

`Table X. Small-scale comparison between [exact model or reference method] and [proposed algorithm].`

Report incumbent, bound, gap definition, proven-optimum status, runtime, and domain metrics. Distinguish exact optimum, best-known solution, and experiment-best result. For minimization and maximization, ensure the bound direction and relative-gap denominator are stated or unambiguous.

## 5.3 Method-component analysis

Use actual component names. Each claimed algorithmic contribution should have a corresponding controlled comparison when feasible; if isolation is impossible, narrow the causal wording and explain the confounding.

Design:

```text
full method
-> remove/replace/change one component
-> hold other settings constant
-> compare quality, variability, hits, and runtime
-> explain conditions, mechanism, and boundary
```

Caption patterns:

- `Table X. Comparison of [method, rule, or component] alternatives.`
- `Table X. Comparison of [component name] strategies.`
- `Figure X. [Performance metric] improvement of different [component] strategies over [ablation baseline].`
- `Figure X. Performance contribution of [component name] across instance groups.`

## 5.4 Real case or application validation (conditional)

**Guide:** case setting -> data provenance -> parameterization -> policy baselines -> results/trade-offs -> practical meaning -> limitations

Do not describe constructed instances as real cases. State data provenance, anonymization/aggregation, operational baseline, and any deployment-versus-offline-evaluation boundary.

## 5.5 Sensitivity and robustness (conditional)

**Guide:** factor -> range -> controlled experiment -> outcome trend -> explanation -> model/managerial implication -> boundary

Analyze model parameters, weights, constraint tightness, uncertainty, problem scale, time budget, or data perturbation. Do not duplicate algorithm-parameter calibration unless it answers a distinct robustness question. Report non-monotonic, neutral, and adverse responses that change interpretation.

## Completeness check

For every conclusion drawn from the experiments, identify the exact table/figure/result artifact and the population of instances/runs it covers. Check all reported numbers against the source result file, including direction of better performance, denominators, rounding, tie rules, and missing/failed runs. Never silently drop failed runs or unfavorable instance groups.

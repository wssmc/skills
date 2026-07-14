# Computational study

## Chapter opening

**Guide:** validation purpose -> data roles -> implementation and computing environment -> chapter evidence map

State what the experiments validate and identify benchmark, generated/modified, and real-case data. Report language, CPU/clock, RAM, OS, solver/version, interface, threads, time limit, optimality gap, seeds, repetitions, and preprocessing inclusion when applicable.

Template:

`All algorithms were implemented in [programming language] and executed on a personal computer equipped with [CPU model and clock speed], [RAM capacity], and [operating system]. [Solver name and version] was used where applicable, with [thread setting], [time limit], and [optimality-gap setting].`

## 5.1 Experimental design

### Data and settings

**Guide:** data source -> instance structure -> scenarios/factors -> baselines -> budgets -> metrics

Explain why each dataset is used, instance scales, generation/modification rules, baselines and fairness, fixed seeds/repetitions, and metric formulas/units/denominators.

### Parameter calibration / DOE

Branch: omit when there are no calibrated parameters and report fixed settings and sources in the data/settings subsection.

**Guide:** factors -> levels -> calibration instances -> DOE -> response -> main effects -> selected settings

Default evidence package when DOE is used:

- `Table X. Levels of the calibrated [algorithm name] parameters.`
- `Table X. Orthogonal parameter combinations and average response values of [algorithm name].`
- `Figure X. Main effects plot for the mean normalized objective.`
- `Table X. Factor-response analysis for the mean normalized objective.`

Rename `Orthogonal` for factorial, response-surface, or another design. Explain why the selected final settings may differ from the single best observed combination.

## 5.2 Overall performance and statistical comparison

### Large-scale algorithm comparison

Use one consolidated table or separate setting-specific tables.

Caption patterns:

- `Table X. Algorithm comparison on large-scale instances under [setting].`
- `Table X. Algorithm comparison across different experimental settings.`

Report mean/median, variability, best-hit counts, runtime, and relevant domain metrics. Explain performance by scale and scenario rather than only stating winners.

### Statistical significance

When stochastic algorithms or multiple instances support comparative claims, use appropriate paired/nonparametric tests and effect information.

Caption patterns:

- `Table X. Statistical comparison of the proposed and benchmark algorithms.`
- `Table X. Friedman rankings and Holm-adjusted pairwise comparisons of the compared algorithms.`
- `Table X. Pairwise Wilcoxon signed-rank test results for the compared algorithms.`

Report test design, statistic, raw/adjusted p-values, mean ranks, effect size or confidence interval, and bounded interpretation. Do not call a difference significant without the reported test.

### Convergence

Caption patterns:

- `Figure X. Representative convergence behavior under [selected scenario combinations].`
- `Figure X. Time-normalized convergence profiles of the compared algorithms.`

Use a fair x-axis: equal wall-clock time or clearly justified iterations. Discuss initial quality, early improvement, late search, stagnation, and consistency across scales/settings.

### Small-scale exact/reference comparison

This block may appear before large-scale results, after them, or be merged with the main comparison depending on the paper's logic and journal space.

Caption:

`Table X. Small-scale comparison between [exact model or reference method] and [proposed algorithm].`

Report incumbent, bound, gap, proven optimum status, runtime, and domain metrics. Distinguish exact optimum, best-known solution, and experiment-best result.

## 5.3 Method-component analysis

Use actual component names. Each claimed algorithmic contribution should have a corresponding controlled comparison when feasible.

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

Do not describe constructed instances as real cases.

## 5.5 Sensitivity and robustness (conditional)

**Guide:** factor -> range -> controlled experiment -> outcome trend -> explanation -> model/managerial implication -> boundary

Analyze model parameters, weights, constraint tightness, uncertainty, problem scale, time budget, or data perturbation. Do not duplicate algorithm-parameter calibration unless it answers a distinct robustness question.

# Computational study

Design the chapter from validation questions and source results:

```text
claim or research question
-> dataset/instance role
-> comparator and fair budget
-> metric and unit of analysis
-> statistical or analytical method
-> result, uncertainty, exception, and boundary
```

For scheduling heuristics and metaheuristics, use the [fixed-title Chapter 5 template](../../templates/chapter5-computational-experiments-template.md) unless the target journal or existing manuscript fixes another structure. It is a house organization of experimental responsibilities, not a claim that published papers use identical numbers. Component and parameter evidence normally precedes the final full-method comparison because it explains why the evaluated configuration exists. Omit unsupported conditional modules and renumber only after the evidence plan is settled.

## Chapter opening

**Guide:** validation purpose -> research questions -> data roles -> implementation and computing environment -> evidence map

State what the experiments validate and identify benchmark, generated/modified, and real-case data. Report enough information to interpret and reproduce the budgets: language/runtime, hardware, relevant OS/container, solver/version/interface, threads, time limit or evaluation budget, stopping tolerances, seeds, repetitions, and whether preprocessing/training is included. Never fill unavailable details from a typical setup.

## 5.1 `Experimental Setup`

Write in this order:

1. research questions and the role of each instance group;
2. data provenance, problem structure, scale, generation/modification rules, and calibration/test separation;
3. implementation and computing environment;
4. comparator rationale and configuration source;
5. matched stopping/computing budgets, seeds, repetitions, and failed-run policy;
6. metric formulas, units, direction, denominators, reference status, and unit of analysis.

Use a benchmark table and a protocol table rather than scattering settings across later sections. Prevent the same data from silently serving incompatible calibration and final-test roles. If algorithms use different languages, machines, or published results, do not describe their runtimes as directly comparable without a justified normalization or a clear limitation.

## 5.2 `Parameter Calibration` (conditional)

Omit this section when settings were fixed a priori or inherited; state their values and sources in 5.1. When calibration is performed, report factors, ranges/levels, calibration instances, experimental design, response, aggregation, interaction treatment, selection rule, and selected settings. Keep calibration instances separate from final evaluation when feasible and disclose any overlap.

Possible artifacts:

- `Parameter calibration design and selected settings for [algorithm name].`
- `Main effects of [parameters] on [calibration response].`

Use the actual design name; do not call a design orthogonal unless it is. Explain why a selected setting may differ from the single best observed combination. A small calibration set does not establish general robustness.

## 5.3 `Component Analysis` (conditional on component claims)

Use actual component names. Compare the full method with variants that remove, replace, or change one interpretable component while holding the remaining protocol constant, or disclose a factorial design when interactions matter. Assess quality, uncertainty, runtime, and conditions of benefit. If a component cannot be isolated, narrow the causal wording and explain the confounding.

```text
claimed component
-> controlled variant
-> same data and budget
-> quality, variability, and cost
-> mechanism supported by the design
-> scope and exception
```

Typical artifact: `Comparison of [component name] strategies under [budget and instance scope].`

## 5.4 `Comparison with Benchmark Algorithms`

Use a consolidated table that exposes the full method's objective quality, dispersion, runtime, failures, ties, and behavior by instance scale or setting. Baselines need a technical rationale, credible implementation/configuration source, and fair budgets. Rename this section `Comparison with State-of-the-Art Methods` only when the selected methods' status is verified.

Do not merely announce a winner. Explain dominant results, material ties, reversals, subgroup effects, failures, and quality-time trade-offs. Best-hit counts require a defined reference and tie rule.

Place a small-scale exact/reference comparison here when applicable. Report incumbent, bound, relative-gap formula, proven-optimum status, runtime, and time-limit status. Distinguish exact optimum, best-known solution, published reference, and experiment-best result; verify bound direction for minimization or maximization.

## 5.5 `Statistical Analysis` (conditional)

Choose inference from the experimental unit, pairing, distribution, number of methods, and multiplicity structure—not from which test yields significance. Preserve run-level data, but do not treat repeated runs on one instance as independent problem instances in an across-instance claim.

Report hypotheses, analysis unit, pairing, statistic, sample size, raw/adjusted p-values when applicable, and an effect size or confidence interval. Separate statistical significance from practical importance. Friedman/Holm or paired Wilcoxon procedures are examples only when their assumptions and comparison structure match the design.

## 5.6 `Search Behavior and Computational Efficiency` (conditional)

Use equal wall-clock time or a clearly justified effort unit. State the instance/profile selection and aggregation rule; do not select only favorable curves. Discuss initial quality, early and late improvement, stagnation, between-run uncertainty, scalability, and quality-time trade-offs. A convergence figure is unnecessary when effort is not comparable or no search-behavior claim is made.

Typical artifacts:

- `Time-normalized convergence profiles of the compared algorithms on [scope].`
- `Runtime and scalability of [algorithm] by instance size.`

## 5.7 `Sensitivity and Robustness Analysis` (conditional)

Vary a model parameter, algorithm parameter, constraint tightness, uncertainty level, problem scale, time budget, or data perturbation under a controlled design. This section answers stability or boundary questions; it must not duplicate parameter selection in 5.2. Report non-monotonic, neutral, and adverse responses when they change interpretation.

## Optional `Real-World Case Study`

Insert this before the discussion only when genuine case data, provenance/anonymization, a relevant operational comparator, and the offline-versus-deployment boundary are available. In the full branch it becomes 5.8 and shifts `Discussion` to 5.9. Constructed benchmark instances are not real cases.

**Guide:** operational setting -> provenance -> parameterization -> policy baseline -> results and trade-offs -> practical meaning -> limitation

## 5.8 `Discussion`

Answer the research questions using the preceding evidence. Connect component findings to complete-method performance, reconcile statistical and practical importance, explain exceptions and computational costs, and state the tested scope. Introduce no new result or unsupported mechanism here.

## Result-discussion pattern

For each retained artifact:

```text
question answered
-> displayed data, comparator, and metric
-> dominant result with uncertainty
-> material exception, reversal, or failure
-> supported explanation or trade-off
-> bounded implication
```

Do not narrate every cell or infer causality from an uncontrolled comparison.

## Completeness and integrity check

For every conclusion, identify the exact result artifact and population of instances/runs it covers. Check source files for direction of better performance, denominators, rounding, tie rules, missing/failed runs, and metric/reference definitions. Ensure that parameter settings in the paper match those used to produce the result files. Never fabricate or silently drop unfavorable results.

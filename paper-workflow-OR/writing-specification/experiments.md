# Computational Experiments Writing Specification

The goal is to turn experimental design and results into a scientific evidence chain rather than a sequence of tables.

## 1. Define the common protocol once

Experimental Setup should establish the common environment, budget, repetitions, seeds, timing scope, and metrics. Later subsections inherit these conditions unless explicitly stated otherwise.

Make calibration/test separation clear so that test data are not implicitly used for parameter selection.

## 2. Close the parameter calibration evidence loop

Trace parameter decisions through:

```text
parameter choice
→ candidate levels or values
→ experimental design
→ screening result
→ independent confirmation
→ retained setting
→ consistent use in later experiments
```

Distinguish calibrated parameters, externally fixed parameters, and values derived from other quantities. Source code defaults are not automatically the final manuscript settings; report the values actually confirmed and used in the formal experiments.

The calibration implementation must preserve the algorithmic mechanisms being calibrated. If a temporary patch or generated build is used, identify it and establish whether it is part of the approved algorithm definition before treating its output as formal calibration evidence. A screening winner that fails independent confirmation may be rejected in favor of the prior setting, but the manuscript must report that decision accurately. Lack of confirmed improvement does not justify claiming that a parameter is unimportant.

## 3. Introduce baselines as scientific comparators

For each major baseline, explain:
- source paper;
- why it is relevant;
- official/author/reproduction/adapted implementation;
- parameter source;
- meaningful problem-specific adaptation.

Do not present only an acronym list.

## 4. Use a fixed result discussion logic

For major comparisons:

```text
comparison question
→ overall pattern
→ strongest comparator
→ subgroup/scale pattern
→ exception/reversal
→ interpretation
→ bounded conclusion
```

Do not read the table row by row.

## 5. Write MIP comparison around solver status

Distinguish:
- certified optimum;
- incumbent;
- best bound;
- gap;
- time-limit status.

Discuss:
1. which scales are solved to optimality;
2. heuristic deviation on certified optima;
3. how exact-solver effort changes with scale;
4. where the heuristic becomes practically advantageous.

## 6. Make Small and Large comparable but not repetitive

Use the same metrics and table structure so scale effects are visible.

Small usually emphasizes:
- closeness to exact/reference results;
- ties;
- whether methods are already saturated.

Large usually emphasizes:
- widening/narrowing gaps;
- scalability;
- structural baseline failure;
- search efficiency.

## 7. Integrate statistics with descriptive results

Statistics should modify interpretation, not merely append p-values.

Example:

```text
A has a numerically lower mean on Small, but the paired test does not support a reliable difference.
```

Always state the analysis unit and pairing.

## 8. Use convergence and runtime only when they answer a question

Convergence should clarify:
- initial quality;
- early improvement;
- crossing;
- stagnation;
- late improvement;
- final quality;
- fairness of the x-axis effort.

Runtime/evaluation evidence should clarify computational overhead or effective search effort, not exist because metaheuristic papers “usually have convergence curves.”

Treat runtime, evaluation counts, memory, and solver effort as empirical computational cost. Report the environment, budget, scale, and measurement scope; do not present these observations as algorithmic Big-O complexity or as evidence of problem complexity.

## 9. Design component analysis around contribution claims and causal questions

Start from the contributions claimed by the manuscript and define the evidence needed for each one. Use subsection titles that name the scientific mechanism or attribution question. Do not derive the section structure from code switches, experiment files, or the number of tables.

Use controlled variants:
- remove-one-component;
- replace-with-baseline;
- alternative implementation;
- mechanism-specific variant.

Hold data, budget, seeds, stopping, and decoder constant unless structural fairness requires retuning.

Several controls and tables may jointly answer one mechanism question. A nonoriginal architecture may serve as an attribution control, but it does not automatically become a separate contribution. When the design permits, distinguish three questions:

1. Does the proposed mechanism improve the relevant outcome?
2. How much of the overall advantage is attributable to inherited architecture?
3. Do the evaluated mechanisms provide complementary effects?

## 10. Report neutral and negative findings

Component analysis is not a proof that every proposed component helps.

Report:
- positive;
- neutral;
- negative;
- scale-dependent effects.

If a component lacks independent benefit, reduce its contribution wording instead of hiding the result.

### Internal Evaluation and Manuscript Reporting Boundary

Internal evaluation must retain and truthfully classify positive, neutral, negative, failed, and scale dependent results. The internal record is used to decide what is supported and what remains unresolved.

The manuscript should emphasize representative results for which the evidence is sufficiently complete. It need not enumerate every exploratory failure, but it must not omit, conceal, or reframe a formal experiment result that materially changes the main conclusion, comparison fairness, methodological validity, or scope of a claim. Exploratory findings may be summarized or omitted only when doing so does not create a misleading account of the study.

Failure diagnosis and decisions for the next algorithm iteration belong to the algorithm iteration workflow. Trigger that diagnosis only when the user explicitly asks for it. When triggered, preserve the relevant internal evidence and state a subsequent experiment that could support or refute the working hypothesis. A writing, revision, or ordinary experiment reporting task may document established evidence, but it must not silently start a new diagnostic cycle.

## 11. End each empirical subsection with an answer

The last sentence should answer the subsection's experimental question within the tested scope.

# Computational Experiments Writing Specification

The goal is to turn experimental design and results into a scientific evidence chain rather than a sequence of tables.

## 1. Define the common protocol once

Experimental Setup should establish the common environment, budget, repetitions, seeds, timing scope, and metrics. Later subsections inherit these conditions unless explicitly stated otherwise.

Make calibration/test separation clear so that test data are not implicitly used for parameter selection.

## 2. Introduce baselines as scientific comparators

For each major baseline, explain:
- source paper;
- why it is relevant;
- official/author/reproduction/adapted implementation;
- parameter source;
- meaningful problem-specific adaptation.

Do not present only an acronym list.

## 3. Use a fixed result-discussion logic

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

## 4. Write MIP comparison around solver status

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

## 5. Make Small and Large comparable but not repetitive

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

## 6. Integrate statistics with descriptive results

Statistics should modify interpretation, not merely append p-values.

Example:

```text
A has a numerically lower mean on Small, but the paired test does not support a reliable difference.
```

Always state the analysis unit and pairing.

## 7. Use convergence/runtime only when they answer a question

Convergence should clarify:
- initial quality;
- early improvement;
- crossing;
- stagnation;
- late improvement;
- final quality;
- fairness of the x-axis effort.

Runtime/evaluation evidence should clarify computational overhead or effective search effort, not exist because metaheuristic papers “usually have convergence curves.”

## 8. Design component analysis around causal questions

Use controlled variants:
- remove-one-component;
- replace-with-baseline;
- alternative implementation;
- mechanism-specific variant.

Hold data, budget, seeds, stopping, and decoder constant unless structural fairness requires retuning.

## 9. Report neutral and negative findings

Component analysis is not a proof that every proposed component helps.

Report:
- positive;
- neutral;
- negative;
- scale-dependent effects.

If a component lacks independent benefit, reduce its contribution wording instead of hiding the result.

## 10. End each empirical subsection with an answer

The last sentence should answer the subsection's experimental question within the tested scope.

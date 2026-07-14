# Intake and routing

## Task classification

Classify the request as Architecture, Drafting, Revision, Polishing/Translation, or Audit. Do not produce a full-paper template for a sentence-level polishing request.

## Grouped intake questions

Ask only questions that are materially unresolved, grouped in one message:

1. **Outlet and format:** target journal, article type, LaTeX template, word/page/figure/table limits.
2. **Problem:** base OR problem, decision maker if meaningful, decisions, objective, scarce resources, constraints, uncertainty.
3. **Model:** formulation family, complete equations, notation, data-to-parameter construction, theoretical claims.
4. **Method:** algorithm family, encoding/decoding, initialization, actual components, pseudocode, complexity/convergence/correctness.
5. **Evidence:** datasets, benchmarks, exact reference, baselines, calibration, repetitions, statistics, ablations, case, sensitivity, hardware/software.
6. **Delivery:** English/Chinese/bilingual and output mode.

## Manuscript-type routing

### Application/decision driven

Use when a real decision setting, decision owner, decision object, and scarce resources are central.

### Problem/method driven

Use when the contribution is a new variant, constraint, objective, or algorithm and the practical decision abstraction is secondary.

### Model/theory driven

Use when the principal contribution is formulation, decomposition, polyhedral/theoretical analysis, or an exact method.

## Related-work routing

Choose one:

- Problem/application -> model/decision formulation -> algorithm/solution method -> gap.
- Base problem -> concrete research themes -> synthesis/gap.
- Hybrid: problem/application -> specific themes -> model -> algorithm -> synthesis/gap.

## Evidence-state labels

Internally classify every item as:

- `provided evidence`;
- `verified external evidence`;
- `derivable`;
- `planned but not executed`;
- `missing`;
- `not allowed to infer`.

Use completed-study tense only for provided, verified, or directly derivable content.

# Code–Method Consistency

Use this file only when source code is available for internal audit or code-to-manuscript work. External peer reviewers do not assume source-code access.

## Representation

Check:
- what the manuscript says is searched;
- what the solver actually reads/modifies;
- whether unused data-structure fields are incorrectly described as encoding;
- whether decoder-completed decisions are incorrectly described as explicit variables.

## Decoder

Check:
- ready time;
- machine availability;
- machine-selection rule;
- tie-breaking;
- missing-operation handling;
- precedence/release handling;
- setup/transport;
- completion update;
- objective calculation.

## Operators

Check:
- selected object;
- candidate domain;
- feasible positions;
- retry/fallback;
- repair;
- type restrictions;
- sampling distribution.

## Search control

Verify the actual order:

```text
candidate generation
→ evaluation
→ acceptance/selection
→ current update
→ best update
→ feedback update
→ cooling/parameter update
```

A change in order may define a different algorithm.

## Randomness

Confirm every claim of:
- random;
- uniformly random;
- probabilistic;
- roulette-wheel selection.

Report deterministic tie-breaking when it changes reproducibility.

## Adaptive/learning/guidance mechanisms

Verify:
- observed state;
- trigger;
- reward/score;
- update timing;
- decision influence;
- reset/decay;
- fallback;
- interaction with base search.

Logging statistics without feedback is not an adaptive mechanism.

## Stopping rule

Distinguish:
- CPU time;
- wall time;
- iterations;
- objective evaluations;
- temperature;
- stagnation;
- mixed criteria.

## Parameter consistency

Distinguish:
- source-code defaults;
- calibration values;
- runtime overrides;
- final experimental values.

## Baseline reproduction and adaptation consistency

For reproduced/adapted baselines, audit:

```text
original paper
→ reproduction implementation
→ current problem adaptation
→ manuscript description
```

Check:
- objective;
- representation;
- decoder;
- operators/search control;
- budget/stopping;
- parameters;
- implementation source;
- active vs degraded mechanisms.

Use precise labels:
- official implementation;
- author-provided implementation;
- third-party reproduction;
- adapted implementation;
- adapted third-party reproduction.

If a core original mechanism is inactive or semantically weakened under the adapted mode, flag it explicitly.

## Final rule

The manuscript may omit engineering details, but it must not omit or alter implementation behavior that changes the scientific algorithm.

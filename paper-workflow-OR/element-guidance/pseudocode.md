# Pseudocode Guidance

> **Purpose:** Convert source code or explicit method logic into publication-level pseudocode through two stages.

This file does not decide how many pseudocodes a paper must contain. The user may specify them; otherwise suggest pseudocode only when execution logic would otherwise be difficult to reproduce.

# 1. Two-step conversion

```text
source code / explicit method logic
↓
Step 1 — Implementation-to-Algorithm Skeleton
↓
Step 2 — Skeleton-to-Publication Pseudocode
↓
code ↔ pseudocode ↔ method-text consistency check
```

# 2. Step 1 — Implementation-to-Algorithm Skeleton

## Recover Input/Output

Determine:
- inputs;
- outputs;
- whether state is modified in place;
- whether the function returns current/best/archive/expert/etc.

## Recover scientific state

Keep behavior-changing states:
- current;
- candidate;
- best/reference;
- population/archive;
- temperature;
- weights/rewards/Q-values;
- trigger counters.

Remove implementation-only state:
- logging;
- file paths;
- serialization;
- generic containers;
- debug counters.

## Preserve execution order

Do not change:
- candidate generation vs trigger timing;
- acceptance vs best update;
- reward update timing;
- fallback behavior;
- stopping conditions.

## Translate conditions literally

Source:

```text
if iteration_count % N_S == 0
```

Skeleton:

```text
if the exchange interval is reached
```

Source:

```text
if expert.evaluate() <= candidate.evaluate()
```

Skeleton:

```text
if the expert solution is no worse than the candidate
```

Do not add search-effect explanations during Step 1.

# 3. Step 2 — Skeleton-to-Publication Pseudocode

## Scientific naming

Replace programming identifiers with manuscript states/symbols.

## Abstract repeated implementation calls

Use defined functions:

```text
Decode(...)
LocalSearch(...)
GenerateCandidate(...)
GenerateExpert(...)
UpdateWeights(...)
```

when their internal meaning is already defined elsewhere.

## Compress without removing scientific logic

Remove generic copies, index correction, temporary containers, and source-language syntax.

Keep:
- acceptance;
- best/reference update;
- trigger;
- feedback;
- fallback;
- stopping;
- output selection.

## Publication conventions

Use clear Input/Output declarations.

Prefer assignment:

```text
x ← y
```

Use standard control forms:

```text
for
while
if ... then
else
end if
```

Use mathematical conditions where clearer:

```text
if f(π') ≤ f(π) then
```

Line numbers are useful for long algorithms when the manuscript refers to specific blocks.

## Overall vs component pseudocode

A paper may include:
- an overall algorithm;
- initialization;
- decoder;
- local search;
- transformation;
- adaptive/guidance mechanism;
- expert generation.

Simple swap/insertion moves usually need prose + illustration, not separate pseudocode.

# 4. Pseudocode-to-text integration

Prose explains **why and scientific meaning**. Pseudocode shows **exact execution order, conditions, and updates**.

Do not repeat pseudocode line-by-line in prose.

# 5. Final consistency check

Verify:
- Input/Output;
- state names;
- improvement direction;
- acceptance vs best update;
- trigger;
- feedback;
- stopping;
- component definitions;
- removal of implementation noise;
- consistency with method prose and source code.

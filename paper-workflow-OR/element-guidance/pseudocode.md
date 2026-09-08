# Pseudocode Guidance

> **Purpose:** Convert source code or explicit method logic into publication-level pseudocode through two stages.

This file does not decide how many pseudocodes a paper must contain. The user may specify them; otherwise suggest pseudocode only when execution logic would otherwise be difficult to reproduce.

# 1. Pseudocode Maturity Gate

Before producing publication-level pseudocode, determine method maturity.

### Case 1 — Source code exists

```text
source code
→ implementation-to-algorithm skeleton
→ publication pseudocode
→ code/pseudocode/prose consistency check
```

### Case 2 — Executable specification is frozen

```text
explicit executable logic
→ algorithm skeleton
→ publication pseudocode
→ prose consistency check
```

### Case 3 — Method is exploratory or still being designed

Do not produce publication-level pseudocode. Provide method architecture, component responsibilities, equations, operator definitions, and an illustrative control-flow description instead. Do not present exploratory design as a finalized algorithm.

# 2. Two-step conversion

```text
source code / explicit method logic
↓
Step 1 — Implementation-to-Algorithm Skeleton
↓
Step 2 — Skeleton-to-Publication Pseudocode
↓
code ↔ pseudocode ↔ method-text consistency check
```

# 3. Step 1 — Implementation-to-Algorithm Skeleton

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

# 4. Step 2 — Skeleton-to-Publication Pseudocode

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

Overall pseudocode should primarily invoke already-defined scientific components:

```text
s ← Initialize(...)
while ...
    d ← SelectDestroy(...)
    r ← SelectRepair(...)
    s' ← Destroy(s, d)
    s' ← Repair(s', r)
    s' ← Decode(s')
    s' ← LocalSearch(s')
    s, s* ← AcceptAndUpdate(s, s', s*)
    UpdateWeights(...)
end while
return s*
```

Do not embed mechanism explanations already defined in dedicated subsections.

Use separate component pseudocode only when precise executable logic is required for reproducibility, such as a decoder, adaptive controller, transformation, nontrivial repair, or critical-resource identification procedure.

Simple swap/insertion moves usually need prose + illustration, not separate pseudocode.

# 5. Pseudocode-to-text integration

Prose explains **why and scientific meaning**. Pseudocode shows **exact execution order, conditions, and updates**.

Do not repeat pseudocode line-by-line in prose.

# 6. Final consistency check

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

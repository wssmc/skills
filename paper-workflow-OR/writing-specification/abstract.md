# Abstract Writing Specification

The abstract must compress the complete paper into one continuous scientific argument rather than mechanically concatenating seven content slots.

## Extract from the manuscript

Draft the abstract from finalized or evidence-supported manuscript content:

- background and problem boundary from the Introduction / Problem Description;
- formulation role from Chapter 3;
- method delta from Chapter 4;
- validation scope from Chapter 5;
- quantitative/statistical findings from verified results;
- implication from the actual discussion/conclusion boundary.

Do not recreate the paper from memory.

## Select only information that changes the reader's understanding

Prioritize:
- the problem feature that defines the research boundary;
- the model feature that explicitly captures that structure;
- 2–3 method mechanisms that define the technical delta;
- the strongest aggregate comparison;
- statistical evidence or a material exception if it changes the conclusion.

Remove:
- secondary components;
- parameter values;
- hardware;
- complete baseline lists;
- multiple repetitive numbers;
- details that do not affect the contribution.

## Compress by semantic grouping

Group related content instead of shortening every sentence independently.

Example:

```text
structure-aware representation, adaptive neighborhood control, and guided intensification
```

is often better than three separate sentences when those mechanisms are subordinate to the same algorithmic contribution.

## Preserve causal continuity

A strong sequence is:

```text
context
→ problem feature
→ formulation
→ method
→ validation
→ evidence
→ bounded implication
```

Each sentence should answer the question naturally created by the previous one.

## Report results at the highest useful level

Prefer evidence that answers:
- whether the complete method outperforms the strongest comparator;
- over which benchmark scope;
- by how much;
- whether statistical support exists;
- whether any material scale-dependent reversal exists.

Do not write `the proposed method is effective` when quantitative evidence is available.

## Calibrate verbs

Use verbs that match the actual contribution:
- `formulate` for an explicit model;
- `develop` for a complete method;
- `design` for a mechanism;
- `adapt` for a modified published mechanism;
- `evaluate` / `compare` for experiments;
- `demonstrate` / `show` only when evidence directly supports the statement.

Do not use `novel`, `first`, `state-of-the-art`, `optimal`, or `significant` as substitutes for technical explanation.

## Final compression pass

1. remove repeated problem/algorithm names;
2. delete decorative modifiers;
3. merge similar method details;
4. merge similar experiment descriptions;
5. retain only the strongest 1–3 result signals;
6. verify that every sentence advances problem → method → evidence → conclusion.

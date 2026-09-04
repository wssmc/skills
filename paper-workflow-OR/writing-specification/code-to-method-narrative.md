# Code-to-Method Narrative Specification

> **Purpose:** Convert source code, pseudocode, configuration, and tests into publication-quality method narrative through two distinct stages.

The manuscript should describe scientific responsibilities, state transitions, and decision logic—not files, classes, or lines of code.

# 1. Two-stage translation principle

```text
source code / pseudocode / tests / configs
↓
Step 1 — Implementation-to-Scientific Translation
↓
Code-to-Manuscript Mapping Sheet
↓
Step 2 — Scientific-to-Manuscript Writing
↓
Chapter 4 prose / pseudocode / method figures
↓
Implementation–Manuscript Consistency Check
```

Step 1 asks: **What does the implementation actually do?**

Step 2 asks: **How should these verified scientific behaviors be organized into mature manuscript language?**

Do not jump directly from source syntax to publication prose.

# 2. Step 1 — Implementation-to-Scientific Translation

## 2.1 Recover the actual execution path

Identify:
- input;
- searched state;
- candidate;
- current/best/reference/archive/population;
- decoder/evaluator;
- candidate-generation operators;
- acceptance/replacement;
- adaptive/learning/guidance state;
- termination;
- returned object.

## 2.2 Translate literally before abstracting

Example source:

```text
choose an eligible block
choose two positions in that block
swap the positions
```

Literal behavior:

```text
A block is selected from the eligible block set and two positions inside that block are exchanged.
```

Scientific behavior:

```text
swap move restricted to an eligible solution subspace
```

Stop here. Do not add unsupported motivation such as `to improve diversification` during Step 1.

## 2.3 Recover state semantics and update order

For each state, identify:
1. who reads it;
2. who modifies it;
3. whether modification occurs before/after acceptance;
4. whether rejected candidates still affect statistics/learning;
5. tie behavior.

A useful state-transition table is:

| Step | State read | Decision | State written |
|---|---|---|---|
| Candidate generation | current | select operator | candidate |
| Evaluation | candidate | decode/evaluate | objective |
| Acceptance | current, candidate | accept/reject | current |
| Best update | current/candidate | improve? | best |
| Feedback | reward/history | update rule | weights/state |

## 2.4 Recover real operator semantics

Do not rely on function names. Confirm:
- selected object;
- sampling rule;
- admissible positions;
- type/domain restriction;
- feasibility filter;
- retry/fallback;
- repair;
- tie-breaking;
- post-processing;
- decoder effect.

Translate as:

```text
selection rule
→ transformation
→ feasibility treatment
→ resulting candidate
```

## 2.5 Separate algorithm definition from experiment configuration

Method definition includes behaviors such as:
- geometric cooling;
- reward-based probability update;
- feasible-position restriction;
- trigger rule.

Chapter 5 normally contains values such as:
- `alpha = 0.96`;
- reaction factor;
- number of seeds;
- CPU/time budget.

A fixed value belongs in Chapter 4 only when it changes algorithm semantics, feasibility, candidate set, or reproducibility.

## 2.6 Identify technical delta by behavior

Compare baseline vs proposed behavior across:
- representation;
- candidate set;
- feasibility handling;
- maintained state;
- selection/acceptance;
- feedback;
- trigger;
- search scale/budget allocation.

Code size is not a technical contribution.

# 3. Code-to-Manuscript Mapping Sheet

Step 1 must produce the fixed mapping sheet in `templates/code-to-manuscript-mapping-sheet.md`.

Fields:

| Field | Meaning |
|---|---|
| Code evidence | file/function/variable/location |
| Literal behavior | what the code executes |
| Condition / Scope | when/where the behavior is active |
| Scientific behavior | implementation-independent algorithm behavior |
| State / decision affected | what changes |
| Manuscript slot | scientific responsibility in Chapter 4 |
| Treatment | WRITE / COMPRESS / OMIT |
| Reason / Notes | rationale / merging notes |

Treatment rules:
- **WRITE**: part of method definition;
- **COMPRESS**: behavior matters but should be merged into a larger scientific action;
- **OMIT**: implementation-only detail that does not alter scientific behavior.

# 4. Step 2 — Scientific-to-Manuscript Writing

## 4.1 Group by scientific responsibility

Reorganize mapping-sheet entries into:
- representation;
- decoding;
- initialization;
- candidate generation;
- search control;
- adaptive/guidance mechanism;
- termination.

Multiple functions may become one manuscript mechanism.

## 4.2 Convert behavior into method logic

Step 1 may say:

```text
worse candidate → random draw → compare with exp(-Δ/T)
```

Step 2 may write:

```text
A non-worsening candidate is accepted directly, whereas a worsening candidate is accepted according to the Metropolis criterion.
```

Supported motivation/search effect may now be added.

## 4.3 Add supported motivation

Explain:
- what deficiency is addressed;
- what information is observed;
- how the decision rule uses it;
- what intervention occurs;
- how it changes later search.

Motivation must come from problem structure, algorithm design rationale, diagnostics/ablation, or literature—not from code-name inference.

## 4.4 Compress implementation fragments

Merge low-level steps into defined scientific actions when appropriate.

Do not retain list index adjustment, generic copies, logging, serialization, or defensive exceptions unless they alter algorithm behavior.

## 4.5 Write representation/decoder from decision mapping

Representation:
- what the searched solution contains;
- explicit decisions;
- decoder-completed decisions;
- search-space/feasibility implications.

Decoder:

```text
read encoded decision
→ compute readiness
→ assign resource
→ determine start/completion
→ enforce special constraints
→ update state
→ compute objective
```

## 4.6 Write operators in one scientific rhythm

Use:

```text
purpose
→ selection
→ transformation
→ feasibility
→ resulting candidate
→ supported search effect
```

## 4.7 Write search control as state transitions

Different metaheuristics still reduce to:

```text
state
→ candidate/offspring
→ evaluation
→ selection/acceptance
→ state replacement
→ best/reference update
→ feedback
→ termination
```

# 5. Pseudocode and method figures

Derive pseudocode from verified state transitions, not source syntax. Use `element-guidance/pseudocode.md`.

A flowchart may simplify visually, but must preserve real control order.

# 6. Final consistency check

Verify:
- representation;
- decoder;
- operators;
- search-control order;
- randomness/tie-breaking;
- parameters;
- pseudocode;
- method figures;
- complexity claims.

Final standard:

> The manuscript does not need to describe every line of code, but it must describe every implementation behavior that changes the scientific algorithm.

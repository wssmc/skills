# Section Check

Use this check for one chapter or subsection only.

Workflow:

```text
identify section
→ load structural responsibility
→ load relevant Writing Specification
→ load relevant Truthfulness rules
→ check missing/redundant/misplaced content
→ return section-level issues
```

## Abstract

Check:
- background;
- problem;
- model;
- method;
- experiment scope;
- main result;
- bounded conclusion;
- no citations/formulas/hardware/detail overload;
- result claims supported.

## Introduction

Check the forward chain:

```text
base problem
→ key feature
→ literature gap
→ studied problem/difficulty
→ method/contributions
→ organization
```

Check:
- background not overly broad;
- practical feature translated into OR structure;
- gap derived from literature;
- problem defined before method;
- contributions not an activity list;
- organization paragraph concise.

## Related Work

Check:
- research streams;
- comparison dimensions;
- absence of author-by-author stacking;
- closest studies;
- subsection synthesis;
- final gap derived from prior discussion;
- literature-matrix cells verified when relevant.

## Problem Description and Model

Check:
- environment/entities/routes/resources;
- key features;
- decisions/objective;
- assumptions;
- illustrative example when needed;
- notation;
- objective;
- constraints/domains;
- operational interpretation;
- problem/model consistency.

## Solution Method

Check:
- overall framework and component responsibilities;
- representation and decoder;
- initialization states;
- neighborhoods in consistent rhythm;
- method-specific mechanism causality;
- algorithm integration;
- stopping/output;
- pseudocode where scientifically useful;
- no function-by-function section topology.

If source code is available for internal audit, additionally load `truthfulness/code-method-consistency.md`.

## Computational Experiments

Check:
- 5.1 environment/protocol/metrics/instance generation/calibration;
- 5.2 baseline relevance/source/fairness/MIP/Small/Large/statistics;
- 5.3 controlled component analysis;
- positive/neutral/negative evidence;
- scale dependence;
- no unnecessary extra second-level headings.

## Conclusion

Check three responsibilities:
1. research summary;
2. main findings;
3. concrete limitations + corresponding future work.

Do not allow new contributions or experiments.

## Output

```text
Section:
Status: PASS / REVISION NEEDED

Missing responsibilities:
- ...

Redundant / misplaced content:
- ...

Truthfulness risks:
- ...

Writing-quality risks:
- ...

Minimal revision plan:
1.
2.
3.
```

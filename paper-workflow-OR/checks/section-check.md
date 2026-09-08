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
- industrial facts classified into primary and secondary scientific features;
- the opening centers the primary scientific structure rather than an easy-to-name secondary feature;
- gap derived from literature;
- problem defined before method;
- the problem/model paragraph states decisions, distinctive constraints, and objective;
- contributions are compact scientific deltas rather than activities;
- internal novelty-audit language is absent from manuscript prose;
- citation clusters are not excessive;
- organization paragraph concise.

## Related Work

Check:
- research streams;
- comparison dimensions;
- absence of author-by-author stacking;
- no citation dumping or repeated large citation clusters;
- closest studies;
- closest studies compared on explicit dimensions;
- synthesis without mechanically repeated concluding paragraphs;
- final gap derived from prior discussion without repeating the full inventory;
- literature-matrix cells verified when relevant.

## Problem Description and Model

Check:
- environment/entities/routes/resources;
- key features;
- decisions/objective;
- assumptions;
- illustrative example when needed;
- industrial restrictions not silently generalized;
- assumptions/example not over-sectioned;
- consolidated notation;
- complete formulation before grouped explanation;
- objective;
- constraints/domains;
- operational interpretation;
- machine/worker/precedence semantics match the application;
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
- publication pseudocode only after the Pseudocode Maturity Gate;
- exploratory design not presented as finalized executable logic;
- overall pseudocode uses defined scientific component calls;
- component pseudocode only when reproducibility requires it;
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

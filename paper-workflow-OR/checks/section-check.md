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
- notation case follows a consistent role convention for sets, indices, parameters, continuous/integer variables, and binaries;
- consolidated notation;
- complete formulation followed by one compact explanation paragraph by default;
- objective;
- constraints/domains;
- operational interpretation;
- machine/worker/precedence semantics match the application;
- problem/model consistency.

## Solution Method

Check:
- algorithmic states, complete transitions, mechanism attribution, and dependencies recovered before subsection titles are fixed;
- subsection titles derived from scientific responsibilities rather than copied from another algorithm;
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
- any algorithmic-complexity claim is derived from source code or a frozen executable specification;
- problem complexity, algorithmic complexity, and empirical computational cost are not conflated;
- no function-by-function section topology.
- each major fact has one primary presentation carrier, without full duplication across prose, flowchart, pseudocode, equations, and operation diagrams;
- `current`, `candidate`, `best`, `elite`, `reference`, and `archive` are used only for defined states and remain consistent across all carriers.

If source code is available for internal audit, additionally load `truthfulness/code-method-consistency.md`.

## Computational Experiments

Check:
- 5.1 environment/protocol/metrics/instance generation/calibration;
- parameter decisions trace candidate values, design, screening, independent confirmation, retained settings, and consistent downstream use;
- source defaults, calibrated values, fixed values, derived values, runtime overrides, and final settings are distinguished;
- 5.2 baseline relevance/source/fairness/MIP/Small/Large/statistics;
- 5.3 controlled component analysis;
- component analysis is organized by contribution claims and causal mechanism questions rather than switches, files, or table count;
- inherited architecture, mechanism effectiveness, and complementarity are distinguished when the design permits;
- positive/neutral/negative evidence;
- scale dependence;
- runtime/evaluation evidence is labeled as empirical computational cost rather than Big-O or problem hardness;
- no unnecessary extra second-level headings.

## Figures and diagrams

Check:
- Python-generated figures follow a restrained publication style rather than a decorative AI-like style;
- the background, palette, typography, line widths, and layout are consistent;
- every node, arrow, color, marker, and annotation has a defined scientific or operational role;
- no decorative 3D effects, neon gradients, glow, gloss, random icons, ornamental backgrounds, or unrelated illustrations are present;
- labels, units, legends, experimental units, and metric directions are legible at the intended manuscript size;
- arrows do not cross semantic objects, and relation direction and endpoints remain explicit at final scale;
- multipanel consistency and the source, assembled, and rendered-page versions have been inspected when applicable;
- unnecessary hyphenated or dash-based prose is not used in captions or figure discussion.

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

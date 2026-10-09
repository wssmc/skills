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
- technical abbreviations are defined as full term plus abbreviation at first occurrence within the Abstract;
- later occurrences within the Abstract use the abbreviation consistently.

For ambiguous or operationally defined terms, also apply `truthfulness/term-definition-consistency.md`. Confirm that the first use identifies the intended meaning and does not silently import another scope's definition.

## Highlights

When Highlights are provided, check:
- the Highlights block is treated as an independent abbreviation scope;
- every technical abbreviation is introduced as full term plus abbreviation at first occurrence within Highlights;
- later occurrences within Highlights use the abbreviation consistently;
- definitions from the Abstract and main text are not incorrectly treated as available in Highlights.

Apply the same terminology check independently within Highlights when a key term is overloaded or has an operational definition.

## Introduction

Before drafting or auditing the six paragraph Introduction, check the internal chain:

```text
Research Goal
→ Scientific Challenge
→ Research Hypothesis
→ Technical Contribution
→ Supporting Evidence
```

The chain is an internal consistency check. Do not add a visible subsection, change the six paragraph structure, or invent a hypothesis that is not supported by the supplied research question, expectation, or evidence.

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
- each retained contribution has a technical landing and an evidence landing;
- favorable results have not been used retrospectively to invent the research hypothesis or contribution rationale.

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
- Process: execution order, state transitions, control flow, and returned solution are complete;
- Design: decisions and mechanisms are connected to the computational difficulty they address;
- Discussion: intended effects are separated from effects supported by evidence;
- Implementation: prose, pseudocode, flowchart, and source or frozen executable logic agree on conditions, update targets, and evaluation order;
- the four dimensions are used as quality checks, not imposed as visible subsection titles;
- Method Writing is distinguished from Algorithm Iteration;
- exploratory iteration hypotheses are not presented as validated contributions;
- when iteration is explicitly requested, relevant internal evidence is complete and the proposed validation could support or refute the working hypothesis;
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

When key operational terms are overloaded or have counters/state transitions, also load `truthfulness/term-definition-consistency.md`. Verify the referent, unit or event, criterion, and reset or update rule across prose, pseudocode, figures, and code. In particular, do not conflate global best stagnation, member level lack of progress, operator failure, rounds, generations, or evaluation counts unless the project explicitly defines an equivalence and the implementation supports it.

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
- internal evaluation retains positive, neutral, negative, failed, and scale dependent results;
- manuscript reporting may omit exploratory failures only when they do not materially change the main conclusion, comparison validity, or claim scope;
- formal results that materially change the main conclusion are not omitted or reframed;
- failure diagnosis and next iteration decisions are not triggered by ordinary writing or reporting without an explicit user request;
- when iteration is explicitly requested, the diagnostic record includes relevant internal evidence and a support or refutation test;
- scale dependence;
- runtime/evaluation evidence is labeled as empirical computational cost rather than Big-O or problem hardness;
- no unnecessary extra second-level headings.

## Figures and diagrams

Check:
- figure titles, captions, panel headings, and explanatory paragraphs are outside the artwork and placed in the manuscript;
- the main text cites each figure and each distinct panel and explains its role;
- distinct diagrams are separate assets by default; grouped panels have a clear comparison purpose and remain independently editable;
- only concise semantic labels needed to interpret the graphic remain inside it;
- Python-generated figures follow a restrained publication style rather than a decorative AI-like style;
- the background, palette, typography, line widths, and layout are consistent;
- every node, arrow, color, marker, and annotation has a defined scientific or operational role;
- no decorative 3D effects, neon gradients, glow, gloss, random icons, ornamental backgrounds, or unrelated illustrations are present;
- labels, units, legends, experimental units, and metric directions are legible at the intended manuscript size;
- text, formulas, symbols, blocks, connectors, arrowheads, legends, and panel boundaries do not overlap or obscure one another;
- relation direction and endpoints remain explicit at final scale;
- multipanel consistency and the source, assembled, and rendered-page versions have been inspected when applicable;
- flowcharts have explicit start/end terminators, use process boxes and decision diamonds consistently, label binary branches `Y`/`N`, and place actions in destination nodes rather than branch text;
- flowchart findings distinguish visible artwork violations from semantic questions requiring source verification and optional presentation improvements; an algorithm mismatch is not reported as confirmed without checking the relevant approved method, pseudocode, and implementation when available;
- neighborhood diagrams show before/after states, selected elements, and transformation direction without obscuring jobs, positions, or labels;
- nonessential hyphens and sentence fragments built around dashes are minimized throughout the section's narrative prose, captions, and figure discussion; necessary technical terms, notation, ranges, citations, and formal labels remain intact.

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

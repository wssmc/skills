# Introduction and related work

## 1. Introduction branches

### Branch A: application or decision driven

**Guide:** application background -> decision abstraction -> current practice/research -> technical difficulty -> gap -> model and method -> contributions -> organization

Cover these functions in a coherent order: establish the operational need; translate it into an OR abstraction (who decides, what is decided, scarce resources, constraints/uncertainty, and performance criterion); explain the unresolved modelling or solution difficulty; define the studied problem and approach; state evidence-bounded contributions; and provide an organization map when the outlet expects one.

Combine or split paragraphs to suit article length and argument density. Do not force one paragraph per function.

### Branch B: problem or method driven

**Guide:** base problem -> development of variants/methods -> new feature or method limitation -> technical difficulty -> gap -> proposed method -> contributions -> organization

Use when the decision abstraction is not a strong narrative anchor. Explicitly state the base problem, what is extended, why existing formulations/algorithms do not transfer, and what capability is added.

### Branch C: model or theory driven

**Guide:** research field and baseline model -> existing modelling paradigm -> representational/theoretical limitation -> new computational difficulty -> proposed formulation/theory/algorithm -> contributions -> organization

Use for formulation, decomposition, exact-method, or theory-centred papers.

Whichever branch is selected, keep context proportional: the introduction should reach the precise research question before broad motivation overwhelms the technical contribution. Contributions should identify what was formulated/designed/proved/evaluated, not merely list manuscript activities.

## 2. Related-work branches

### Branch A: problem-model-algorithm

Suggested publication-ready functions:

1. Problem and application studies.
2. Modelling and decision-formulation studies.
3. Exact, heuristic, decomposition, or learning-assisted solution methods.
4. Synthesis, research gap, and positioning.

Each stream should define the topic, classify representative work, compare assumptions/capabilities/evidence, and end with a specific implication for the studied research question. A stream need not manufacture a gap if its role is to establish a baseline or method choice.

### Branch B: base problem and concrete themes

Organize around the base problem and concrete themes with independent literature bases. Combine closely coupled themes when separation would repeat the same studies or assumptions. Titles must name the actual themes.

### Branch C: hybrid

Combine problem/application, one or more concrete feature streams, model literature, and algorithm literature when both thematic and methodological positioning are needed.

## Literature matrix

Use a matrix when structured comparison exposes the claimed gap, baseline choice, or positioning more clearly than prose and the outlet has room for it. Omit it when the coding would be sparse, redundant, or unsupported by verified sources.

Preferred caption:

`Table X. Comparison of representative related studies and this study.`

Candidate columns:

- Study
- Problem or application setting
- Objective
- Key problem characteristics
- Model or formulation
- Solution method
- Validation or data

Use only columns that answer the positioning question. Verify every cell against the source paper, retain a citation or evidence locator for audit, and keep the matrix, prose, and contribution claims consistent.

## Prohibited patterns

- chronological author-year inventory;
- unverified `first` or `no study` claims;
- generic subsection titles such as `Problem line` in final prose;
- mentioning the proposed algorithm repeatedly in the middle of literature summaries instead of reserving it for synthesis/positioning;
- a gap that does not map to a later contribution and evidence block.
- treating absence from a limited search as proof that no prior study exists.

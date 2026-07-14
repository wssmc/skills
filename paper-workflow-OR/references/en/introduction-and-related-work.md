# Introduction and related work

## 1. Introduction branches

### Branch A: application or decision driven

**Guide:** application background -> decision abstraction -> current practice/research -> technical difficulty -> gap -> model and method -> contributions -> organization

- **Paragraph 1:** establish the application need and operational importance. Translate the setting into an OR abstraction: who decides, what is decided, what resource is scarce, what constraints/uncertainty matter, and how solution quality is judged.
- **Paragraph 2:** explain current practice and related research, including what has been solved and where existing rules, formulations, or algorithms fall short.
- **Paragraph 3:** explain interacting problem features and the resulting modelling and computational difficulty; state the specific unresolved gap.
- **Paragraph 4:** define the studied problem and summarize the formulation and solution approach, including why they fit the setting.
- **Paragraph 5:** state contributions in gap order and with bounded claims.
- **Paragraph 6:** map the remaining sections.

### Branch B: problem or method driven

**Guide:** base problem -> development of variants/methods -> new feature or method limitation -> technical difficulty -> gap -> proposed method -> contributions -> organization

Use when the decision abstraction is not a strong narrative anchor. Explicitly state the base problem, what is extended, why existing formulations/algorithms do not transfer, and what capability is added.

### Branch C: model or theory driven

**Guide:** research field and baseline model -> existing modelling paradigm -> representational/theoretical limitation -> new computational difficulty -> proposed formulation/theory/algorithm -> contributions -> organization

Use for formulation, decomposition, exact-method, or theory-centred papers.

## 2. Related-work branches

### Branch A: problem-model-algorithm

Suggested publication-ready functions:

1. Problem and application studies.
2. Modelling and decision-formulation studies.
3. Exact, heuristic, decomposition, or learning-assisted solution methods.
4. Synthesis, research gap, and positioning.

Each stream should define the topic, classify representative work, compare assumptions and capabilities, and end with a specific unresolved issue.

### Branch B: base problem and concrete themes

Use one subsection for the base problem and one subsection for each theme with an independent literature base. Titles must name the actual themes.

### Branch C: hybrid

Combine problem/application, one or more concrete feature streams, model literature, and algorithm literature when both thematic and methodological positioning are needed.

## Literature matrix

Include by default for a full method-driven paper.

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

Use only columns that expose the claimed gap. The matrix and prose must agree.

## Prohibited patterns

- chronological author-year inventory;
- unverified `first` or `no study` claims;
- generic subsection titles such as `Problem line` in final prose;
- mentioning the proposed algorithm repeatedly in the middle of literature summaries instead of reserving it for synthesis/positioning;
- a gap that does not map to a later contribution and evidence block.

# Manuscript architecture

## OR spine

A method-driven OR paper should read as one argument:

```text
research context
-> OR decision or optimization problem
-> unresolved gap and technical difficulty
-> mathematical formulation
-> solution method
-> computational evidence
-> theoretical/practical implications and boundaries
```

## Default main body

1. Introduction
2. Literature review / Related work
3. Problem description and mathematical formulation
4. Solution method
5. Computational study
6. Conclusions

Paragraph 1: problem, model, and algorithm overview — restate the studied problem, the key structure of the formulation, and the proposed method at the level of its central idea.

Paragraph 2: main experimental findings — report the principal computational results, the magnitude of improvement, and the statistical evidence that supports the method's effectiveness. One to three sentences of numerical summary; do not enumerate every benchmark.

Paragraph 3: three problem boundaries and three corresponding future research directions — state what the method does not cover or where it degrades, then pair each boundary with a concrete next-step extension. Do not propose vague future work such as "apply to other problems" or "improve the algorithm."

Use the target journal's prescribed structure when it differs.

## Paragraph-planning notation

For planning output, use:

```text
Guide: element -> element -> element
Paragraph 1: purpose and content.
Paragraph 2: purpose and content.
```

Do not use numbered circled bullets for section-content planning.

## Subsection economy

- Most main sections should have 3-5 subsections.
- Merge explanatory fragments that do not carry independent argumentative functions.
- Use third-level headings only for actual method components, evidence blocks, or substantive research streams.
- Move long proofs, implementation details, full parameter tables, and supplemental experiments to appendices when permitted.

## Default fixed evidence package

For a typical model-algorithm-computational OR paper, plan:

- literature matrix;
- illustrative-instance data tables plus one explanatory Gantt/network/route figure;
- model notation table;
- overall algorithm framework figure;
- parameter calibration tables/plot when calibration is used;
- algorithm comparison table(s), statistical comparison, and convergence plot;
- component comparison tables/plots for claimed algorithmic contributions.

Case study and sensitivity/robustness sections are conditional but supported.

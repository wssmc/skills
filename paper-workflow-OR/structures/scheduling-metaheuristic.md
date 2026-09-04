# Scheduling Metaheuristic Manuscript Structure Specification

> **Status:** Frozen core structure for scheduling papers built around a mathematical formulation, heuristic/metaheuristic solution method, and computational experiments.

This file defines **where content belongs and what each location must contain**. It does not prescribe detailed writing techniques.

## Abstract

A single paragraph unless the journal requires a structured abstract. Include, in order:

1. research background;
2. studied problem and key non-classical characteristics;
3. mathematical modeling;
4. proposed solution method;
5. experimental design;
6. main results;
7. bounded conclusion/implication.

Do not include citations, equations, hardware details, or detailed parameter settings. Quantitative or statistical evidence is preferred when available.

## Keywords

Use 4–6 keywords in the following priority order:

1. base scheduling problem;
2. key problem feature I;
3. key problem feature II, if material;
4. application domain, if important;
5. method family;
6. distinctive algorithm mechanism, only when useful for retrieval.

Avoid generic terms such as `Optimization`, `Scheduling`, or `Metaheuristic` when more specific terms are available.

# 1. Introduction

Use six paragraph responsibilities.

### Paragraph 1 — Research background and base problem
Start from the production or scheduling background, introduce the base scheduling environment, and explain its research/application significance.

### Paragraph 2 — Key problem feature and practical significance
Introduce the core constraint, resource relation, objective, or operational feature that distinguishes the studied problem from the classical base problem, and explain why it arises and why it matters.

### Paragraph 3 — Existing studies and research gap
Use a small number of representative and closest studies to show what has already been addressed and what remains unresolved.

### Paragraph 4 — Studied problem and computational difficulty
Define the problem studied in the paper and summarize the main modeling/search difficulties introduced by the special feature(s).

### Paragraph 5 — Proposed approach and main contributions
Briefly introduce the formulation and solution approach, then state the principal contributions.

### Paragraph 6 — Paper organization
Briefly map the remaining sections.

# 2. Related Work

Two organization modes are supported.

## Mode A — Problem-decomposition mode (default)

```text
2.1 [Base Scheduling Problem]
2.2 [Problem Extension / Constraint I]
2.3 [Problem Extension / Constraint II]
2.x [Additional Problem Feature]       # only if needed
2.x Solution Methods
2.x Research Gap
```

Use this mode when the studied problem is built from several interacting scheduling features.

## Mode B — Method-driven mode (optional)

```text
2.1 [Target Scheduling Problem]
2.2 [Baseline Method Family]
2.3 [Relevant Improvement Mechanisms]
2.4 Research Gap
```

Use this mode only when the problem setting is mature and the main contribution is methodological.

# 3. Problem Description and Mathematical Formulation

## 3.1 Problem Description

Cover six content blocks:

1. production environment and scheduling entities;
2. processing route and machine/resource environment;
3. key problem characteristics;
4. scheduling decisions and objective;
5. basic assumptions;
6. illustrative example, when the problem is new, complex, or difficult to understand intuitively.

### Illustrative example

When used, normally include:

```text
small instance table
→ problem/relationship structure figure
→ Gantt chart
→ explanation of how the special constraints and resource competition appear in the schedule
```

The illustrative example is mandatory for a new/complex/unintuitive problem and optional for a mature, simple variant.

Preprocessing is not a fixed subsection. Include it only when scientifically necessary.

## 3.2 Notation and Mathematical Formulation

### 3.2.1 Notation

Organize:

- sets and indices;
- parameters;
- decision variables;
- auxiliary variables;
- notation table.

### 3.2.2 Mathematical Formulation

Present:

1. objective function;
2. basic decision constraints;
3. technological precedence;
4. machine/resource capacity;
5. problem-specific constraints;
6. objective-linking constraints;
7. variable domains;
8. explanation of each constraint group.

### 3.2.3 Problem Properties [Optional]

Use only when relevant and supported:

- NP-hardness / complexity;
- lower/upper bounds;
- dominance or structural properties;
- explicit implication for method design or experimental evaluation.

# 4. Proposed Solution Method

## 4.1 Overall Framework

Cover:

1. baseline solution idea and why it is appropriate;
2. standard, adapted, and proposed components and their responsibilities;
3. an overall flowchart when useful;
4. the real information/control flow among components.

## 4.2 Solution Representation and Decoding

Cover:

1. representation and explicitly encoded decisions;
2. decoder and decisions completed during schedule construction;
3. machine/resource assignment, timing, constraints, and objective evaluation;
4. a small encoding–decoding example when useful;
5. feasibility and search-space implications.

## 4.3 Initialization

Cover:

1. initialization method and rationale;
2. how initial current/best/reference/population states are obtained;
3. how later-stage states are initialized if they are inherited or transformed from earlier search stages;
4. initialization of other search state.

Numerical parameter values belong in Chapter 5 unless they define the algorithm semantics.

## 4.4 Neighborhood Structures

Do not mechanically create `4.4.1`, `4.4.2`, etc. for simple moves.

Cover:

1. overview of neighborhood purposes;
2. each neighborhood in a consistent rhythm: selection → transformation → feasibility → resulting candidate;
3. a multi-panel before/after figure when helpful;
4. search scale/dimension and complementarity;
5. the operator-selection/control rule.

## 4.5+ Method-Specific Mechanism(s)

Create a separate subsection only for a genuinely independent scientific mechanism.

For each mechanism, explain:

1. baseline deficiency / motivation;
2. state or information used;
3. trigger or decision rule;
4. equations and operations;
5. state update / feedback;
6. interaction with other search components;
7. intended search effect.

If several actions form one causal mechanism chain, keep them together. For example:

```text
representation transformation
→ expert-solution generation
→ cross-space cooperation
```

may be one mechanism section rather than three artificial subsections.

If a mechanism has its own theorem, proposition, or structural analysis, it may receive a dedicated subsection and additional space.

## 4.x [Overall Search / Algorithm Integration]

This is a **responsibility slot**, not a mandatory visible title. Use an algorithm-specific title such as `Overall Search Strategy`, `Two-Stage Search Strategy`, or `Search Process`.

Cover:

1. complete search control;
2. how all previous components interact in the real execution order;
3. current/candidate/best/reference state transitions;
4. stopping criterion;
5. returned solution;
6. feasibility or computational-complexity remarks when necessary.

Pseudocode is not forced into one overall algorithm. Use:

- overall pseudocode when the global control flow itself needs explicit representation;
- component/mechanism pseudocode when a new decoder, transformation, adaptive controller, or other mechanism needs its own executable logic.

# 5. Computational Experiments

Only three second-level headings are fixed.

## 5.1 Experimental Setup

Opening content:

1. computing environment: language/version, compiler, OS, CPU, RAM, threads/processes, solver/version;
2. experimental protocol: budget, termination, repetitions, random seeds, timing scope, aggregation;
3. metrics: objective, best/average, RPD/ARPD, W/T/L, runtime, analysis unit.

### 5.1.1 Instance Generation

Cover:

1. factors, ranges, distributions, special-feature generation, Small/Large grouping, counts;
2. IDs, seeds, reproducibility, and summary table.

### 5.1.2 Taguchi Calibration

Cover:

1. parameters/levels, design, calibration instances, runs, budget, response;
2. main-effect / S/N analysis as applicable;
3. confirmation experiment;
4. final settings and non-calibrated parameters.

## 5.2 Computational Comparison

Opening content:

1. comparison algorithms and why they are included;
2. original reference on first mention;
3. implementation source: official / author / reproduction / adaptation;
4. parameter sources and problem-specific adaptations;
5. fair comparison protocol;
6. baseline configuration table.

### 5.2.1 Comparison with MIP

Report:

- solver/version;
- time limit;
- threads;
- gap/tolerance;
- incumbent;
- bound;
- solver status;
- runtime;
- deviations from optimum only on certified optima.

### 5.2.2 Small Benchmark

Use a unified main table and discuss:

```text
overall result
→ strongest comparator
→ group pattern
→ ties/reversals
→ optional distribution/convergence evidence
→ bounded conclusion
```

### 5.2.3 Large Benchmark

Use the same metrics/table logic as Small, but focus on:

- scale effects;
- strongest baseline;
- anomalies/reversals;
- scalability;
- optional convergence/runtime/evaluation evidence.

### 5.2.4 Statistical Comparison

Report:

- analysis unit;
- pairing;
- test suitability;
- ranks;
- W/T/L;
- raw/adjusted p-values;
- effect size / critical-difference analysis when applicable;
- explicit connection back to the descriptive findings.

Do not create a separate fixed `Search Behavior and Computational Efficiency` second-level section. Place such evidence inside Small/Large comparison or Component Analysis.

## 5.3 Component Analysis

Cover:

1. experimental design: remove / replace / alternative variants;
2. controlled conditions: data, budget, seeds, stopping, decoder;
3. solution quality;
4. computational cost;
5. statistical evidence;
6. acceleration savings when relevant;
7. positive, neutral, negative, and scale-dependent effects;
8. whether evidence supports the claimed role of each component.

Use `5.3.x` headings named after actual components only when needed.

# 6. Conclusions

Use three paragraph responsibilities.

### Paragraph 1 — Research summary
Summarize the studied problem, formulation, and proposed method.

### Paragraph 2 — Main findings
Summarize the main exact/MIP, Small/Large, statistical, and component-level findings.

### Paragraph 3 — Boundaries, limitations, and future work
State concrete limitations and directly corresponding future extensions. Do not add unrelated future-work lists.

# Cross-structure rules

1. The Structure Specification defines where and what to write; Writing Specifications explain difficult How problems.
2. Writing Specifications may elaborate a structural slot but must not create a competing section hierarchy.
3. Contribution claims in the Introduction must map to technical content in Chapters 3/4 and evidence in Chapter 5.
4. The Conclusion must not introduce new contributions or experiments.
5. A simple content slot may rely on a template without a dedicated Writing Specification.
6. Conditional content must remain conditional; do not force illustrative examples, theory, pseudocode, or extra mechanisms when they are not scientifically needed.

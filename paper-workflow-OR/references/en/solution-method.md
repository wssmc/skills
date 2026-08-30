# Solution method

## Chapter opening and method branch

**Guide:** method-design motivation -> overall framework -> encoding/decoding -> initialization -> core method and components -> pseudocode -> theoretical/complexity analysis

Open with the computational or analytical need, the problem structure exploited, and the method class. Do not claim that direct solution is insufficient unless exact/reference experiments, complexity, scale, or a documented requirement supports that statement.

Select content by method type:

- **Exact/decomposition:** formulation transformation, bounds, master/subproblem or pricing/separation logic, validity, convergence/termination, and implementation details needed for reproduction.
- **Heuristic/metaheuristic:** solution representation/construction, feasibility handling, search components, acceptance/update logic, stopping conditions, and stochastic protocol.
- **Approximation:** algorithm plus proved guarantee and its assumptions.
- **Learning-assisted:** prediction/learning target, training data split, features, leakage controls, interface with optimization, feasibility safeguards, and evaluation against non-learning baselines.
- **Hybrid/matheuristic:** which decisions each component owns, what information crosses interfaces, and how budgets are allocated.

## 4.1 Overall framework

**Guide:** difficulty -> method class -> design idea -> modules -> interfaces -> output

State whether the method is exact, decomposition-based, approximate, heuristic, metaheuristic, hybrid, or learning-assisted. Describe inputs, modules, information flow, current/best solution updates, stopping logic, and outputs.

Use a framework figure only when module interfaces, iteration flow, or information exchange are not already clear from concise prose and pseudocode. A suitable caption is:

`Figure X. Overall framework of the proposed [method name].`

Alternative:

`Figure X. Overall workflow of the proposed [method name].`

Source-derived example:

`Figure X. Overall framework of the proposed two-phase solution approach.`

## 4.2 Solution representation or mathematical decomposition

**Guide:** decision information -> encoding -> decoding -> feasibility -> evaluation

For representation-based methods, explain what is directly encoded and what is determined during decoding. Show how feasibility is preserved or repaired and how the decoded solution maps to the model objective.

When no explicit encoding exists, use a truthful title such as `Solution construction`, `Master problem and subproblem`, `Pricing problem`, `Cut generation`, or another method-specific function. Do not force encoding/decoding language onto exact, decomposition, or direct mathematical procedures.

## 4.3 Initialization

**Guide:** purpose -> candidate rules -> construction -> evaluation -> selected initializer

Describe initialization only when it is substantive, affects performance, or is needed for reproduction. Otherwise merge it into the core method or implementation settings.

## 4.4 Core solution method and components

Use the actual method name where appropriate. Give a whole-method paragraph before component subsections.

For each actual component:

1. Purpose and targeted failure mode.
2. Procedure, formula, score, or decision rule.
3. Inputs, outputs, feasibility conditions, and interface with adjacent modules.
4. Pseudocode, equations, or a precise protocol when they materially improve reproducibility.

Name components by function, never `Component A/B`.

### Complete pseudocode

Include the elements that exist: inputs/outputs, initialization, iteration/decomposition loop, component calls, candidate acceptance, incumbent/bound updates, and stopping condition. Cross-check symbols, direction of improvement, tie handling, feasibility logic, and termination against the implementation when available. Use component-level pseudocode only when the full procedure would otherwise be ambiguous.

Source-derived algorithm caption patterns include:

- `Phase-I backward decoding`
- `Non-final-stage left-shift compaction`
- `Phase-II forward decoding`
- `Destruction`
- `Reconstruction`
- `Local search`
- `Acceptance criterion`

## 4.5 Theoretical properties or complexity analysis

Choose content by method type:

- exact/decomposition: correctness, validity, bounds, finite convergence, cut/pricing logic;
- approximation: approximation guarantee only if proved/cited;
- heuristic/metaheuristic: feasibility preservation, termination, and time complexity where meaningful.

Define scale parameters and state whether complexity is worst-case, amortized, or empirical. Analyze only meaningful dominant operations; do not add a decorative Big-O expression that ignores solver calls or variable iteration counts. Do not state convergence, optimality, or approximation guarantees without formal support.

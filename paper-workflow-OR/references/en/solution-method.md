# Solution method

## Chapter opening

**Guide:** method-design motivation -> overall framework -> encoding/decoding -> initialization -> core method and components -> pseudocode -> theoretical/complexity analysis

Open with why direct solution is insufficient, what problem structure is exploited, and what class of method is proposed.

## 4.1 Overall framework

**Guide:** difficulty -> method class -> design idea -> modules -> interfaces -> output

State whether the method is exact, decomposition-based, approximate, heuristic, metaheuristic, hybrid, or learning-assisted. Describe inputs, modules, information flow, current/best solution updates, stopping logic, and outputs.

Required default figure:

`Figure X. Overall framework of the proposed [method name].`

Alternative:

`Figure X. Overall workflow of the proposed [method name].`

Source-derived example:

`Figure X. Overall framework of the proposed two-phase solution approach.`

## 4.2 Encoding and decoding

**Guide:** decision information -> encoding -> decoding -> feasibility -> evaluation

Explain what is directly encoded and what is determined during decoding. Show how feasibility is preserved or repaired and how the decoded solution maps to the model objective.

Branch: when no explicit encoding exists, use `Solution representation and solution construction` instead.

## 4.3 Initialization

**Guide:** purpose -> candidate rules -> construction -> evaluation -> selected initializer

Describe initialization only when it is substantive. If initialization is trivial, merge it into the core method.

## 4.4 Core solution method and components

Use the actual method name where appropriate. Give a whole-method paragraph before component subsections.

For each actual component:

1. Purpose and targeted failure mode.
2. Procedure, formula, score, or decision rule.
3. Inputs, outputs, feasibility conditions, and interface with adjacent modules.
4. Pseudocode when it materially improves reproducibility.

Name components by function, never `Component A/B`.

### Complete pseudocode

Include inputs/outputs, initialization, main loop, component calls, candidate acceptance, current/best update, and stopping condition. Use component-level pseudocode only when the full procedure would otherwise be ambiguous.

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

Define scale parameters, analyze decoding and major components, and derive per-iteration and total complexity. Do not state convergence, optimality, or approximation guarantees without formal support.

# Problem, formulation, illustrative instance, and complexity

## Problem description and illustrative instance

**Guide:** system elements -> operating process -> decisions -> key conditions -> assumptions -> illustrative data -> explanatory solution

- Define entities, resources, stages, decision timing, and the objective.
- State feasibility conditions and assumptions, including omitted factors and scope boundaries.
- Add a compact illustrative instance only when it materially clarifies feasibility, timing, interaction among features, or the mapping from data to decisions.

### Illustrative-instance tables

Choose the smallest table set that remains readable and lets a reader reconstruct the instance. Split entity/task data from resource/calendar/compatibility data when combining them would obscure units, keys, or constraints; otherwise consolidate. Do not invent data merely to complete an example.

Caption patterns:

- `Table X. [Primary input data] of the illustrative instance.`
- `Table X. [Resource or constraint data] of the illustrative instance.`
- `Table X. [Additional data category] of the illustrative instance.`

Source-derived examples:

- `Table X. Processing times and due windows of the illustrative instance.`
- `Table X. Machine unavailability periods of the illustrative instance.`

### Explanatory figure

Use a Gantt chart for scheduling, or a route/network/layout/timeline figure for other problem families.

Possible generic caption:

`Figure X. Gantt chart of an illustrative solution for the illustrative instance.`

Use one term consistently (`illustrative instance` is usually clear); follow the target outlet when it has an established convention.

After the figure, explicitly connect each data table to the displayed solution and point out the feature or conflict that motivates the model.

## Mathematical formulation

**Guide:** notation -> parameter construction -> objective -> complete formulation -> operational interpretation

- Define sets, indices, parameters, uncertain quantities, decision variables, auxiliary variables, units, and domains before or at first use.
- Explain data-to-parameter or scenario construction when applicable.
- Present the complete objective and all necessary constraints.
- Interpret non-obvious constraint groups and modelling choices, and state which operational rule each group enforces.
- Check index domains, units, objective direction, variable domains, big-M values/bounds, and the logical completeness of linking constraints against the implementation when available.

### Notation table (conditional)

When the number or reuse of symbols makes prose definitions difficult to navigate, a suitable MIP caption is:

`Table X. Notation for the MIP model.`

Alternatives:

- `Table X. Notation for the mathematical model.`
- `Table X. Notation for the nonlinear programming model.`
- `Table X. Notation for the stochastic programming model.`
- `Table X. Notation for the proposed formulation.`

Group entries as sets/indices, parameters, uncertain/random quantities, decision variables, and auxiliary variables.

## NP-hardness and theoretical properties

### Placement branch

- If the proof uses only the problem definition, place it immediately after the problem-description subsection and before the formulation.
- If the proof relies on model notation or the journal convention places theory after formulation, place it immediately after the formulation.

Use a real title such as `Problem complexity`, `Computational complexity`, or `NP-hardness`, not a generic placeholder.

### Valid proof patterns

1. A known NP-hard problem is a special case of the studied problem.
2. A polynomial reduction maps a known NP-hard problem to the studied problem.
3. A reliable source proves NP-hardness for a special case whose assumptions and objective genuinely match the reduction argument.

Suggested statement:

`Proposition 1. The considered problem is NP-hard.`

Special-case logic:

```text
known NP-hard problem P
-> fix/remove specified features of Q
-> resulting special case of Q is equivalent to P
-> P is a special case of Q
-> Q is NP-hard
```

Do not claim NP-hardness because the formulation is large or commercial solvers are slow. To claim NP-completeness, define a decision version and also establish membership in NP.

State every feature fixed, removed, or transformed in a special-case argument. Explain how the result motivates the selected solution method, without implying that NP-hardness alone proves the chosen heuristic is necessary or effective.

## Handoff to the solution method

When both chapters are being planned together and coordination would save work, optionally use the [coordinated problem-method section workflow](problem-method-joint-writing.md). It does not require a separate interface-ledger deliverable.

Keep problem-defining schedule construction, completion-time recurrences, objectives, and feasibility relations in this chapter when they are part of the problem or model rather than an algorithmic choice. Give reusable equations stable labels and record the interface that the solution method needs: encoded decisions, decoded decisions, feasibility conditions, and evaluation output. The method chapter should cross-reference these definitions instead of restating them.

An algorithm-specific decoder, repair operator, timing subproblem, incremental evaluator, or other procedure that changes how a candidate solution is constructed or evaluated belongs in the solution-method exposition even when it uses model notation. State that distinction explicitly when chapter ownership could otherwise be ambiguous.

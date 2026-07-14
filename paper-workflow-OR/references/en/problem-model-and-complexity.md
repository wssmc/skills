# Problem, formulation, illustrative instance, and complexity

## 3.1 Problem description and illustrative instance

**Guide:** system elements -> operating process -> decisions -> key conditions -> assumptions -> illustrative data -> explanatory solution

- Define entities, resources, stages, decision timing, and the objective.
- State feasibility conditions and assumptions, including omitted factors and scope boundaries.
- Add a compact illustrative instance when the problem is not immediately transparent.

### Illustrative-instance tables

Use `x` tables, where `x` equals the number of independent input-data categories. Use at least two when the problem has separate entity/task data and resource/calendar/compatibility data.

Caption patterns:

- `Table X. [Primary input data] of the illustrative instance.`
- `Table X. [Resource or constraint data] of the illustrative instance.`
- `Table X. [Additional data category] of the illustrative instance.`

Source-derived examples:

- `Table X. Processing times and due windows of the illustrative instance.`
- `Table X. Machine unavailability periods of the illustrative instance.`

### Explanatory figure

Use a Gantt chart for scheduling, or a route/network/layout/timeline figure for other problem families.

Preferred generic caption:

`Figure X. Gantt chart of an illustrative solution for the illustrative instance.`

Avoid mixing `demo instance`, `sample case`, and `illustrative instance` in one manuscript. Prefer `illustrative instance`.

After the figure, explicitly connect each data table to the displayed solution and point out the feature or conflict that motivates the model.

## Mathematical formulation

**Guide:** notation -> parameter construction -> objective -> complete formulation -> operational interpretation

- Define sets, indices, parameters, uncertain quantities, decision variables, auxiliary variables, and domains before use.
- Explain data-to-parameter or scenario construction when applicable.
- Present the complete objective and all necessary constraints.
- Interpret non-obvious constraint groups and modelling choices.

### Notation table

Default MIP caption:

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
3. A reliable source proves NP-hardness for an exactly matching special case.

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

Explain how the complexity result motivates the selected solution method.

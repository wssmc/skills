# Fixed-title Chapter 3–4 blueprint for scheduling heuristics

Use this branch for heuristic or metaheuristic scheduling papers unless the journal or existing manuscript already fixes different titles. Keep the English titles below. Replace only the baseline method and method-specific mechanism headings with their real functional names.

## Chapter 3: `Problem Description and Mathematical Formulation`

### 3.1 `Problem Description`

Write in this order:

1. scheduling environment, jobs/operations, resources, route, decisions, and objective;
2. explicit assumptions and the scope created by them;
3. one small illustrative instance with an input-data table and a Gantt/network schedule produced from the same data;
4. a short explanation of the conflict, waiting, feasibility relation, or objective value visible in the illustration.

For a permutation flow shop, explicitly decide and state the applicable assumptions:

- job availability or release times;
- whether processing times are known and deterministic;
- whether every job visits the machines once in the same order;
- one-job-per-machine and one-operation-per-job capacity restrictions;
- non-preemption;
- treatment of setup and transportation times;
- buffer/blocking policy and machine availability, when specified;
- the common permutation requirement and optimization objective.

Do not silently add an assumption that the supplied problem does not support.

### 3.2 `Notation and Mathematical Formulation`

Keep notation and formulas in this one section. Start with a grouped notation table: sets/indices, parameters, decision or solution objects, and derived quantities, including domains and units. Then present schedule construction, feasibility, and objective relations in operational order.

Use this fixed explanation pattern for each equation group:

```text
operational rule
→ displayed equation(s)
→ term-by-term symbol explanation
→ what the equation calculates or enforces
→ relation to the next equation group
```

Give equations stable labels. If only an evaluator is supplied, write only the supported schedule-evaluation formulation; never invent a complete MIP. Optional supported theory may follow under `Problem Properties`.

## Chapter 4: `Proposed Solution Method`

| No. | Fixed English section title | What it must contain | Required support |
|---|---|---|---|
| 4.1 | `Overall Framework` | Method class, inputs/outputs, module order, maintained states, information flow, feedback, and stopping logic. | One real flowchart for a multi-module method. |
| 4.2 | `Solution Representation and Decoding` | Encoded object, decoder/evaluator, mapping to Chapter 3 feasibility/objective, and any search-space restriction. | Representation/decoder example or pseudocode only when the mapping is nontrivial. |
| 4.3 | `Initialization` | Construction sequence, evaluation, tie handling, and returned initial state. | Short pseudocode or worked construction example for a multi-step initializer. |
| 4.4 | `Neighborhood Structures` | For every operator: purpose, selected objects, transformation, output, feasibility, evaluation, and search scale. Keep candidate generation separate from search control. | One multi-panel before/selection/after figure for the actual operators. |
| 4.5 | `[Baseline Method] Search Framework` | Operator selection, candidate generation call, acceptance/selection, current/reference/best update, schedules or memory, termination, and return value. | Necessary control formula(s) or compact local pseudocode. |
| 4.6 | `[Method-Specific Mechanism Name]` | Motivation, trigger, maintained state, rule, update order, interface with 4.5, intended effect, and boundary. Repeat this numbered layer for each substantive mechanism. | Mechanism diagram, state/update table, or component pseudocode—whichever exposes the dependency. |
| 4.7 | `Complete Algorithm` | End-to-end procedure after all components are defined; inputs, parameters, states, call order, termination, and outputs. | One complete pseudocode block. |
| 4.8 | `Feasibility and Computational Complexity Analysis` | Why representation/operators/decoder preserve feasibility; time complexity of initialization, one iteration, and the complete method; space complexity and dominant operations. | Define all scale parameters and show the derivation. Omit unsupported convergence/optimality claims. |

For the supplied Adaptive SA example, use `Simulated Annealing Search Framework` at 4.5 and `Adaptive Operator Selection` at 4.6.

## Delivery boundary

Return the chapter/section blueprint and the required artifact list. Do not append requests for tuning ranges, seeds, baselines, repetitions, hardware, ablations, or results unless the computational-study chapter is also requested. Raise only a Chapter 3/4 blocker that prevents truthful problem or method writing.

For exact, decomposition, mathematical-programming, or learning-centered methods, preserve the section-level delivery scale but replace this heuristic branch with the method's real responsibilities.

# Optional coordinated planning for problem/model and solution-method chapters

Use this reference only when both chapters are in scope and coordination prevents duplicated formulas, notation, or responsibilities. Default to a section-level blueprint rather than a paragraph inventory.

For scheduling heuristic/metaheuristic papers, use the [fixed-English-title Chapter 3–4 template](../../templates/chapter3-4-section-template.md). A journal template or established manuscript structure takes precedence.

## 1. Fixed Chapter 3 structure

Use the chapter title `Problem Description and Mathematical Formulation`.

### 3.1 `Problem Description`

Write in this order:

1. scheduling environment, jobs/operations, resources, route, decisions, and objective;
2. explicit assumptions actually used by the problem and the scope they create;
3. one small illustrative instance with an input-data table and a Gantt/network figure generated from the same data;
4. an explanation of the main waiting relation, resource conflict, feasibility relation, or objective value visible in the figure.

The PFSP assumption checklist covers job availability, processing-time determinism, machine route, machine/job capacity, preemption, setup and transport times, buffer/blocking policy, machine availability, common permutation, and objective. A checklist item is not a fact; state it only when supported.

### 3.2 `Notation and Mathematical Formulation`

Keep notation, equations, and equation interpretation in this one section. Start with a grouped notation table for sets/indices, parameters, decision or solution objects, and derived quantities. Then present schedule recurrences, feasibility, and objective in operational order.

Use this fixed pattern for each equation group:

```text
operational rule → equation → term-by-term explanation
→ what it calculates/enforces → relation to the next group
```

Define standard objectives, feasibility, and evaluation formulas once in Chapter 3; Chapter 4 cross-references them. Keep only algorithm-specific decoding, repair, or incremental evaluation in the method chapter. Never invent a MIP from incomplete evidence.

## 2. Fixed Chapter 4 structure

Use the chapter title `Proposed Solution Method`.

| No. | Fixed English title | Responsibility | Required support |
|---|---|---|---|
| 4.1 | `Overall Framework` | Method class, inputs/outputs, modules, states, information flow, feedback, and stopping logic | Overall flowchart |
| 4.2 | `Solution Representation and Decoding` | Encoded object, decoding/evaluation, and mapping to Chapter 3 feasibility/objective | Representation/decoder illustration or short pseudocode when needed |
| 4.3 | `Initialization` | Construction steps, evaluation, tie handling, and initial state | Short pseudocode or construction example for a multi-step method |
| 4.4 | `Neighborhood Structures` | Each operator's purpose, selection, transformation, output, feasibility, evaluation, and search scale | Multi-panel neighborhood-operation figure |
| 4.5 | `[Baseline Method] Search Framework` | Operator selection, candidate call, acceptance/selection, current/reference/best update, schedule/memory, termination, and return | Control equations or local pseudocode |
| 4.6 | `[Method-Specific Mechanism Name]` | Motivation, trigger, state, rule, update order, 4.5 interface, effect, and boundary; add sections for additional substantive mechanisms | Mechanism figure, state table, or component pseudocode |
| 4.7 | `Complete Algorithm` | Integrate all previously defined components in true execution order | Complete pseudocode |
| 4.8 | `Feasibility and Computational Complexity Analysis` | Feasibility preservation; initialization, per-iteration, and total time complexity; space complexity and dominant operations | Define scale parameters and show the derivation |

Do not leave placeholders at 4.5 or 4.6. For the current Adaptive SA example, use `Simulated Annealing Search Framework` and `Adaptive Operator Selection`.

## 3. Literature-derived constraints

- Neighborhoods generate candidates; the baseline search framework accepts/selects and advances state. Give them independent headings.
- Describe standard components completely but compactly; give more technical space to problem adaptations and evidence-backed core mechanisms.
- Place integrated pseudocode after component definitions; it must not introduce a complex mechanism for the first time.
- Complexity is not decorative Big-O: include initialization, evaluator calls, iteration count, and algorithm-specific subprocedures.
- Add correctness, connectivity, termination, or bounds to 4.8 only when supported; otherwise do not claim convergence or global optimality.

## 4. Lightweight cross-chapter check

- Chapter 3 notation, feasibility, objective, and evaluation agree with Chapter 4 representation/decoding.
- Chapter 4 does not repeat the standard model; it adds method-specific representation, construction, neighborhoods, control, mechanisms, and complexity.
- Objective or feasibility conflicts are reported, not silently reconciled.

## 5. Delivery boundary

Default to the section-planning table and required artifact list. If only Chapters 3 and 4 are in scope, do not append questions about tuning ranges, seeds, baselines, repetitions, hardware, ablations, or results. List only a blocker that prevents truthful Chapter 3/4 writing.

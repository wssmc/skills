# Problem and Model Writing Specification

## 1. Separate operational narrative from mathematical formulation

Problem Description should let a reader understand the system without equations:
- what is scheduled;
- how jobs flow;
- how resources compete;
- where special constraints arise;
- what decisions define a feasible schedule;
- what objective is optimized.

Mathematical Formulation then maps these rules into variables and constraints.

## 2. Introduce special features by contrast with the base problem

Use:

```text
base environment
→ added feature
→ operational meaning
→ feasibility/decision consequence
```

A parameter difference is not automatically a structural difference. Explain what the feature changes in the feasible schedule.

## 3. Write assumptions as model boundaries

Assumptions define what the model includes/excludes. Prioritize assumptions that change feasible-set interpretation:
- identical/uniform/unrelated machines;
- preemption/non-preemption;
- setup/transport treatment;
- buffer policy;
- release information;
- machine availability.

Avoid boilerplate assumptions that simply restate the already-defined model.

## 4. Design the illustrative example to expose the hard part

A useful example is small but still activates the distinctive constraint.

Preferred evidence stack:

```text
minimal instance table
→ relationship/process figure
→ Gantt chart
→ explanation linking visible schedule behavior to model rules
```

The example explains the problem; it does not prove algorithm performance.

## 5. Design notation before equations

Use conventional scheduling notation where possible. Keep:
- one symbol = one semantic meaning;
- consistent index order;
- clear distinction between parameters and variables;
- auxiliary variables only when they are genuinely needed.

## 6. Order constraints by operational logic

A common order is:

```text
objective
→ assignment/existence
→ technological precedence
→ machine non-overlap
→ problem-specific constraints
→ objective linking
→ domains
```

## 7. Explain constraints as operational rules

Do not write only `Constraint (7) ensures precedence.`

Explain:
- what production rule it represents;
- which decisions it links;
- why it excludes illegal schedules;
- how it interacts with neighboring constraints when non-obvious.

## 8. Connect problem properties to later method design

Complexity, bounds, dominance, or structural properties should have a role:
- justify heuristic search;
- provide experimental reference;
- support pruning;
- motivate representation/decoder design.

Do not add decorative complexity claims without proof or citation.

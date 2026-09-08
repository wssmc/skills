# Problem and Model Writing Specification

## 1. Application Generalization Check

Do not silently generalize a restricted industrial fact into a broader scientific problem. For example:

- two actual product types do not automatically justify an arbitrary multi-family claim;
- one machine revisited once does not automatically imply arbitrary multi-machine re-entry;
- routes fixed by product type do not automatically imply arbitrary missing-operation patterns.

If a generalized model is deliberately studied, state that the application is a restricted case of the generalized formulation, and ensure that experiments cover the generalized dimensions.

## 2. Separate operational narrative from mathematical formulation

Problem Description should let a reader understand the system without equations:
- what is scheduled;
- how jobs flow;
- how resources compete;
- where special constraints arise;
- what decisions define a feasible schedule;
- what objective is optimized.

Mathematical Formulation then maps these rules into variables and constraints.

## 3. Introduce special features by contrast with the base problem

Use:

```text
base environment
→ added feature
→ operational meaning
→ feasibility/decision consequence
```

A parameter difference is not automatically a structural difference. Explain what the feature changes in the feasible schedule.

## 4. Write assumptions as model boundaries

Assumptions define what the model includes/excludes. Prioritize assumptions that change feasible-set interpretation:
- identical/uniform/unrelated machines;
- preemption/non-preemption;
- setup/transport treatment;
- buffer policy;
- release information;
- machine availability.

Avoid boilerplate assumptions that simply restate the already-defined model.

Assumptions and illustrative examples are content responsibilities of Section 3.1, not mandatory visible subsections. Default to a single `3.1 Problem Description` containing narrative, assumptions, and example. Create separate `3.1.1 Assumptions` or `3.1.2 Illustrative Example` headings only when the content is long enough, the journal benefits from that hierarchy, or the user requests it.

## 5. Design the illustrative example to expose the hard part

A useful example is small but still activates the distinctive constraint.

Preferred evidence stack:

```text
minimal instance table
→ relationship/process figure
→ Gantt chart
→ explanation linking visible schedule behavior to model rules
```

The example explains the problem; it does not prove algorithm performance.

## 6. Default MIP presentation contract

Unless journal style or formulation complexity requires otherwise, use:

```text
problem narrative
→ compact assumptions
→ illustrative example
→ one consolidated notation table
→ complete formulation in one continuous block
→ grouped operational explanation
→ optional complexity/properties
```

Do not default to alternating each variable or equation with a separate explanatory paragraph.

## 7. Design notation before equations

Use conventional scheduling notation where possible. Keep:
- one symbol = one semantic meaning;
- consistent index order;
- clear distinction between parameters and variables;
- auxiliary variables only when they are genuinely needed.

## 8. Order constraints by operational logic

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

## 9. Explain constraints as operational rules

Do not write only `Constraint (7) ensures precedence.`

Explain:
- what production rule it represents;
- which decisions it links;
- why it excludes illegal schedules;
- how it interacts with neighboring constraints when non-obvious.

## 10. Connect problem properties to later method design

Complexity, bounds, dominance, or structural properties should have a role:
- justify heuristic search;
- provide experimental reference;
- support pruning;
- motivate representation/decoder design.

Do not add decorative complexity claims without proof or citation.

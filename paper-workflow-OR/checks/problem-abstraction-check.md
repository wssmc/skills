# Problem Abstraction Check

## Input

- industrial description;
- routes;
- resources;
- constraints;
- objectives;
- product types;
- available data.

## Step 1 — Enumerate industrial facts

List every supplied characteristic without judging novelty.

## Step 2 — Identify scheduling consequences

For each fact, determine whether it changes the feasible set, decision variables, precedence, resource capacity, processing time, objective, or representation/decoder.

## Step 3 — Classify scientific role

Assign one role:

- primary scientific structure;
- secondary structural feature;
- application boundary;
- data/parameter characteristic;
- implementation detail.

## Step 4 — Test interaction

Determine whether multiple features merely coexist or interact structurally.

## Step 5 — Check the generalization boundary

Compare actual industrial scope with proposed formal scope and flag silent generalization.

## Output

```text
Primary scientific structure:
Secondary features:
Application boundaries:
Features excluded from problem identity:
Required literature streams:
Generalization risks:
Recommended problem-name candidates:
```

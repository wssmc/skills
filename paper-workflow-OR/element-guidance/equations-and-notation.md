# Equations and Notation Guidance

Use conventional scheduling notation where possible. Internal consistency matters more than stylistic novelty.

## Notation design

Common conventions:

| Meaning | Typical form |
|---|---|
| Jobs | `J`, `\mathcal{J}` |
| Stages | `S`, `\mathcal{S}` |
| Machines at stage s | `M_s`, `\mathcal{M}_s` |
| Processing time | `p_{js}`, `p_{ij}` |
| Start time | `S_{js}` / `s_{js}` |
| Completion time | `C_{js}` |
| Makespan | `C_{\max}` |
| Release time | `r_j` |
| Due date | `d_j` |
| Assignment variable | `x_{jsm}` |
| Sequencing variable | `y_{ijk}` |

Rules:
- one symbol = one meaning;
- consistent subscript order;
- distinguish parameters from variables;
- introduce auxiliaries only when necessary;
- avoid redefining standard symbols without reason.

## Notation table

For an MIP/MILP model, consolidate sets, indices, parameters, decision variables, and auxiliary variables into one notation table unless journal style strongly prefers otherwise. Recommended caption: `Notation for the MIP model`.

Order:
1. sets and indices;
2. parameters;
3. decision variables;
4. auxiliary/derived variables.

Typical columns:

```text
Symbol | Definition | Domain/Unit (optional)
```

Do not repeat every notation-table definition in the prose.

## Formulation-first presentation

After the notation table, present the objective and all constraints as one continuous mathematical formulation. Then explain constraint groups in operational order. Do not alternate every equation with a paragraph unless an unusually complex equation requires immediate interpretation.

## Objective function

Introduce what is optimized, not just the equation number.

Prefer:

> `The objective minimizes the maximum completion time over all jobs.`

Avoid:

> `Equation (1) is the objective function.`

## Constraint groups

Group constraints by scientific responsibility:

```text
assignment
→ technological precedence
→ machine capacity/non-overlap
→ problem-specific constraints
→ objective linking
→ variable domains
```

Use:

> `Constraints (5)–(7) enforce the technological order between consecutive operations.`

## Explain why a constraint works

A useful explanation states:
- production rule;
- variables linked;
- why the relation excludes illegal schedules.

## Big-M constraints

Explain:
- the role of `M`;
- when the inequality is active/inactive;
- a finite bound when available.

Do not write only `M is a large number.`

## Problem properties

A complexity proof should follow a valid reduction/special-case argument. The number of binary variables is not evidence of NP-hardness.

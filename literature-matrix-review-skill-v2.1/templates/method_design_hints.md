# Method Design Hints

## Connect method ideas to literature

Every method hint should be traceable to a paper or a problem mechanism.

| Idea | Inspired by | Adaptation to current problem | Risk |
|---|---|---|---|

## If the problem has missing operations

- Represent only non-missing operations during decoding.
- Let zero processing time mean skipped stage, not a machine-occupying operation.
- Compute the last non-missing stage for objective evaluation.

## If the problem has DAG release constraints

- Maintain a topological-feasible object order.
- Compute release times from all predecessors.
- Repair infeasible moves that place downstream objects before upstream completion.
- Consider critical-path or waiting-time-focused neighborhoods.

## If the problem has nesting-to-lot transformation

- Distinguish upstream and downstream objects in encoding.
- Generate release constraints from part-source relations.
- Consider neighborhoods that accelerate bottleneck upstream objects.

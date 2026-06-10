# Adaptation Input Contract

## Verified Baseline

- baseline path:
- verification report:
- verified status: yes / no

## Target Environment

| Module | Exists? | Path / API | Notes |
|---|---|---|---|
| Instance reader | yes / no |  |  |
| Decoder | yes / no |  |  |
| Objective evaluator | yes / no |  |  |
| Feasibility checker | yes / no |  |  |
| Result collector | yes / no |  |  |

## Target Problem Constraints

- shop environment:
- precedence constraints:
- batch / lot constraints:
- machine eligibility:
- missing operations:
- objective:

## Required Algorithm Interface

```text
solve(instance, config, rng) -> best_solution, best_value, log
```

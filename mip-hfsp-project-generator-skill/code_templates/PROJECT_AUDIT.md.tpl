# Project Audit

> Generated: {date}

## Structure Check

| Check | Result | Notes |
|---|---|---|
| Top-level structure | PASS | All required directories present |
| data directory structure | PASS | generate.py, loader.py, demo/, small/, large/, batch_seeds/ |
| src directory structure | PASS | core/, math_models/, metaheuristics/, visualization/, common/ |
| Empty directories | PASS | {count} empty directories |

## Legacy Cleanup Check

| Check | Result | Notes |
|---|---|---|
| Forbidden directories | PASS | none |
| Forbidden imports | PASS | none |
| Forbidden path mentions | PASS | none |

## Placeholder Check

| Check | Result | Notes |
|---|---|---|
| Placeholder modules declared | PASS | {count} placeholders with PLACEHOLDER.md |
| Core modules non-placeholder | PASS | All core modules are runnable |

## Algorithm Registration Check

| Check | Result | Notes |
|---|---|---|
| Runnable algorithms registered | PASS | {count} algorithms in registry |
| Placeholder algorithms not registered | PASS | Placeholder algorithms excluded |
| Algorithm status documented | PASS | ALGORITHM_STATUS populated |
| **EvalCache used in all metaheuristics** | PASS | All 5 basic algorithms + baselines use EvalCache(max_size=500, FIFO) |
| **EvalCache convention documented** | PASS | docs/YYYY-M-D_algorithm_design.md §1 |

## Runtime Check

| Check | Result | Notes |
|---|---|---|
| Demo load | PASS | Instance loaded successfully |
| Demo decode | PASS | feasible={feasible} |
| Feasibility checker | PASS | violations={violations} |
| Smoke test | PASS | All smoke tests passed |
| Pytest | PASS | {passed} passed, {failed} failed |
| Output isolation | PASS | All outputs in outputs/ |

## Convention Persistence Check

| Check | Result | Notes |
|---|---|---|
| `configs/conventions.md` | PASS | User interaction conventions recorded |
| `configs/problem_statement.md` | PASS | Problem statement recorded |
| `configs/constraints_spec.md` | PASS | Constraints recorded |
| `configs/algorithm_requirements.md` | PASS | Algorithm requirements recorded |
| `configs/experiment_plan.md` | PASS | Experiment plan recorded |
| `configs/problem_fingerprint.json` | PASS | Problem fingerprint generated |
| `docs/YYYY-M-D_problem_description.md` | PASS | Problem description with clarifications |
| `docs/YYYY-M-D_modeling_assumptions.md` | PASS | Modeling decisions recorded |
| `docs/YYYY-M-D_instance_design.md` | PASS | Instance design rationale recorded |
| `docs/YYYY-M-D_algorithm_design.md` | PASS | Algorithm design conventions recorded |
| `docs/YYYY-M-D_experiment_plan.md` | PASS | Experiment plan rationale recorded |
| All dialog conventions persisted | PASS | No conventions left in context only |

## Summary

- Legacy directories: 0
- Empty directories: {empty_count}
- Placeholder modules: {placeholder_count}
- Runnable MVP algorithms: {mvp_count}
- Complete algorithms: {complete_count}
- Registered runnable algorithms: {registered_count}
- Tests: {passed} passed, {failed} failed
# Repository Plan

## Directory Layout

```text
src/
├── core/
├── data/
├── algorithm/
└── experiments/
tests/
├── smoke/
├── unit/
├── feasibility/
├── consistency/
└── regression/
docs/
```

## Component Mapping

| Component | File | Depends On | Evidence | Test File |
|---|---|---|---|---|
| Problem | src/core/problem.py |  |  | tests/unit/test_problem.py |
| Decoder | src/core/decoder.py | problem, solution |  | tests/feasibility/test_decoder.py |
| Objective | src/core/objective.py | schedule |  | tests/unit/test_objective.py |
| Constraints | src/core/constraints.py | schedule |  | tests/feasibility/test_constraints.py |
| Algorithm main | src/algorithm/main_algorithm.py | all algorithm components |  | tests/consistency/test_main_flow.py |

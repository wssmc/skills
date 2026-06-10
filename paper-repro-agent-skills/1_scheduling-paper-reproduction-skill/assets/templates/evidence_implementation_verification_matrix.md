# Evidence → Implementation → Verification Matrix

| Component | Paper Evidence | Implementation File | Verification Test | Consistency Level | Risk | Notes |
|---|---|---|---|---|---|---|
| Problem definition |  | src/core/problem.py | tests/unit/test_problem.py | A/B/C/D |  |  |
| Decoder |  | src/core/decoder.py | tests/feasibility/test_decoder.py | A/B/C/D |  |  |
| Objective function |  | src/core/objective.py | tests/unit/test_objective.py | A/B/C/D |  |  |
| Initialization |  | src/algorithm/initialization.py | tests/consistency/test_initialization_matches_paper.py | A/B/C/D |  |  |
| Operators |  | src/algorithm/operators.py | tests/consistency/test_operator_set_matches_paper.py | A/B/C/D |  |  |
| Acceptance |  | src/algorithm/acceptance.py | tests/consistency/test_acceptance_matches_paper.py | A/B/C/D |  |  |
| Experiment protocol |  | src/experiments/run_batch.py | tests/consistency/test_experiment_protocol.py | A/B/C/D |  |  |

## Consistency Levels

- A: 原文明确给出，代码严格一致。
- B: 原文部分给出，代码做了必要补全。
- C: 原文未给出，代码基于常见做法假设。
- D: 与原文不同，属于适配或改进；不能称为 faithful reproduction。

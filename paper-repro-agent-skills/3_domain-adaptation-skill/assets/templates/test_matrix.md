# Adaptation Test Matrix

| Test Type | Purpose | Test File | Blocking? | Status |
|---|---|---|---|---|
| Interface compatibility | adapted algorithm calls target reader/decoder/objective correctly | tests/test_adapter_interface.py | yes | pending |
| Target feasibility | produced schedule satisfies target constraints | tests/test_target_feasibility.py | yes | pending |
| Objective recomputation | reported value equals independent target evaluator | tests/test_objective_recompute.py | yes | pending |
| Seed stability | fixed seed produces reproducible behavior | tests/test_seed_stability.py | yes | pending |
| Baseline-compatible regression | no obvious degradation on overlapping subdomain | tests/test_baseline_compatible_regression.py | conditional | pending |

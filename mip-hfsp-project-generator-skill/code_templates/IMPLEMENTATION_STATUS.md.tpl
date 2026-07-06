# Implementation Status

| Module | Status | Notes |
|---|---|---|
| data/generate.py | complete | Generates demo/small/large instances |
| data/loader.py | complete | Loads txt data into Instance |
| src/core/domain.py | complete | Defines Instance, Schedule, Result, Operation, PrecedenceArc |
| src/math_models/gurobi_model.py | runnable_mvp | Builds Gurobi MIP model |
| src/math_models/lower_bound.py | runnable_mvp | Fast + exact lower bounds |
| src/metaheuristics/initial/ | complete | SPT, LPT, NEH, random, problem-specific init |
| src/metaheuristics/encoding/ | complete | Sequence encoding + machine assignment |
| src/metaheuristics/decoding/ | complete | List decoder, feasibility checker, metrics, eval_cache, result_reproducer |
| src/metaheuristics/neighborhood/ | runnable_mvp | Basic + problem-specific neighborhoods |
| src/metaheuristics/baselines/ | complete | FIFO, SPT, LPT, NEH, problem-specific baselines |
| src/metaheuristics/sa/ | runnable_mvp | Basic SA with problem-specific components |
| src/metaheuristics/ma/ | runnable_mvp | Basic MA with problem-specific components |
| src/metaheuristics/ig/ | runnable_mvp | Basic IG with problem-specific components |
| src/metaheuristics/ga/ | runnable_mvp | Basic GA with problem-specific components |
| src/metaheuristics/ts/ | runnable_mvp | Basic TS with problem-specific components |
| src/visualization/ | runnable_mvp | Gantt chart, convergence curve |
| src/ExperimentAnalysis/ | placeholder | Self-provided, not implemented |
| src/common/ | runnable_mvp | Plot utilities, picture config |
| scripts/run_baselines.py | complete | Central dispatch hub |
| scripts/sh_single_instance.sh | complete | Single instance single algorithm |
| scripts/sh_bench_instance.sh | complete | Single instance multi-algorithm |
| scripts/sh_batch_instances_algorithms.sh | complete | Full batch multi-round |
| scripts/sh_analysis.sh | runnable_mvp | Basic result analysis |
| scripts/mip/run_gurobi_mip.py | runnable_mvp | Gurobi MIP solver |
| scripts/doe/ | placeholder | DOE reserved |
| scripts/ablation/quick_test_config.py | runnable_mvp | Quick test config for ablation |
| scripts/ablation/run_ablation.py | placeholder | Ablation reserved |
| scripts/statistics/ | placeholder | Statistics reserved |
| tests/smoke_test.py | complete | Core pipeline smoke test |
| tests/ | runnable_mvp | Unit tests |
| latex/els-cas-templates/ | placeholder | Template not bundled |
| configs/ | complete | Project specification docs |
| docs/ | complete | Problem description + design docs |

## Status Legend

| Status | Meaning |
|---|---|
| `complete` | Current version feature-complete |
| `runnable_mvp` | Runnable but basic implementation |
| `placeholder` | Not implemented, see PLACEHOLDER.md |
| `not_applicable` | Not needed for current problem |
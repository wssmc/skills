# Implementation Status

> 初始状态均为 `not_verified`。只有在对应实现及测试实际通过后，才能改为 `runnable_mvp` 或 `complete`。

| Module | Status | Evidence |
|---|---|---|
| data/generate.py + data/loader.py | not_verified | |
| src/core/domain.py | not_verified | |
| src/metaheuristics/encoding + decoding | not_verified | |
| src/metaheuristics/initial + neighborhood | not_verified | |
| src/metaheuristics/sa + ma + ig + ga + ts | not_verified | |
| src/metaheuristics/baselines | not_verified | |
| src/math_models | not_verified | |
| src/visualization | not_verified | |
| scripts/run_baselines.py | not_verified | |
| scripts/sh_single + sh_bench + sh_batch | not_verified | |
| scripts/doe + ablation + statistics | not_verified | |
| tests | not_verified | |
| latex | not_verified | |

## Status Legend

| Status | Meaning |
|---|---|
| `not_verified` | 尚未通过本项目中的实际检查 |
| `runnable_mvp` | 核心路径可运行，限制已明确记录 |
| `complete` | 需求范围内实现完整且测试通过 |
| `placeholder` | 明确占位并抛出 `NotImplementedError` |
| `not_applicable` | 当前问题不需要 |

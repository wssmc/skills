# Implementation Status

> 初始状态均为 `not_verified`。只有对应 C++/Python 辅助实现及测试实际通过后，才能改为 `runnable_mvp` 或 `complete`。

| Module | Status | Evidence |
|---|---|---|
| C++ domain / IO / decoding | not_verified | |
| C++ EvalCache / metrics / checker | not_verified | |
| C++ SA / MA / IG / GA / TS / baseline | not_verified | |
| C++ registry and runner | not_verified | |
| Gurobi C++ MIP adapter | not_verified | |
| Python instance generation | not_verified | |
| Python result analysis / statistics / visualization | not_verified | |
| C++ smoke and CTest | not_verified | |
| Project audit | not_verified | |
| latex | not_verified | |

## Status Legend

| Status | Meaning |
|---|---|
| `not_verified` | 尚未通过项目中的实际检查 |
| `runnable_mvp` | 核心路径可运行，限制已记录 |
| `complete` | 需求范围内实现完整且测试通过 |
| `placeholder` | 明确占位并显式抛错 |
| `not_applicable` | 当前问题不需要 |

# 算法设计记录

## 问题与解表示

- 问题类型：{problem_type}
- ProblemInstance：{fields_and_invariants}
- CandidateSolution：{representation}
- evaluator/checker：{semantics}
- objective：{definition}

## 随机性

- instance_seed 来源：{file_or_rule}
- solve seeds 文件：configs/seeds/solve_seeds.txt
- rounds：{N}
- 约束：N rounds 等于 N seeds；同一 round 跨算法使用同一个 seed
- RNG：每次 solve 使用局部 std::mt19937_64(solve_seed)

## 算法

| Name | Type | Initialization | Operators | Parameters | Status |
|---|---|---|---|---|---|
| {algorithm} | {baseline/research} | {method} | {operators} | {parameters} | not_verified |

算法集合由问题和文献依据决定。每个候选解直接经过 C++ evaluator，不使用 EvalCache。

## CPLEX

- API：IBM 官方低层 `cplex` Python API
- variables：{...}
- constraints：{...}
- objective：{...}
- solve_seed 到 CPLEX RandomSeed 的映射：{...}
- 与 checker 的一致性测试：{...}

## 公平比较与消融

- 相同算例、round、solve_seed 和预算
- 记录真正改变的算法组件
- 每个研究组件提供消融
- Python 汇总结果；CPLEX MIP 是 Python 参与求解的唯一例外

## 验证

- solution 重放
- objective 一致
- feasibility 一致
- 固定 seed 可重复
- Bash seed 数量和失败传播

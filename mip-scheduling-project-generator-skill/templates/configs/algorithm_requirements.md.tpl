# 算法与精确模型要求

## C++ 算法

- 候选算法：{根据问题和文献列出}
- 统一接口：solve(problem, config)
- SolveConfig：time_limit、solve_seed、round、算法参数
- 唯一 registry：cpp/include/scheduling/registry.hpp
- 评价：直接调用 C++ evaluator，不使用 EvalCache

## CPLEX MIP

- IBM 官方低层 `cplex` Python API
- 模型变量：{...}
- 约束：{...}
- 目标：{...}
- 无法 import cplex 或缺少 license：NOT_RUN
- 禁止 Gurobi、gurobipy 和 docplex 回退

## 复现

- instance seed：每个算例目录保存一个 instance_seed.txt，并写入 index.json
- solve seeds：configs/seeds/solve_seeds.txt
- rounds：{N，必须等于 solve seed 数量}
- 同一 round 跨算法使用相同 seed
- result.json 写入 instance_seed、solve_seed 和 round

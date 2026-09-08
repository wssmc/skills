# 输出质量检查清单

## 定位与架构

- [ ] 项目方法没有被写成 HFSP 专用
- [ ] 当前问题族与直接支持边界已在 docs/problem_model.md 定义
- [ ] C++17 是问题模型、评价、checker 和启发式算法的唯一核心实现
- [ ] Python 只做算例、分析、统计、绘图、报告，以及 CPLEX MIP 这一明确例外
- [ ] Bash 是统一构建、运行、批量、分析和审计入口
- [ ] AGENTS.md 已读取并同步

## CPLEX 与评价

- [ ] MIP 使用 IBM 官方低层 cplex Python API
- [ ] 未生成 Concert C++ 集成
- [ ] 未生成 Gurobi、gurobipy 或 docplex
- [ ] evaluator、checker 与 CPLEX 使用同一问题语义
- [ ] 未生成 EvalCache、eval_cache 或跨运行隐藏缓存
- [ ] solution 可以重放并得到一致 objective 和 feasibility

## 种子

- [ ] 每个算例记录 instance_seed
- [ ] 每次求解显式传入 solve_seed 和 round
- [ ] N rounds 对应恰好 N 个固定、非重复 seeds
- [ ] 同一 round 的比较算法使用同一个 seed
- [ ] result.json 记录 instance_seed、solve_seed 和 round
- [ ] 未使用时间、进程号、random_device 或 shell RANDOM 生成实验 seed

## Bash 与输出

- [ ] build/generate/run_single/run_batch/run_all/run_mip/analyze/audit 脚本齐全
- [ ] 所有脚本使用 set -euo pipefail 并传播失败
- [ ] 所有 smoke、调试和待审阅曲线位于 outputs/tmp/
- [ ] 每个正式测试脚本对应唯一 outputs/formal/{test_id} 前缀
- [ ] 改参目录显示变更参数；未改配置的重复运行使用 `_1`、`_2`，且不覆盖
- [ ] 正式目录内仍按 instance/algorithm/round_seed 隔离
- [ ] 所有产物位于 outputs/
- [ ] Python 对缺失、非法或重复结果返回非零状态

## 测试与状态

- [ ] CMake 和 C++ tests 已真实运行
- [ ] Bash 种子数量、重复值和失败传播测试通过
- [ ] CPLEX Python API 或 license 缺少时状态为 NOT_RUN
- [ ] IMPLEMENTATION_STATUS 没有预填 PASS
- [ ] PROJECT_AUDIT 引用实际命令和结果
- [ ] 没有特殊值补丁、静默异常、测试跳过或兼容层

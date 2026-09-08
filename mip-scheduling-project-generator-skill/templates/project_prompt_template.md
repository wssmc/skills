# 完整研究工程生成提示词

请使用 C++17 核心、IBM 官方低层 `cplex` Python API MIP 和 Bash 固定种子批处理，把下面的问题描述生成可复现研究工程。Python 还负责算例与分析。

## 强制要求

1. 先定义当前问题的数据模型、候选解、可行性和目标，不套用万能 Instance。
2. C++ 实现启发式求解、评价、checker、registry 和序列化。
3. Python 只做算例、CPLEX MIP、汇总、统计、绘图和报告。
4. 不生成 Concert C++、Gurobi、gurobipy、docplex 或 EvalCache。
5. 算例生成显式接收并保存 instance_seed。
6. 求解显式接收 solve_seed 和 round；N 轮必须提供 N 个固定、非重复 seeds。
7. 同一 round 的不同算法使用相同 solve_seed。
8. Bash 统一提供 build、generate、single、batch、all、analysis、audit 入口。
9. 输出位于 outputs/，并包含足以重放解的 result.json 和 solution.json。
10. 生成 AGENTS.md、问题模型文档、实验计划、状态和审计。
11. 无法 import cplex 或 license 不可用时报告 NOT_RUN。
12. 当前流水车间参考只是适配示例，其他问题必须同步修改全链。
13. 所有烟测写入 outputs/tmp/；正式测试脚本与 outputs/formal/{test_id}/ 一一对应，改参标在目录名，未改配置的重跑追加 `_1`、`_2`。
14. 所有算法使用同一进程 CPU 收敛协议：初始化元数据、统一全局精英事件、每 seed 单次运行后离线采样 100 点、右连续阶梯图和首末值校验。

## 问题描述

{粘贴问题描述}

## 交付

- 问题理解和缺失信息
- 问题数据模型与数据格式
- C++ 核心与启发式算法
- Python CPLEX MIP 与辅助工具
- 固定种子文件与 Bash 批处理
- tests、AGENTS.md、状态、审计和 README
- 真实 PASS/FAIL/NOT_RUN 摘要

# 输入信息检查清单

## 问题

| 项目 | 是否提供 | 说明 |
|---|---|---|
| 问题类型与问题族 | | 不默认等同于 HFSP |
| 决策对象 | | Job、Operation、Vehicle、Order 等 |
| 资源 | | Machine、Stage、Worker、Capacity 等 |
| 参数与数据格式 | | 加工时间、路线、成本、交期等 |
| 顺序、冲突和容量约束 | | |
| 目标函数 | | |
| 候选解表示 | | 排列、指派、路径、时间变量等 |
| CPLEX MIP 需求 | | 变量、约束、目标、时限 |
| 对比算法 | | 依据文献选择，不固定为五种算法 |

## 复现

| 项目 | 是否提供 | 规则 |
|---|---|---|
| instance seeds | | 每个生成算例显式记录 |
| solve seeds | | N rounds 对应 N 个固定且不重复的 seeds |
| rounds | | 必须等于 solve seed 数量 |
| 时间预算 | | 同类算法公平一致 |
| Bash 环境 | | Linux、WSL 或 Git Bash |
| CPLEX Python API/license | | 无法 import cplex 或 license 缺少时 MIP 标 NOT_RUN |

## 缺失信息输出

若信息不足，列出缺失项与默认假设，并指出哪些模块需要适配：problem model、loader、representation、evaluator、checker、algorithms、CPLEX、Bash、tests。

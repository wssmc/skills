---
name: domain-adaptation
description: 当论文 baseline 已通过验证，且用户希望把算法迁移到另一个已具备实例读取、解码、评价与可行性检查的调度环境时使用。此阶段只做适配，不再声称“忠实复现”；必须把继承组件、必要适配与新增改动分开记录。
---

# 目标问题适配

你的任务是在**不污染 verified baseline** 的前提下，把已验证算法接入目标问题环境。

此阶段产物不能再称为 faithful reproduction，只能称为 adapted algorithm 或 derived method。

## 前置条件

必须已经存在：

- `verification_report.md`，且结论为 `verified baseline`。
- baseline 代码目录。
- 目标环境 contract，至少说明已有：reader / decoder / objective / feasibility checker。

如果没有 verified baseline，禁止适配。

## 适配边界

必须把构件分为三类：

- `Inherited`：直接沿用 baseline。
- `Adapted`：为目标问题做必要修改。
- `New`：超出原论文的新模块或新机制。

这三类必须写入 `inherited_vs_adapted_vs_new.md`。

## Gate A：目标环境契约

先生成 `adaptation_input_contract.md`，确认：

- 已有实例读取器。
- 已有 decoder。
- 已有 objective evaluator。
- 已有 feasibility checker。
- 目标问题额外约束。
- 目标问题解表示。
- 目标环境期望的算法接口。

## Gate B：算子映射

对以下组件建立映射，写入 `operator_mapping.md`：

- representation
- initialization
- destroy / repair
- neighborhood
- local search
- acceptance
- adaptive control
- stopping condition

如果 baseline 算子会破坏目标问题可行性，必须选择：

- feasibility-preserving operator
- repair after move
- reject infeasible move
- penalty function
- decoder-guaranteed feasibility

并说明理由。

## Gate C：适配方案

在 `adapter_plan.md` 中逐项说明：

- 哪些文件复用。
- 哪些文件替换。
- 哪些文件新增。
- 哪些接口需要桥接。
- 哪些变化改变了算法本质。
- 哪些变化构成你自己的方法创新。

## Gate D：独立实现

在独立目录实现，不覆盖 baseline：

```text
adapted/
├── adapter.py
├── adapted_algorithm.py
├── operator_mapping.md
├── adaptation_change_log.md
├── adaptation_risk_report.md
└── inherited_vs_adapted_vs_new.md
```

## Gate E：适配测试

至少通过：

- 接口兼容测试。
- 目标问题可行性测试。
- 目标值独立复算。
- 固定 seed 稳定性测试。
- baseline-compatible 子域退化检查，如果可构造。

## 改动记录规则

每一处改动都必须写入 `adaptation_change_log.md`：

- baseline component
- adapted component
- change type: inherited / necessary adaptation / new improvement
- reason
- whether it alters algorithm essence
- risk
- test coverage

## 禁止行为

禁止：

- 在 baseline 目录上直接覆盖修改。
- 把 adaptation 结果说成 faithful reproduction。
- 不写 `adaptation_change_log.md`。
- 改了表示 / 解码 / 约束后仍声称“算法未改”。
- 跳过目标问题可行性测试。
- 把未验证的新组件混入 inherited 组件。

## 完成标准

只有在以下条件满足后，适配才算完成：

- `adaptation_input_contract.md` 完整。
- `operator_mapping.md` 完整。
- `adapter_plan.md` 完整。
- `adaptation_change_log.md` 完整。
- `adaptation_risk_report.md` 完整。
- 适配测试通过。
- `inherited_vs_adapted_vs_new.md` 清楚区分三类改动。

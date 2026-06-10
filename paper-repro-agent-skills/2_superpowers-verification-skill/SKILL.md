---
name: superpowers-verification
description: 当论文 baseline 代码已经生成，且用户要求用测试与审查核验“代码是否正确、是否可行、是否与原文一致”时使用。优先采用 Superpowers 的 TDD 与双阶段 review；若 Superpowers 不可用，则按同样纪律模拟执行。此阶段不负责目标问题迁移。
---

# 论文复现核验

你的任务是证明 baseline 代码是否真的等价于论文，而不是仅仅“能运行”。

此阶段只做 verification，不做新的算法改造，不做目标问题适配。

## 前置条件

必须已经存在：

- `src/` 代码目录
- `parameter_registry.yaml`
- `experiment_protocol.yaml`
- `evidence_implementation_verification_matrix.md`
- `reproduction_report.md`

如果这些不存在，禁止进入验证。

## 验证分层

必须按顺序执行：

1. Unit tests
2. Feasibility tests
3. Paper consistency tests
4. Regression tests

任何一层的关键失败都必须阻塞“验证通过”。

## Superpowers / TDD 规则

如果宿主环境提供 Superpowers：

- 优先使用 TDD：先写失败测试，再写最小修复。
- 对每个任务执行两阶段 review：
  1. spec compliance review
  2. code quality review

如果没有 Superpowers，则在当前流程中严格模拟同样纪律。

## TDD 铁律

没有先失败的测试，就不允许写生产代码。

如果已经写了实现但没有对应 failing test：

1. 撤销或隔离该修改。
2. 先补 failing test。
3. 再实现最小修复。
4. 再重构。

## 必须覆盖的测试

### Unit Tests

- data reader / data generator
- problem object
- solution representation
- decoder return structure
- objective function
- constraints checker
- operators
- acceptance rule
- experiment config loader

### Feasibility Tests

- 同一机器不重叠。
- 工序前序满足。
- 缺失工序正确跳过。
- 机器资格满足。
- batch / lot / family 约束满足，如果适用。
- 目标函数可独立复算。
- schedule 不含负时间、非法机器、重复操作或缺失操作。

### Paper Consistency Tests

- 初始化是否符合论文。
- 算子集合是否完整。
- 新接受准则是否符合原文。
- 参数是否来自实验部分。
- 停止条件是否按实验协议。
- 消融开关是否支持论文中的 ablation。
- 主循环顺序是否匹配 Step 0 伪代码。
- 随机性是否统一由 seed / rng 管理。

### Regression Tests

- 小实例已知结果。
- 固定 seed 可复现。
- 官方数据 / benchmark 结果落在合理区间。
- 论文报告表格值或趋势可复核。

对于随机智能算法，不要求未给 seed 的大规模结果逐点一致，但必须报告可比较性限制。

## 产物

必须生成：

- `verification_plan.md`
- `tests/`
- `failing_cases.yaml`
- `verification_report.md`

## 禁止行为

禁止：

- 弱化断言来让测试通过。
- 只跑 unit tests 不跑 paper consistency tests。
- 在 consistency 失败时宣称 faithful reproduction completed。
- 把验证阶段变成算法重写阶段。
- 删除失败用例而不记录原因。
- 在验证报告中掩盖未通过项。

## 完成标准

只有当以下条件全部满足时，才允许 handoff 给 `domain-adaptation`：

- unit tests passed
- feasibility tests passed
- paper consistency tests passed
- regression tests 无关键阻塞
- `verification_report.md` 结论为 `verified baseline`

如果失败，必须输出 blocked 状态和失败原因，不得声称完成。

# 问题、模型、示例与复杂性

## 3.1 问题描述与示例说明

**Guide：**系统对象 -> 运行过程 -> 决策内容 -> 关键条件 -> 基本假设 -> 示例数据 -> 示例方案

说明对象、资源、阶段、决策时点、目标、可行性条件和研究边界。问题不够直观时增加小规模 illustrative instance。

### 示例数据表

设置x张表，x由相互独立的输入数据类别决定。任务/对象数据和资源/日历/兼容性数据分离时，默认至少两张表。

通用标题：

- `Table X. [Primary input data] of the illustrative instance.`
- `Table X. [Resource or constraint data] of the illustrative instance.`
- `Table X. [Additional data category] of the illustrative instance.`

来源示例：

- `Table X. Processing times and due windows of the illustrative instance.`
- `Table X. Machine unavailability periods of the illustrative instance.`

### 示例图

调度问题使用甘特图，其他问题使用路径图、网络图、布局图或时间线图。

推荐标题：

`Figure X. Gantt chart of an illustrative solution for the illustrative instance.`

同一篇论文统一使用`illustrative instance`，不要混用demo/example/sample case。图后必须把各数据表与可行方案联系起来，并指出最能体现研究特征或冲突的位置。

## 数学模型

**Guide：**符号 -> 参数构造 -> 目标函数 -> 完整模型 -> 实际解释

在使用前定义集合、索引、参数、随机量、决策变量、辅助变量和定义域；说明数据到参数/场景的构造；给出完整目标与约束；解释非显然的模型结构。

### 符号表

MIP默认标题：`Table X. Notation for the MIP model.`

其他模型可使用：`Notation for the mathematical model / nonlinear programming model / stochastic programming model / proposed formulation.`

按集合与索引、参数、随机量、决策变量、辅助变量分组。

## NP-hard与理论性质

### 位置分支

- 证明只依赖问题定义时，放在问题描述之后、模型之前。
- 证明依赖模型符号或期刊习惯时，放在模型之后。

使用真实标题，如`Problem complexity`、`Computational complexity`或`NP-hardness`。

### 合法证明方式

1. 已知NP-hard问题是本文问题的特殊情形；
2. 从已知NP-hard问题到本文问题的多项式归约；
3. 可靠文献已证明完全匹配的特殊情形为NP-hard。

建议命题：`Proposition 1. The considered problem is NP-hard.`

不能因为模型规模大或求解器慢就声称NP-hard。声称NP-complete时还必须定义决策版本并证明属于NP。最后说明复杂性结论如何支撑求解方法选择。

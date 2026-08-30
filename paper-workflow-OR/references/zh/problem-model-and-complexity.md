# 问题、模型、示例与复杂性

## 问题描述与示例说明

**Guide：**系统对象 -> 运行过程 -> 决策内容 -> 关键条件 -> 基本假设 -> 示例数据 -> 示例方案

说明对象、资源、阶段、决策时点、目标、可行性条件和研究边界。只有在示例能实质性说明可行性、时序、特征交互或数据到决策的映射时，才增加小规模 illustrative instance。

### 示例数据表

使用最少但仍可读、可复现该实例的表格数量。任务/对象数据与资源/日历/兼容性数据合并后会混淆单位、键或约束时再拆分，否则合并。不要为了填满示例而虚构数据。

通用标题：

- `Table X. [Primary input data] of the illustrative instance.`
- `Table X. [Resource or constraint data] of the illustrative instance.`
- `Table X. [Additional data category] of the illustrative instance.`

来源示例：

- `Table X. Processing times and due windows of the illustrative instance.`
- `Table X. Machine unavailability periods of the illustrative instance.`

### 示例图

调度问题使用甘特图，其他问题使用路径图、网络图、布局图或时间线图。

可用标题：

`Figure X. Gantt chart of an illustrative solution for the illustrative instance.`

同一篇论文统一术语（通常可用`illustrative instance`），期刊有惯用表达时以期刊为准。图后应把相关数据表与可行方案联系起来，并指出最能体现研究特征或冲突的位置。

## 数学模型

**Guide：**符号 -> 参数构造 -> 目标函数 -> 完整模型 -> 实际解释

在使用前或首次使用处定义集合、索引、参数、随机量、决策变量、辅助变量、单位和定义域；说明数据到参数/场景的构造；给出完整目标与约束；解释每组非显然约束对应的运行规则。可获得实现时，还要核对索引域、单位、目标方向、变量域、big-M/上下界和连接约束的逻辑完整性。

### 符号表（条件）

当符号数量或复用程度使正文定义难以导航时，可使用：`Table X. Notation for the MIP model.`

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
3. 可靠文献已证明某个特殊情形为NP-hard，且其假设与目标确实满足本文的特殊情形论证。

建议命题：`Proposition 1. The considered problem is NP-hard.`

特殊情形论证必须明确固定、删除或转换了哪些特征。不能因为模型规模大或求解器慢就声称NP-hard。声称NP-complete时还必须定义决策版本并证明属于NP。最后说明复杂性结论如何支撑求解方法选择，但不能仅凭NP-hard就断言某个启发式是必要或有效的。

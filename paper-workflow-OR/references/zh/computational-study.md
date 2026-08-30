# 计算实验

从验证问题设计本章，而不是从固定图表清单倒推：

```text
声明或研究问题
-> 数据集/实例角色
-> 对比方法与公平预算
-> 指标与分析单位
-> 统计或分析方法
-> 结果、不确定性、例外与边界
```

## 章节开头

**Guide：**验证目的 -> 数据角色 -> 实现与计算环境 -> 本章证据结构

说明实验验证什么，区分标准基准、生成/修改数据和真实案例数据。报告足以解释和复现实验预算的信息：语言/运行时、硬件、相关时的操作系统或容器、求解器/版本/接口、线程、时间限制、停止容差、随机种子、重复次数，以及预处理/训练是否计时。不要用常见硬件配置补写未知信息。

模板：`All algorithms were implemented in [programming language] and executed on a personal computer equipped with [CPU model and clock speed], [RAM capacity], and [operating system]. ...`

## 5.1 实验设计

### 数据与设置

**Guide：**数据来源 -> 实例结构 -> 场景/因素 -> 基准方法 -> 统一预算 -> 指标

说明数据用途、规模、生成/修改规则、适用时的训练/校准/测试划分、基准选择理由、预算公平性、种子/重复运行，以及指标公式、单位和分母。明确分析单位是运行、实例、场景还是数据集；同一数据若兼作校准和最终测试必须披露。

### 参数校准/DOE（条件）

参数预先固定或继承时删除，并在数据设置中说明固定值及来源。确需校准时，条件允许应把校准实例与最终测试分开，并说明选择标准。

**Guide：**因素 -> 水平 -> 校准实例 -> DOE -> 响应值 -> 主效应 -> 最终设置

使用DOE时可选的表图：

- `Levels of the calibrated [algorithm name] parameters.`
- `Orthogonal parameter combinations and average response values of [algorithm name].`
- `Main effects plot for the mean normalized objective.`
- `Factor-response analysis for the mean normalized objective.`

使用真实设计名称，非正交设计不得写成Orthogonal。说明响应值、聚合方式、是否考虑交互，并解释最终参数为何可能不同于单个实验最优组合。不能用很小的校准集声称普遍稳健。

## 5.2 总体性能与统计比较

### 大规模算法比较

标题：`Algorithm comparison on large-scale instances under [setting].` 或 `Algorithm comparison across different experimental settings.`

按实验设计报告合适的中心趋势、波动/不确定性、时间和问题特定指标。最好结果次数必须定义并列规则和参考值。按规模/场景解释差异，并呈现实质性并列、反转、失败和权衡，而不是只报胜者。

### 统计显著性

随机算法或多实例比较支撑优势声明时，应根据分析单位、配对关系、分布、方法数量和多重比较结构选择检验。保留逐次运行数据，不要把同一实例的多次运行误当作相互独立的问题实例。

标题：

- `Statistical comparison of the proposed and benchmark algorithms.`
- `Friedman rankings and Holm-adjusted pairwise comparisons ...`
- `Pairwise Wilcoxon signed-rank test results ...`

报告假设、分析单位、配对方式、统计量、样本量、适用时的原始/校正p值，以及效应量或置信区间。区分统计显著性和实际显著性；不能看完结果后只挑能显著的检验，也不能在没有报告分析时写“显著”。

### 收敛分析

标题：`Representative convergence behavior under [selected scenario combinations].` 或 `Time-normalized convergence profiles ...`

横轴使用公平的相同墙钟时间或有依据的计算工作量。说明代表性实例的选择规则，不能只挑有利曲线。讨论初始质量、前期改进、后期搜索、停滞、跨运行波动，以及不同规模/场景的一致性或反转。

### 小规模精确/高质量参考比较

可放在大规模比较前、后或合并，取决于论证逻辑和期刊空间。

标题：`Small-scale comparison between [exact model or reference method] and [proposed algorithm].`

报告可行解、最好界、gap定义、最优证明状态、时间和问题特定指标，区分最优、best-known和实验最好；同时核对最小化/最大化问题的界方向和相对gap分母。

## 5.3 方法组成部分分析

按实际组件命名。保持其他设置不变，通过移除/替换/改变一个组件，比较质量、稳定性、最好次数和时间，并解释作用条件、机制和边界。若无法隔离组件作用，应缩小因果表述并说明混杂因素。

标题形式：`Comparison of [component] alternatives.`、`[Metric] improvement of different [component] strategies over [baseline].`

## 5.4 实际案例（条件）

**Guide：**案例背景 -> 数据来源 -> 参数化 -> 现实/规则基准 -> 结果与权衡 -> 实际意义 -> 局限

构造实例不能写成真实案例。说明数据来源、匿名化/聚合方式、现实基准，以及部署效果与离线评估之间的边界。

## 5.5 敏感性与稳健性（条件）

**Guide：**因素 -> 范围 -> 控制实验 -> 结果趋势 -> 原因 -> 模型/管理含义 -> 边界

避免与算法参数校准重复，除非回答不同的稳健性问题。会改变解释的非单调、无明显变化和不利响应也必须报告。

## 完整性检查

每个实验结论都要能定位到具体表/图/结果文件，并说明覆盖的实例和运行总体。逐项核对改进方向、分母、四舍五入、并列规则和缺失/失败运行。不得静默删除失败运行或不利实例组。

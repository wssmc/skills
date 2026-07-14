# 计算实验

## 章节开头

**Guide：**验证目的 -> 数据角色 -> 实现与计算环境 -> 本章证据结构

说明实验验证什么，区分标准基准、生成/修改数据和真实案例数据。适用时报告语言、CPU及主频、RAM、操作系统、求解器/版本/接口、线程、时间限制、最优间隙、随机种子、重复次数和预处理计时政策。

模板：`All algorithms were implemented in [programming language] and executed on a personal computer equipped with [CPU model and clock speed], [RAM capacity], and [operating system]. ...`

## 5.1 实验设计

### 数据与设置

**Guide：**数据来源 -> 实例结构 -> 场景/因素 -> 基准方法 -> 统一预算 -> 指标

说明数据用途、规模、生成/修改规则、基准公平性、种子/重复运行，以及指标公式、单位和分母。

### 参数校准/DOE

无待校准参数时删除，并在数据设置中说明固定值及来源。

**Guide：**因素 -> 水平 -> 校准实例 -> DOE -> 响应值 -> 主效应 -> 最终设置

使用DOE时的默认表图：

- `Levels of the calibrated [algorithm name] parameters.`
- `Orthogonal parameter combinations and average response values of [algorithm name].`
- `Main effects plot for the mean normalized objective.`
- `Factor-response analysis for the mean normalized objective.`

非正交设计应准确替换Orthogonal。解释最终参数为何可能不同于单个实验最优组合。

## 5.2 总体性能与统计比较

### 大规模算法比较

标题：`Algorithm comparison on large-scale instances under [setting].` 或 `Algorithm comparison across different experimental settings.`

报告均值/中位数、波动、最好结果次数、时间和问题特定指标，并按规模/场景解释差异。

### 统计显著性

随机算法或多实例比较支撑优势声明时，使用合适的配对/非参数检验和效应信息。

标题：

- `Statistical comparison of the proposed and benchmark algorithms.`
- `Friedman rankings and Holm-adjusted pairwise comparisons ...`
- `Pairwise Wilcoxon signed-rank test results ...`

报告设计、统计量、原始/校正p值、平均排名、效应量或置信区间。没有检验不得写“显著”。

### 收敛分析

标题：`Representative convergence behavior under [selected scenario combinations].` 或 `Time-normalized convergence profiles ...`

横轴使用公平的相同时间预算或有依据的迭代数，讨论初始质量、前期改进、后期搜索、停滞和不同场景的一致性。

### 小规模精确/高质量参考比较

可放在大规模比较前、后或合并，取决于论证逻辑和期刊空间。

标题：`Small-scale comparison between [exact model or reference method] and [proposed algorithm].`

报告可行解、最好界、gap、最优证明状态、时间和问题特定指标，区分最优、best-known和实验最好。

## 5.3 方法组成部分分析

按实际组件命名。保持其他设置不变，通过移除/替换/改变一个组件，比较质量、稳定性、最好次数和时间，并解释作用条件、机制和边界。

标题形式：`Comparison of [component] alternatives.`、`[Metric] improvement of different [component] strategies over [baseline].`

## 5.4 实际案例（条件）

**Guide：**案例背景 -> 数据来源 -> 参数化 -> 现实/规则基准 -> 结果与权衡 -> 实际意义 -> 局限

构造实例不能写成真实案例。

## 5.5 敏感性与稳健性（条件）

**Guide：**因素 -> 范围 -> 控制实验 -> 结果趋势 -> 原因 -> 模型/管理含义 -> 边界

避免与算法参数校准重复，除非回答不同的稳健性问题。

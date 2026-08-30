# 图表与标题命名

先按证据功能选择图表，再遵循目标期刊的放置与标题风格。sentence case名词短语只是常用默认，不是统一强制格式。

## 证据优先的选择

| 证据需求 | 候选图表 | 可省略或合并的情形 |
|---|---|---|
| 结构化文献定位 | 文献矩阵 | 正文已清楚比较，或编码稀疏/未经核实 |
| 问题/可行性说明 | 示例数据表与调度/网络/路径/时间线图 | 输入到可行方案的映射已直观 |
| 符号较密 | 符号表 | 符号很少且可就地定义 |
| 方法接口/信息流 | 框架图或机制图 | 简洁正文/伪代码更清楚 |
| 参数选择 | 校准设计/结果表或效应图 | 未做经验校准或图表不提供决策证据 |
| 总体性能 | 比较表/图 | 更紧凑的图表已能回答问题且不隐藏波动 |
| 统计不确定性 | 区间/分布图或检验表 | 仅作描述性声明，或设计不支持推断 |
| 搜索行为 | 收敛/性能剖面图 | 计算工作量不可比，或实例选择会误导 |
| 组件作用 | 受控消融/析因比较 | 组件无法隔离；此时应缩小因果表述 |
| 实践稳定性 | 案例、敏感性或稳健性图表 | 没有相应实践或稳健性声明 |

每个主图表只需清楚回答一个已声明问题。相同结果的多个视图应优先合并，并保留足够的源数据或标识以核验每个绘图值和表格值。

## 标题语法

表格常用：`Comparison of ...`、`Levels of ...`、`Notation for ...`、`... of the illustrative instance`、`... under [setting]`、`Statistical comparison of ...`。

图形常用：`Overall framework of ...`、`Illustration of ...`、`Main effects plot for ...`、`Representative convergence behavior under ...`、`[Metric] improvement of ... over ...`、`Sensitivity of ... to ...`。

避免只有`Experimental results`、`Algorithm comparison`、`Ablation results`或`Example`。

## 画布、标题和正文引用的分工

- **图内画布：**通常只保留坐标轴/单位、图例、分面标签、参考线/带和必要注释。除非期刊或其他使用场景要求，省略与caption重复的图内标题。
- **Caption：**标明对象/图表类型、比较或机制、数据/实例/场景范围，以及理解图表所必需的非标准编码。只有坐标轴、图例或注释无法说明时才补充指标方向或不确定性含义。
- **正文引用：**先说明图表回答的问题，再解释主要观察、重要例外、不确定性和有边界的含义。
- **表注：**缩写、分母、显著性符号、并列/最优值格式和缺失值编码放在表下注释，而不是塞进标题。

不要在图内标题、caption和正文首句中重复同一句话。坐标轴、图例和邻近正文已提供细节时，caption可以保持简洁。

以下只是可调整的示例：

- `Comparison of representative related studies and this study.`
- `Notation for the MIP model.`
- `Overall framework of the proposed [method name].`
- `Algorithm comparison on [instance group] under equal [time/evaluation] budgets.`
- `Time-normalized convergence profiles on [selection rule or instance group].`
- `Effect of [component] on [metric] across [scope].`

## 标题审计

检查比较对象、指标、实验条件、缩写定义、声明边界、正文引用解释和数字一致性；同时检查面板/序列选择是否掩盖反例或失败运行，以及颜色、线型、符号和排序在印刷与无障碍呈现中是否可区分。

## 图表描述顺序

```text
提出图表回答的问题
-> 说明数据和指标
-> 报告主要结果
-> 比较关键方法/场景
-> 解释机制或权衡
-> 给出有边界的结论
```

不要逐单元格复述，也不要仅凭图形推断未验证的机制。

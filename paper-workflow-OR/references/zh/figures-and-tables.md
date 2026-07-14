# 图表与标题命名

本版本重点处理图表必要性、证据作用、放置位置和英文标题命名。标题通常使用sentence case名词短语，并按期刊风格加句号。

## 默认图表集合

- 文献综述：文献矩阵。
- 问题与模型：x张示例输入表、1张甘特/网络/路径图、1张符号表。
- 求解方法：1张算法总体框架图，必要时增加机制图。
- 参数校准：参数水平表、DOE组合与响应表、主效应图、因素响应分析表。
- 总体性能：算法比较表、统计表、收敛曲线、适用时的小规模精确比较表。
- 组件分析：每个核心贡献组件至少一个受控比较表或图（可行时）。

## 标题语法

表格常用：`Comparison of ...`、`Levels of ...`、`Notation for ...`、`... of the illustrative instance`、`... under [setting]`、`Statistical comparison of ...`。

图形常用：`Overall framework of ...`、`Illustration of ...`、`Main effects plot for ...`、`Representative convergence behavior under ...`、`[Metric] improvement of ... over ...`、`Sensitivity of ... to ...`。

避免只有`Experimental results`、`Algorithm comparison`、`Ablation results`或`Example`。

## 从源.tex提取的标题库

1. `Comparison of representative related studies and this study.`
2. `Processing times and due windows of the illustrative instance.`
3. `Machine unavailability periods of the illustrative instance.`
4. `Gantt chart for permutation sequence [solution sequence] in the example.`
5. `Notation for the MIP model.`
6. `Overall framework of the proposed two-phase solution approach.`
7. `Illustration of the two-phase schedule construction and refinement mechanisms.`
8. `Levels of the calibrated [algorithm name] parameters.`
9. `Orthogonal parameter combinations and average response values of [algorithm name].`
10. `Main effects plot for the mean normalized objective.`
11. `Factor-response analysis for the mean normalized objective.`
12. `Algorithm comparison on large-scale instances under [setting].`
13. `Representative convergence behavior under [selected scenario combinations].`
14. `Small-scale comparison between [exact model] and [proposed algorithm].`
15. `Comparison of initialization rules.`
16. `Comparison of [component] strategies.`
17. `[Performance metric] improvement of different [component] strategies over [ablation baseline].`
18. `[Component] comparison under all [scenario families].`

## 标题审计

检查比较对象、指标、实验条件、缩写定义、声明边界、正文引用解释和数字一致性。

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

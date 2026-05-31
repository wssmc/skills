# literature-matrix-review-skill

## 1. Skill 定位

当用户给出一个调度优化、车间调度、排产、资源分配或组合优化问题，并希望检索相似文献、理解已有研究、形成综述表格、寻找创新缺口时，使用本 Skill。

本 Skill 专注于：

- 从问题描述抽取研究问题画像；
- 生成可执行检索式；
- 检索并筛选相似论文；
- 阅读论文并抽取问题特征与方法特征；
- 输出两张核心表格：问题特征对比表、方法流程矩阵表；
- 总结研究缺口、贡献点写法和可参考 baseline；
- 为后续 `mip-hfsp-project-generator-skill` 提供高质量输入。

## 2. 推荐前置 Skill

优先使用 `problem-decomposition-skill` 对用户的原始文字进行问题拆解，得到高质量问题描述后，再执行本 Skill。

推荐链路：

```text
用户原始想法
→ problem-decomposition-skill
→ refined_problem_description.md + problem_fingerprint.json
→ literature-matrix-review-skill
→ 文献表格 + 方法矩阵 + 研究缺口
→ mip-hfsp-project-generator-skill
→ MIP / 算法 / 实验 / 可视化项目
```

如果用户没有经过前置 Skill，也可以直接执行本 Skill，但必须先进行输入完整度检查。

## 3. 触发场景

用户提出以下需求时使用本 Skill：

- 检索与某个调度问题相似的文章；
- 对 HFSP / HFFS / FJSP / JSP / PFSP / RCPSP / distributed scheduling 等问题做文献综述；
- 输出类似论文中 “Study-Shop-Objective-Constraints-Method” 的对比表；
- 输出基于算法流程的矩阵表；
- 梳理某类方法，如 IG、ILS、GA、SA、ACO、GWO、memetic algorithm、VNS 等；
- 分析已有研究缺口；
- 提炼本文创新点。

## 4. 输入要求

用户最好提供：

1. 问题类型：HFSP、HFFS、FJSP、JSP、PFSP、distributed HFSP 等；
2. 目标函数：makespan、total tardiness、E/T、TWET、weighted tardiness、total cost 等；
3. 约束特征：due windows、priority jobs、shared windows、MUPs、setup、blocking、transport、worker 等；
4. 计划方法：two-phase IG、GA、SA、ACO、GWO、memetic algorithm、VNS、ILS 等；
5. 检索范围：年份、数据库、期刊范围；
6. 种子论文：用户已知的核心论文；
7. 输出表格列：是否按某张图中的列复刻。

如果信息不足，先输出“文献检索输入补充清单”。

## 5. 输入完整度判断

将输入分为三类：

### A. 足够执行

同时包含：问题类型、目标函数、至少一个约束特征、至少一个方法方向。

直接执行检索规划。

### B. 部分足够

包含问题类型和目标函数，但约束或方法不完整。

可以先生成默认检索式，同时列出需要补充的问题。

### C. 不足

只有泛泛描述，例如“帮我找调度论文”。

必须先提问澄清，不直接生成文献表。

## 6. 问题画像抽取

将输入转化为 `problem_fingerprint`：

```json
{
  "problem_type": "HFSP",
  "shop_keywords": ["hybrid flow shop", "hybrid flowshop", "flexible flow shop"],
  "objective_keywords": ["total weighted earliness and tardiness", "TWET"],
  "constraint_keywords": ["due windows", "priority jobs", "shared windows", "machine unavailability periods"],
  "method_keywords": ["two-phase iterated greedy", "iterated greedy", "IG"],
  "seed_papers": [],
  "time_range": "2000-2026"
}
```

对缩写要做显式定义。例如 MUPs 默认解释为 `Machine Unavailability Periods`，但如果用户定义不同，以用户定义为准。

## 7. 检索式生成规则

必须生成多组检索式，至少包括：

### 7.1 强检索式

问题类型 + 目标函数 + 关键约束。

```text
("hybrid flow shop" OR "hybrid flowshop" OR "flexible flow shop")
AND ("total weighted earliness and tardiness" OR "TWET" OR "earliness tardiness")
AND ("due windows" OR "machine unavailability" OR "priority jobs" OR "shared windows")
```

### 7.2 中等检索式

问题类型 + 目标函数。

```text
("hybrid flow shop" OR "hybrid flowshop")
AND ("earliness" AND "tardiness")
```

### 7.3 方法检索式

问题类型 + 方法。

```text
("hybrid flow shop" OR "hybrid flowshop")
AND ("iterated greedy" OR "two-phase iterated greedy" OR "ILS" OR "VNS")
```

### 7.4 约束检索式

问题类型 + 特殊约束。

```text
("hybrid flow shop")
AND ("due window" OR "shared due window" OR "machine unavailability" OR "priority jobs")
```

### 7.5 种子论文扩展

如果用户提供种子论文，必须围绕种子论文做：

- backward snowballing：查看参考文献；
- forward snowballing：查看引用该论文的后续文献；
- author search：检索同作者后续工作。

## 8. 文献筛选规则

将文献分为三类：

### A 类：高度相关

满足：

- 问题类型相同或近似；
- 目标函数相同或高度接近；
- 至少包含一个关键约束；
- 方法或实验设计对本文有参考价值。

### B 类：中等相关

满足：

- 问题类型相同或近似；
- 目标函数或约束不完全相同；
- 但对模型、约束处理、实验基准有参考价值。

### C 类：方法参考

满足：

- 问题类型可以不同；
- 但方法框架、编码、解码、邻域、局部搜索、接受准则等有参考价值。

## 9. 论文阅读卡片

每篇入选文献必须生成阅读卡片：

```text
Paper ID:
Citation:
Year:
Journal / Conference:
DOI:
Problem type:
Objective:
Constraints:
Method:
Encoding:
Decoding:
Initialization:
Neighborhood:
Local search:
Acceptance criterion:
Repair mechanism:
Experiment instances:
Compared baselines:
Main results:
Useful idea:
Limitation:
Similarity to this study:
Relevance score:
Evidence notes:
```

不确定的信息填 `Unclear` 或 `Not reported`，不要猜测。

## 10. 输出表格一：基于问题的表格

用于回答：已有研究解决了什么问题，考虑了哪些约束，目标函数是什么。

默认列：

```text
Study | Shop | Objective | Due windows | Priority jobs | Shared windows | MUPs | Setup | Blocking | Transport | Worker | Method | Similarity | Key difference
```

如果用户的研究问题没有某些约束，可以删除对应列；如果用户新增约束，如能源、碳排、维护、人力、运输、批处理，则必须增加对应列。

表格中的 `Yes/No/Unclear/Not reported` 必须有依据。

## 11. 输出表格二：基于方法的矩阵表

用于回答：已有研究怎么做算法，本文方法可以在哪些环节创新。

默认形式：

```text
Method component | Paper A | Paper B | Paper C | This study
```

默认行：

```text
Main framework
Encoding
Decoding
Initialization
Destruction / reconstruction
Neighborhood
Local search
Repair mechanism
Constraint handling
Acceptance rule
Stopping criterion
Objective evaluation
Benchmark instances
Compared baselines
Strength
Weakness
Reusable idea
```

如果用户研究的是 two-phase IG，则必须突出：

- phase 1 / phase 2 各自做什么；
- destroy-repair 机制；
- insertion / swap / block move 邻域；
- acceptance criterion；
- due-window-aware 或 priority-aware 规则；
- MUP / shared window / resource conflict 的修复方式。

## 12. 创新缺口总结

输出 `novelty_gap_summary.md`，至少包括：

1. 目前已有研究覆盖了哪些问题特征；
2. 哪些特征组合尚少见；
3. 哪些方法已经成熟；
4. 哪些算法环节仍有改进空间；
5. 本文可以写成的 3–5 个贡献点；
6. 推荐 baseline 方法；
7. 推荐实验设置。

## 13. 输出文件

默认输出：

```text
outputs/
├── problem_fingerprint.json
├── search_queries.txt
├── screening_records.csv
├── paper_reading_cards.md
├── problem_feature_table.md
├── problem_feature_table.csv
├── method_matrix_table.md
├── method_matrix_table.csv
├── novelty_gap_summary.md
├── literature_review_draft.md
└── references.bib
```

## 14. 质量控制

必须遵守：

- 不编造文献；
- 不编造作者、年份、期刊、DOI；
- 没有依据的内容不填 Yes；
- 不能只看标题就填完整表格；
- 表格必须能追溯到阅读卡片；
- 每篇核心文献至少要有问题特征和方法特征；
- 输出结论必须区分“文献明确说明”和“基于阅读的合理判断”。

## 15. 与其他 Skill 的衔接

### 接收自 problem-decomposition-skill

- `refined_problem_description.md`
- `problem_fingerprint.json`
- `assumption_log.md`
- `open_questions.md`

### 输出给 mip-hfsp-project-generator-skill

- `problem_fingerprint.json`
- `problem_feature_table.md`
- `method_matrix_table.md`
- `novelty_gap_summary.md`
- `recommended_baselines.md`
- `method_design_hints.md`

如果这些文件存在，MIP / HFSP 项目生成 Skill 应优先读取这些文件，而不是重新猜测问题设定。

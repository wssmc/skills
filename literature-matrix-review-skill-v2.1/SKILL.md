# literature-matrix-review-skill v2.1

## 1. Skill 定位

当用户给出一个调度优化、车间调度、排产、资源分配、批处理、排料、装配、运输、维护或组合优化问题，并希望检索相似文献、理解已有研究、形成综述表格、寻找创新缺口、撰写论文引言与相关工作时，使用本 Skill。

本 Skill 的目标不只是生成“文献矩阵”，而是完成从研究问题到论文写作证据链的完整流程：

```text
问题描述
→ 研究问题画像
→ 高质量文献检索
→ 近年核心论文种子
→ backward / forward snowballing
→ 文献筛选与阅读卡片
→ 问题特征对比表 full version
→ 问题特征对比表 paper version
→ 方法流程矩阵表
→ baseline 候选文献表
→ gap argument map
→ introduction draft
→ related work draft
→ 第 3 章问题描述框架
→ 第 5 章实验设计框架
→ contribution paragraph
→ citation strategy
→ method / model / experiment checklists
```

本 Skill 尤其适用于 HFSP / HFFS / FJSP / JSP / PFSP / RCPSP / distributed scheduling / batching / nesting / sheet metal / stamping / assembly / two-stage scheduling 等方向。

---

## 2. 核心原则

### 2.1 双层产物原则

输出必须分为两层：

1. **分析层**：用于研究判断、证据追踪和后续方法设计，包括 problem fingerprint、检索式、筛选记录、阅读卡片、两张矩阵表、baseline 和 method hints。
2. **写作层**：用于论文撰写，包括 introduction draft、related work draft、gap paragraph、contribution paragraph、citation strategy、chapter framework 和 section structure。

不能只输出中间分析产物。若用户要求“文献矩阵综述”，默认也要给出可写入论文的引言和相关工作草稿，除非用户明确只要表格。

### 2.2 证据链原则

任何 `Yes/No/Unclear/Not reported`、gap 判断、相似度判断、算法借鉴点，都必须能够追溯到：

```text
source paper → paper reading card → matrix cell → gap / writing draft
```

不能凭标题或摘要臆测方法细节；不确定的信息必须写 `Unclear` 或 `Not reported`。

### 2.3 生产机制优先原则

gap 不能写成机械模板：

```text
已有研究没有考虑 A+B+C，所以本文考虑 A+B+C。
```

必须先从实际生产机制、业务对象转换、调度后果或建模障碍出发，再说明现有文献的覆盖边界，最后自然引出本文问题。

### 2.4 论文可用性原则

本 Skill 输出的文件分为三类：

| 类别 | 文件示例 | 是否可直接进入论文 |
|---|---|---|
| 研究笔记 | full matrix、screening records、reading cards | 不直接进正文，可放附录或内部使用 |
| 论文素材 | gap map、citation strategy、baseline candidates | 需要转写或筛选后使用 |
| 论文草稿 | introduction draft、related work draft、problem description outline、5.1 framework | 可作为正文初稿，但必须根据目标期刊和最终实验结果修订 |

---

## 3. 推荐前置与后续 Skill

### 3.1 推荐前置

优先使用 `problem-decomposition-skill` 对用户原始文字进行问题拆解，得到：

```text
refined_problem_description.md
problem_fingerprint.json
assumption_log.md
open_questions.md
```

如果用户没有经过前置 Skill，也可以直接执行本 Skill，但必须先进行输入完整度检查。

### 3.2 推荐后续

本 Skill 输出可交给：

```text
mip-hfsp-project-generator-skill
algorithm-design-skill
experiment-design-skill
paper-writing-skill
journal-adapt-writing-skill
```

---

## 4. 触发场景

用户提出以下需求时使用本 Skill：

- 检索与某个调度问题相似的文章；
- 做 HFSP / HFFS / FJSP / JSP / PFSP / RCPSP / distributed scheduling 等问题的文献综述；
- 输出类似论文中 `Study-Shop-Objective-Constraints-Method` 的对比表；
- 输出基于算法流程的矩阵表；
- 梳理某类方法，如 IG、ILS、GA、SA、ACO、GWO、memetic algorithm、VNS、TLBO、ABC、RL、ML-enhanced heuristic；
- 分析已有研究缺口；
- 提炼本文创新点；
- 撰写引言、相关工作、gap paragraph、contribution paragraph；
- 为 MIP 建模、算法设计和实验设计找 baseline。

---

## 5. 输入要求

用户最好提供：

1. 问题类型：HFSP、HFFS、FJSP、JSP、PFSP、distributed HFSP 等；
2. 目标函数：makespan、total tardiness、TWT、TWET、total cost、energy、carbon 等；
3. 约束特征：missing operations、skipped stages、precedence constraints、BOM、batch、lot、setup、blocking、transport、worker、maintenance、machine eligibility 等；
4. 业务背景：sheet metal、stamping、nesting、cutting、assembly、steelmaking、semiconductor 等；
5. 方法方向：MIP、CP、GA、SA、IG、VNS、memetic、matheuristic、ML-enhanced heuristic 等；
6. 检索范围：年份、数据库、期刊范围、是否要求近三年核心论文；
7. 种子论文：用户已知的核心论文；
8. 目标期刊或写作风格：若需要写作层输出；
9. 输出表格列：是否按某篇论文中的表格复刻；
10. 是否需要标注潜在 baseline 文献与复现难度。

---

## 6. 输入完整度判断

### A. 足够执行

同时包含：问题类型、目标函数、至少一个关键约束、至少一个业务场景或方法方向。

直接执行完整工作流。

### B. 部分足够

包含问题类型和目标函数，但约束、业务背景或方法不完整。

可以先生成默认检索式和初始文献矩阵，同时列出需要补充的问题。

### C. 不足

只有泛泛描述，例如“帮我找调度论文”。

必须先提问澄清，不直接生成文献表。

---

## 7. problem_fingerprint 抽取

将输入转化为 `problem_fingerprint.json`。默认字段：

```json
{
  "problem_type": "HFSP / HFFS / FJSP / ...",
  "domain": "stamping / sheet metal / ...",
  "shop_keywords": [],
  "objective_keywords": [],
  "constraint_keywords": [],
  "business_objects": [],
  "decision_variables": [],
  "method_keywords": [],
  "seed_papers": [],
  "time_range": "2000-2026",
  "target_gap_hypothesis": "",
  "must_not_assume": []
}
```

对缩写必须显式定义。例如：

- MUPs: Machine Unavailability Periods；
- HFSMO: Hybrid Flow Shop with Missing Operations；
- NEST: nesting sheet / nesting order / cutting-pattern order，具体含义以用户定义为准；
- LOT: downstream lot / batch / post-nesting processing batch，具体含义以用户定义为准。

若用户自定义缩写与文献常用缩写不同，以用户定义为准，并在 `terminology_mapping.md` 中说明。

---

## 8. 检索式生成规则

必须生成多组检索式，至少包括以下类别。

### 8.1 强检索式

问题类型 + 目标函数 + 关键约束。

```text
("hybrid flow shop" OR "hybrid flowshop" OR "flexible flow shop")
AND ("missing operations" OR "skipped stages" OR "operation skipping")
AND ("makespan" OR "Cmax" OR "maximum completion time")
```

### 8.2 中等检索式

问题类型 + 目标函数，或问题类型 + 单个关键约束。

```text
("hybrid flow shop" OR "hybrid flowshop")
AND ("precedence constraints" OR "time lags" OR "bill of materials")
```

### 8.3 方法检索式

问题类型 + 方法。

```text
("hybrid flow shop" OR "hybrid flowshop")
AND ("iterated greedy" OR "simulated annealing" OR "genetic algorithm" OR "memetic algorithm" OR "VNS")
```

### 8.4 业务场景检索式

业务场景 + scheduling + 对象转换或特殊机制。

```text
("sheet metal" OR "stamping" OR "part cutting" OR "nesting")
AND ("scheduling" OR "production scheduling")
AND ("batch" OR "lot" OR "bill of materials" OR "release time")
```

### 8.5 近义词扩展

对用户术语要扩展近义词，不得只使用用户原词。例如：

- 缺失操作：missing operations, skipped stages, stage skipping, operation skipping, optional operations；
- 排料图：nesting, cutting pattern, sheet layout, metal sheet, part-cutting, packing；
- 合批 / 批次：batch, lot, serial batch, batching, order consolidation；
- 前序关系：precedence constraints, DAG, release constraint, assembly precedence, BOM relation；
- 冲压：stamping, punching, press, sheet metal processing。

---

## 9. 文献质量控制规则

### 9.1 不能只看相关性

文献筛选必须同时考虑：

1. 问题相关性；
2. 期刊 / 会议质量；
3. 时间新近性；
4. 雪球检索中心性；
5. 方法可借鉴性；
6. 是否提供独特生产机制或业务对象转换；
7. 是否可作为后续 baseline 复现或对比。

### 9.2 默认文献比例

默认保留文献比例：

| 文献类型 | 建议比例 | 用途 |
|---|---:|---|
| Core venue papers | 60%–70% | 支撑研究主线、模型和算法可信度 |
| Domain-specific papers | 20%–30% | 支撑工业场景、业务对象和生产机制 |
| Peripheral but necessary papers | ≤10%–20% | 早期源头、种子论文、独特机制或高相关会议文献 |

低质量或外围文献超过 20% 时，必须在 `screening_records.csv` 中说明原因。

### 9.3 候选高质量期刊池

调度优化、运筹优化、生产制造与智能优化方向优先检索：

**Operations research and scheduling**

- European Journal of Operational Research
- Computers & Operations Research
- Omega
- Annals of Operations Research
- Journal of Scheduling
- INFORMS Journal on Computing

**Production and manufacturing**

- International Journal of Production Research
- International Journal of Production Economics
- Computers & Industrial Engineering
- Journal of Manufacturing Systems
- Flexible Services and Manufacturing Journal
- Robotics and Computer-Integrated Manufacturing
- Journal of Intelligent Manufacturing

**Intelligent optimization and computational intelligence**

- Expert Systems with Applications
- Applied Soft Computing
- Swarm and Evolutionary Computation
- Engineering Applications of Artificial Intelligence
- Knowledge-Based Systems

**Domain-specific manufacturing**

- CIRP Annals / Procedia CIRP
- Advanced Engineering Informatics
- Journal of Manufacturing Processes
- International Journal of Advanced Manufacturing Technology

期刊分区、影响因子和 CiteScore 会随年份变化，不能硬编码为固定事实。执行时应根据用户指定评价体系验证，例如 JCR、Scopus CiteScore、中科院分区、ABS 或学校认可目录。

---

## 10. Recent-Core-First + Snowballing 检索流程

检索必须采用以下顺序。

### Step 1. Recent-core-first search

先找近 3 年内高质量期刊中的高相关论文，目标 3–5 篇，不要求绝对满足，但必须尝试。

记录：

```text
query
source database
venue
year
why selected
why high-quality
similarity score
baseline potential
```

### Step 2. Backward snowballing

从近年核心论文的参考文献中回溯：

- 早期代表性工作；
- 问题源头；
- 经典算法；
- 关键模型；
- 被多篇文献反复引用的工作；
- 可作为 baseline 的早期方法。

### Step 3. Forward snowballing

检索引用种子论文的后续文献，识别：

- 最新扩展；
- 新目标函数；
- 新约束；
- 新算法；
- 仍未解决的问题；
- 已公开数据、代码或 benchmark 的文献。

### Step 4. Author-lineage search

对关键作者进行同作者检索，识别连续研究脉络。例如：

```text
Sakaguchi 2012 → Sakaguchi 2018 → Sakaguchi 2020
Gahm 2022 → Uzunoglu 2024
Lee 2025 and cited predecessors
```

### Step 5. Query expansion

如果强检索式结果少，要分支检索：

- shop environment branch；
- missing operation branch；
- precedence / BOM / assembly branch；
- nesting / sheet metal branch；
- batch / lot / release branch；
- algorithm branch。

---

## 11. 文献筛选评分

每篇候选文献必须打分。评分不是精确数学结论，而是透明筛选依据。

| 维度 | 分值 | 说明 |
|---|---:|---|
| Problem similarity | 0–5 | shop 环境是否接近 |
| Constraint similarity | 0–5 | 约束是否接近 |
| Objective similarity | 0–5 | 目标函数是否接近 |
| Method usefulness | 0–5 | 方法流程是否可借鉴 |
| Venue quality | 0–5 | 期刊/会议质量 |
| Recency | 0–5 | 时间新近性 |
| Snowballing centrality | 0–5 | 是否是种子、被引、源头或同作者链条关键节点 |
| Evidence clarity | 0–5 | 摘要/全文是否能支撑判断 |
| Baseline usefulness | 0–5 | 是否适合复现、改造或公平比较 |

最终分类：

- A 类：高度相关核心文献；
- B 类：相关但缺少部分关键特征；
- C 类：方法或背景参考；
- D 类：剔除文献。

D 类文献不进入最终主表，但必须保留在 `screening_records.csv` 中并说明剔除原因。

---

## 12. 论文阅读卡片

每篇入选文献必须生成阅读卡片：

```text
Paper ID:
Citation:
Year:
Journal / Conference:
DOI:
Venue quality note:
Search route: direct / recent-core / backward snowballing / forward snowballing / author-lineage / user-seed
Problem type:
Domain:
Production objects:
Shop environment:
Objective:
Constraints:
Missing operations:
Nesting / packing / cutting pattern:
Batch / lot / BOM relation:
Cross-order precedence / release relation:
Method:
Mathematical model:
Encoding:
Decoding:
Initialization:
Neighborhood:
Local search:
Acceptance criterion:
Repair mechanism:
Parameter tuning:
Experiment instances:
Compared baselines:
Main results:
Useful idea:
Limitation:
Similarity to this study:
Relevance score:
Baseline candidate: Yes / No
Baseline role:
Reproducibility note:
Evidence notes:
Unclear fields:
```

不确定的信息填 `Unclear` 或 `Not reported`。

---

## 13. 输出表格一：问题特征对比表

### 13.1 full version

用于研究笔记和证据追踪，回答：已有研究解决了什么问题，考虑了哪些约束，目标函数是什么。

默认列：

```text
Study | Venue | Search route | Shop / domain | Objective | Missing operations | Nesting / cutting pattern | Batch / lot | Cross-order precedence | Release mechanism | Machine environment | Method | Similarity | Key difference | Baseline candidate | Evidence note
```

输出文件：

```text
problem_feature_table_full.csv
problem_feature_table_full.md
```

### 13.2 paper version

用于放入论文第 2 章正文，不应直接放 full matrix。paper version 必须压缩字段，突出本文与已有研究的差异。

推荐列：

```text
Study | Shop / domain | Missing operations | Nesting / cutting pattern | Batch / lot | Cross-order dependency | Objective | Baseline role | Difference from this study
```

输出文件：

```text
problem_feature_table_paper.md
```

### 13.3 论文中放置位置

默认放在第 2 章末尾，即：

```text
2.5 文献对比与本文定位
```

正文中只放 paper version；full version 可作为附录或研究过程文件。

---

## 14. 输出表格二：方法流程矩阵表

用于回答：已有研究怎么做算法，本文方法可以在哪些环节创新。

默认列：

```text
Method component | Paper A | Paper B | Paper C | This study
```

默认行：

```text
Main framework
Mathematical model
Encoding
Decoding
Initialization
Construction rule
Destruction / reconstruction
Neighborhood
Local search
Repair mechanism
Constraint handling
Acceptance rule
Parameter tuning
Stopping criterion
Objective evaluation
Benchmark instances
Compared baselines
Strength
Weakness
Reusable idea
Baseline role
```

如果用户研究的是 two-phase SA / IG / VNS / memetic algorithm，必须突出：

- phase 1 / phase 2 各自解决什么；
- destroy-repair 或 local search 机制；
- insertion / swap / block move / critical-path move 邻域；
- acceptance criterion；
- DAG / release / missing-operation repair；
- parameter calibration；
- ablation design。

---

## 15. Baseline 候选论文标注规则

在检索和筛选阶段必须同步标注潜在 baseline，不能等实验章节才临时寻找。

输出文件：

```text
baseline_candidates.csv
recommended_baselines.md
```

### 15.1 baseline 字段

```text
Paper ID
Citation
Baseline candidate: Yes / No
Baseline role: BASE-MIP / BASE-HFSMO / BASE-PREC / BASE-NEST / BASE-GA / BASE-SA / BASE-VNS / BASE-IG / BASE-RULE / BASE-ML
Baseline level: strong / medium / weak
Why baseline
Reproducibility: high / medium / low
Data available: Yes / No / Unclear
Code available: Yes / No / Unclear
Implementation cost: low / medium / high
Required adaptation
Fairness note
```

### 15.2 baseline 分类

| baseline 类型 | 用途 |
|---|---|
| exact / MIP / CP baseline | 小规模最优解、可行解或下界 |
| simple dispatching rules | SPT、LPT、EDD、NEH-like，用作基础对照 |
| HFSP-MO heuristic | 对比缺失操作处理能力 |
| precedence / BOM heuristic | 对比跨订单前序关系处理能力 |
| nesting-scheduling heuristic | 对比排料图 / 批次释放逻辑 |
| general metaheuristics | GA、SA、IG、VNS、TLBO、ABC 等通用对照 |
| ablation baselines | 去掉关键模块、去掉修复、去掉局部搜索、随机初始化等 |

### 15.3 公平性说明

如果文献问题与本文不完全一致，必须说明如何改造 baseline，例如：

- 去掉本文特有约束，形成退化问题；
- 在原算法中加入 feasible decoder；
- 只比较同一目标函数下的版本；
- 仅作为启发式规则对照，而不是声称完整复现。

---

## 16. Gap Argument Map

必须输出 `gap_argument_map.md`，用于保证 gap 逻辑不是拼凑。

格式：

```text
Production fact:
Why it matters:
Scheduling consequence:
Existing literature handles:
Remaining modeling gap:
Why this gap is not a trivial combination:
How this study responds:
Evidence papers:
Possible reviewer challenge:
Response to challenge:
```

### 16.1 禁止式 gap

禁止写：

```text
已有研究 A 没有考虑 X，已有研究 B 没有考虑 Y，所以本文研究 X+Y。
```

### 16.2 推荐式 gap

推荐写作逻辑：

```text
生产场景中的某个管理目标或工艺机制 → 改变了调度对象或释放机制 → 使传统模型中的 job / operation / release time 定义不再充分 → 现有文献分别处理相关部分，但没有形成能够描述该机制的统一调度对象和约束结构 → 本文定义该问题并给出模型/算法。
```

---

## 17. Introduction Draft 写作规则

必须输出 `introduction_draft.md`。调度优化论文引言建议结构：

1. **Industrial background**：从实际生产环境出发，说明为什么该问题重要。
2. **Operational mechanism**：解释业务对象如何形成，如订单、零件、排料图、批次、后续工艺之间的关系。
3. **Scheduling difficulty**：说明该机制带来的调度困难，而不是直接说“已有研究没有考虑”。
4. **Literature positioning**：将已有研究分为若干方向，说明每类研究解决了什么。
5. **Research gap**：gap 必须由生产机制和文献边界共同推出。
6. **Contributions**：给出 3–5 条贡献，必须与问题定义、模型、算法、实验设计对应。
7. **Paper organization**：简要说明论文结构。

### 17.1 第一章必须包含本文贡献和章节安排

如果用户没有特别要求删除，引言末尾必须包含：

```text
本文的主要贡献如下：
第一，……
第二，……
第三，……
```

以及：

```text
本文其余部分安排如下：第 2 章……；第 3 章……；第 4 章……；第 5 章……；第 6 章……。
```

### 17.2 写作质量规则

- 不写空泛句，如 “With the rapid development of industry...”；
- 不连续堆叠 “However, few studies...”；
- 每个 gap 必须对应实际生产机制或明确建模障碍；
- 不把“多个约束简单相加”写成创新；
- 贡献点必须可被后文模型、算法或实验验证；
- 不确定的文献信息不得写入正文；
- 引言中的每条强事实必须有引用或可追溯来源。

---

## 18. Related Work Draft 写作规则

必须输出 `related_work_draft.md`。默认结构：

```text
2.1 Hybrid flow shop scheduling
2.2 Hybrid flow shop scheduling with missing operations or skipped stages
2.3 Scheduling with precedence, assembly, BOM, release-time or batch dependency
2.4 Sheet metal, nesting, cutting-pattern and batch/lot scheduling
2.5 Literature comparison and positioning of this study
```

每个小节必须满足：

1. 先概括该研究方向解决什么问题；
2. 再介绍代表性文献；
3. 然后说明与本文问题的关系；
4. 最后自然过渡到尚未解决的生产机制或建模需求。

相关工作不是逐篇罗列。要按研究脉络组织。

### 18.1 是否放入文献矩阵一

第 2 章可以放入**压缩后的问题特征对比表 paper version**，建议放在 `2.5 Literature comparison and positioning of this study`。不要把 full matrix 原样放入正文。

写作规则：

```text
正文先综述研究脉络 → 再引出 Table 1 → 用 1–2 段解释表格揭示的差异 → 最后自然导出本文定位。
```

---

## 19. 第 3 章：问题描述写作规则

本 Skill 应输出 `section_3_problem_description_outline.md` 和必要的 `illustrative_example.md`。第 3 章重点是解释问题，而不是完整写方法。

### 19.1 推荐结构

```text
3 Problem Description
3.1 Production process and object transformation
3.2 Scheduling objects and precedence relationship
3.3 Assumptions
3.4 Illustrative example
3.5 Gantt-chart interpretation
```

如果目标论文要求“问题描述与数学模型”合并，也可使用：

```text
3 Problem Description and Mathematical Formulation
3.1 Problem description, assumptions and illustrative example
3.2 Mathematical formulation
```

但对于业务对象转换复杂的问题，推荐把“问题描述”和“数学模型/方法”分开表达，至少在写作产物中单独输出第 3 章问题描述草稿或框架。

### 19.2 第 3 章必须说明

- 车间结构：阶段数、每阶段并行机数量、同质或异质机器；
- 订单类型：例如 NEST、LOT、raw order、batch、job；
- 业务对象转换：原始订单如何变为最终调度对象；
- 缺失操作：加工时间为 0 的含义；
- 跨订单关系：例如 NEST→LOT、BOM、assembly、release constraints；
- 自身工艺顺序：非缺失阶段按阶段顺序加工；
- 小例子：用 2–4 个上游对象和 1–3 个下游对象说明释放关系；
- 甘特图说明：至少解释释放时间、等待时间、跳阶段和机器容量冲突；
- 基本假设：不考虑哪些实际因素，以及这些因素为何暂时排除。

### 19.3 第 3 章不应做的事

- 不把完整算法设计写入第 3 章；
- 不提前声称实验结果；
- 不把 gap 段落重复一遍；
- 不用公式替代业务解释；
- 不让读者必须先看数学模型才能理解对象关系。

---

## 20. 第 4 章：模型或方法章节的辅助规则

第 4 章通常需要用户自己写，因为它必须与实际模型、算法和代码实现完全一致。本 Skill 只输出辅助文件，不强行代写完整第 4 章。

根据用户论文结构，第 4 章可能是：

1. Mathematical formulation；
2. Solution method；
3. Algorithm design。

本 Skill 默认输出：

```text
section_4_model_or_method_checklist.md
notation_table_template.md
constraint_checklist.md
algorithm_component_checklist.md
```

### 20.1 如果第 4 章是数学模型

只提供：

- 集合、索引、参数、变量建议；
- 目标函数应如何与问题目标一致；
- 约束清单；
- 缺失操作、跳阶段、release、DAG、machine capacity 的检查点；
- 大 M 约束或时间索引模型的风险提示。

不生成未经验证的完整公式。

### 20.2 如果第 4 章是求解方法

只提供：

- 编码设计建议；
- 解码流程检查；
- 初始化规则；
- 邻域结构建议；
- repair / feasibility check；
- acceptance rule；
- 参数校核接口；
- 消融实验对应模块。

不虚构未实现的算法细节。

---

## 21. 第 5 章：实验设计与结果写作边界

第 5 章通常需要真实实验结果支撑。除 `5.1 Experimental design` 可以先写草稿外，其余小节只输出框架、表格模板和分析维度，不能生成伪结论。

### 21.1 推荐结构

```text
5 Computational Experiments
5.1 Experimental design
5.1.1 Instance generation
5.1.2 Parameter calibration
5.1.3 Compared algorithms and evaluation metrics
5.2 Comparison with baseline algorithms
5.3 Ablation study
5.4 Sensitivity analysis
5.5 Discussion
```

### 21.2 5.1 可以写什么

`experiment_section_framework.md` 和 `instance_generation_protocol.md` 应包括：

- 数据来源：真实数据、随机数据、半真实数据、基于业务机制生成；
- 实例规模：small / medium / large；
- 关键参数：阶段数、机器数、订单数、缺失率、batch/lot 比例、DAG 边密度等；
- 加工时间生成规则；
- 释放关系或 precedence graph 生成规则；
- 算法运行环境；
- 参数校核数据集；
- 对比算法；
- 评价指标。

### 21.3 5.2–5.5 只能搭框架

没有真实实验数据时，不得写：

```text
proposed algorithm outperforms all baselines
实验结果表明……
显著提高……
```

只能输出：

```text
baseline_comparison_plan.md
ablation_plan.md
sensitivity_analysis_plan.md
result_table_templates.md
```

### 21.4 评价指标建议

- Best objective value；
- Average objective value；
- Relative percentage deviation (RPD)；
- CPU time；
- Optimality gap；
- Feasible rate；
- Stability / standard deviation；
- Large-instance scalability。

---

## 22. Citation Strategy

必须输出 `citation_strategy.md`，说明每类文献在论文中承担什么作用：

| 文献类型 | 论文中作用 |
|---|---|
| Foundational HFSP papers | 定义问题类型、机器环境、目标函数、算法分类 |
| Missing operation papers | 说明跳阶段 / 缺失操作的建模与解码处理 |
| Precedence / BOM / assembly papers | 说明跨订单依赖、释放关系、AND-precedence 或装配关系 |
| Sheet metal / nesting papers | 支撑工业背景、排料与后续调度耦合关系 |
| Batching / lot papers | 支撑合批、批次形成、批处理或 serial-batch 机制 |
| Algorithm papers | 支撑编码、解码、邻域、参数校核、baseline 和消融实验 |
| Recent high-quality papers | 支撑研究前沿与 gap 的时效性 |
| Low-venue but key papers | 仅用于源头、场景或独特机制，不作为主要理论支撑 |

---

## 23. Contribution Paragraph 写作规则

必须输出 `contribution_paragraph.md`。贡献点不能泛泛而谈，必须能映射到后文。

推荐结构：

```text
This study makes the following contributions.
(1) Problem definition: ...
(2) Mathematical model: ...
(3) Solution method: ...
(4) Instance generation and experiments: ...
```

对于中文论文：

```text
本文的主要贡献如下。
第一，……
第二，……
第三，……
第四，……
```

避免写：

```text
本文丰富了相关研究。
本文提出了一种新方法并取得了较好结果。
```

除非说明“丰富在哪里”“新在哪里”“好结果由哪些实验支撑”。

---

## 24. 方法设计提示

必须输出：

```text
method_design_hints.md
```

### 24.1 方法设计提示应与文献矩阵绑定

每个方法建议都应说明来源：

```text
method idea → inspired by Paper ID → adapted to this problem because ...
```

### 24.2 常见提示

如果存在 DAG release，则提示：

- topological-order encoding；
- release-time-aware decoding；
- infeasible move repair；
- critical-path / bottleneck-NEST neighborhood；
- LOT waiting time reduction neighborhood；
- NEST-first or LOT-release-aware construction rule。

如果存在 missing operations，则提示：

- non-missing stage list per job；
- skipped-stage-aware earliest start computation；
- stage compression in decoding；
- operation feasibility check only on nonzero processing times。

---

## 25. 输出文件

默认输出：

```text
outputs/
├── problem_fingerprint.json
├── terminology_mapping.md
├── search_queries.txt
├── search_protocol.md
├── venue_quality_plan.md
├── screening_records.csv
├── paper_reading_cards.md
├── problem_feature_table_full.md
├── problem_feature_table_full.csv
├── problem_feature_table_paper.md
├── method_matrix_table.md
├── method_matrix_table.csv
├── baseline_candidates.csv
├── thematic_clusters.md
├── gap_argument_map.md
├── novelty_gap_summary.md
├── introduction_draft.md
├── related_work_draft.md
├── contribution_paragraph.md
├── citation_strategy.md
├── recommended_baselines.md
├── method_design_hints.md
├── section_3_problem_description_outline.md
├── illustrative_example.md
├── section_4_model_or_method_checklist.md
├── notation_table_template.md
├── constraint_checklist.md
├── algorithm_component_checklist.md
├── experiment_section_framework.md
├── instance_generation_protocol.md
├── parameter_calibration_plan.md
├── baseline_comparison_plan.md
├── ablation_plan.md
├── sensitivity_analysis_plan.md
├── result_table_templates.md
├── literature_review_draft.md
├── references.bib
└── referenced_skills.md
```

如果用户只要快速结果，可输出简版，但必须说明哪些文件未生成。

---

## 26. 质量控制清单

执行结束前必须检查：

- [ ] 没有编造论文、作者、年份、期刊、DOI；
- [ ] 没有把不确定信息写成 `Yes`；
- [ ] 每篇核心文献都有阅读卡片；
- [ ] 两张矩阵表能追溯到阅读卡片；
- [ ] 近 3 年高质量期刊文献已尝试检索；
- [ ] 已进行 backward / forward snowballing 或说明无法进行；
- [ ] 低质量但保留文献有保留理由；
- [ ] 检索过程中已标注 baseline candidate；
- [ ] gap 从生产机制出发，不是约束堆叠；
- [ ] introduction draft 包含工业背景、机制、困难、文献定位、gap、贡献、结构；
- [ ] related work 按主题组织，不逐篇罗列；
- [ ] 第 2 章只放 paper version 问题特征表，不直接放 full matrix；
- [ ] 第 3 章问题描述不与算法或实验结果混写；
- [ ] 第 4 章只提供检查清单，不虚构用户尚未实现的方法；
- [ ] 第 5 章除 5.1 外只给框架，不写未被数据支撑的结论；
- [ ] contribution 能映射到模型、算法、实验；
- [ ] baseline 和实验设计与文献矩阵一致；
- [ ] 引用的外部 skill / 仓库记录在 `referenced_skills.md`。

---

## 27. 与其他 Skill 的衔接

### 接收自 problem-decomposition-skill

```text
refined_problem_description.md
problem_fingerprint.json
assumption_log.md
open_questions.md
```

### 输出给 mip-hfsp-project-generator-skill

```text
problem_fingerprint.json
terminology_mapping.md
problem_feature_table_full.md
problem_feature_table_paper.md
method_matrix_table.md
baseline_candidates.csv
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
section_3_problem_description_outline.md
section_4_model_or_method_checklist.md
experiment_section_framework.md
```

### 输出给 paper-writing-skill / journal-adapt-writing-skill

```text
introduction_draft.md
related_work_draft.md
gap_argument_map.md
contribution_paragraph.md
citation_strategy.md
referenced_skills.md
```

---

## 28. 推荐论文结构

本 Skill 不强制章节编号，但默认建议如下：

```text
1 Introduction
2 Literature Review / Related Work
3 Problem Description
4 Solution Method 或 Mathematical Formulation（由用户按实际论文结构决定）
5 Computational Experiments
6 Conclusions
```

对于“问题描述 + 数学模型”特别复杂的论文，可采用：

```text
1 Introduction
2 Literature Review
3 Problem Description
4 Mathematical Formulation
5 Solution Method
6 Computational Experiments
7 Conclusions
```

执行时必须遵守用户指定章节编号。

---

## 29. 示例：HFSP-MO-NEST-LOT 问题的 gap 逻辑

对于“带缺失操作与排料图—批次关系约束的混合流水车间调度问题”，gap 不应写成：

```text
已有 HFSP-MO 研究没有考虑排料图—批次关系，因此本文研究该问题。
```

应写成：

```text
冲压车间为了提高材料利用率，通常会将来自不同原始订单的零件组合到同一张排料图中；与此同时，一个原始订单或后续批次所需零件也可能被分散到多张排料图。这样，冲压阶段的调度对象更接近排料图，而冲压后的调度对象更接近按订单归属、物料属性和工艺路线归集形成的后续批次。下游批次的释放时间不再由其自身工艺路线单独决定，而取决于多个上游排料图是否全部完成。若再考虑后续批次工艺路线差异，部分阶段可能被跳过，则传统以独立 job 为对象的 HFSP 或单纯的 HFSP-MO 难以直接刻画这种由排料图诱导的对象转换与多前序释放关系。因此，需要将排料图订单和后续加工批次统一纳入多阶段混合流水车间，并同时描述缺失操作、阶段顺序、并行机容量和 NEST→LOT 关系约束。
```

这个逻辑先解释生产机制，再引出建模需求，最后定位文献边界。

---

## 30. 外部写作 Skill 引用记录规则

如果借鉴其他写作 skill 或 prompt 仓库，必须在 `outputs/referenced_skills.md` 中记录：

```text
Skill / Repository:
URL:
Borrowed idea:
How it is adapted:
License / attribution note:
```

默认可参考：

- `wssmc/skills/literature-matrix-review-skill`：当前 skill 主体；
- `Master-cai/Research-Paper-Writing-Skills`：引言、方法、实验、结论写作流程与 claim-evidence alignment；
- `Leey21/awesome-ai-research-writing`：prompt 模板库、逻辑检查、图表 caption、reviewer 视角检查；
- `Imbad0202/academic-research-skills`：research → write → review → revise → finalize 的阶段化流程和 integrity verification；
- `WantongC/journal-adapt-writing-skill`：目标期刊写作风格学习、primary / secondary corpus 思路。

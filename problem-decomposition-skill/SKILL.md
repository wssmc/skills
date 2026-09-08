# Problem Decomposition Skill

## 1. Skill 定位

当用户输入一段粗略的研究想法、业务描述、调度问题描述、车间排产问题描述或组合优化问题描述时，使用本 Skill。

本 Skill 的目标不是直接写代码或直接检索文献，而是先把问题拆清楚，形成一段高质量、可检索、可建模、可实现的问题描述。

本 Skill 是以下两个 Skill 的上游：

```text
problem-decomposition-skill
→ literature-matrix-review-skill
→ mip-scheduling-project-generator-skill
```

---

## 2. 触发场景

用户出现以下需求时，应使用本 Skill：

- "帮我整理这个问题描述"
- "我这个问题应该怎么描述"
- "帮我把业务问题转成优化问题"
- "根据我说的一段话，追问我，最后整理成高质量问题描述"
- "为后续文献检索 / MIP 建模 / 算法实现准备问题描述"
- "我还不确定约束、目标、数据字段，请帮我拆解"

---

## 3. 总体流程

执行流程如下：

1. 读取用户原始描述；
2. 抽取初始关键词；
3. 判断问题类型；
4. 判断描述完整度；
5. 生成第一轮关键澄清问题；
6. 根据用户回答更新问题画像；
7. 必要时生成第二轮细化问题；
8. 标记已确认信息、合理假设、未确认信息；
9. 输出高质量问题描述；
10. 输出结构化 problem fingerprint；
11. 输出给文献检索 Skill 和 MIP 实现 Skill 的交接文件。

---

## 4. 问题描述质量标准

最终问题描述至少要说清楚：

1. 要调度 / 分配 / 优化的对象是什么；
2. 对象被安排到哪些资源上；
3. 时间结构是什么；
4. 哪些事情不能冲突；
5. 工序或任务之间是否存在先后顺序；
6. 是否存在机器、运输、人力、物料等资源容量；
7. 是否有释放时间、交期、交期窗口、优先级、共享窗口、机器不可用期；
8. 目标函数是什么；
9. 数据以什么形式给出；
10. 计划使用什么模型或算法；
11. 后续需要输出哪些内容。

---

## 5. 提问策略

不要一次性抛出过多问题。优先问最影响建模的 5 到 8 个问题。

### 第一轮：核心建模问题

优先确认：

- 问题类型：HFSP、FJSP、JSP、PFSP、并行机、资源约束调度、一般 MIP？
- 对象：Job、Operation、Stage、Machine、Worker、Transporter？
- 流程：是否所有 Job 都经过相同 Stage？
- 机器：每个 Stage 有几台并行机？
- 加工时间：是 Job × Stage，还是 Operation × Machine？
- 目标：makespan、total tardiness、TWET、成本、能耗、多目标？
- 关键约束：due window、priority jobs、shared windows、MUPs、setup、blocking、transport、worker？

### 第二轮：数据与实现问题

确认：

- 数据文件格式；
- 是否主体数据必须用 txt；
- 是否用 json 作为索引；
- demo / small / large 的规模；
- 是否需要 MIP；
- MIP 是否使用 IBM 官方 `cplex` Python API；
- 是否需要 baseline；
- 是否需要本文算法 proposed；
- 是否需要甘特图、收敛图、统计检验。

### 第三轮：论文表达问题

确认：

- 是否需要文献综述矩阵；
- 检索范围；
- 目标期刊或会议；
- 贡献点想落在哪些方面；
- 本文方法的大致方向。

---

## 6. 信息完整度评分

对用户输入进行 0 到 5 分评分：

- 0：只有主题，没有优化对象；
- 1：有对象，但没有资源、目标、约束；
- 2：有对象、资源、目标，但约束很模糊；
- 3：有基本可建模描述，但数据和特殊约束不完整；
- 4：可直接建模，但算法、实验、文献衔接仍可细化；
- 5：可直接进入文献检索和 MIP/算法实现。

如果评分小于 3，先追问，不直接输出最终问题描述。
如果评分为 3 或 4，可以输出带假设的问题描述。
如果评分为 5，可以直接输出交接文件。

---

## 7. 输出格式

最终输出必须包含以下文件内容。

### 7.1 refined_problem_description.md

一段高质量自然语言问题描述，应包含：

- 问题背景；
- 问题类型；
- 系统组成；
- 决策内容；
- 目标函数；
- 约束条件；
- 数据格式；
- 输出需求；
- 后续研究方向。

### 7.2 problem_fingerprint.json

用于文献检索和代码生成的结构化画像。

### 7.3 modeling_elements.md

列出集合、参数、变量、目标函数、约束、输出指标。

### 7.4 assumption_log.md

记录所有合理假设，格式：

```text
Assumption ID | Content | Reason | Impact | Need user confirmation
```

### 7.5 open_questions.md

列出仍需确认的问题。

### 7.6 data_requirement.md

列出所需数据文件、字段含义和格式建议，包括：

- 必需数据文件，如 `processing_times.txt`、`stage_machines.txt`、`index.json`；
- 可选数据文件，如 `release_times.txt`、`due_windows.txt`、`setup_times.txt` 等；
- 每个文件的字段说明和示例；
- 主体数据使用 txt 保存、JSON 仅作为索引或配置文件的规则说明。

### 7.7 handoff_to_literature_skill.md

把问题转成检索可用的关键词、同义词、检索式种子和筛选标准。

### 7.8 handoff_to_mip_skill.md

把问题转成建模实现可用的约束清单、数据字段、模块要求和输出要求。

---

## 8. 特别规则

- 不要编造用户没有确认的强约束；
- 不确定的信息放入 `assumption_log.md` 或 `open_questions.md`；
- 如果用户明确使用 HFSP，则优先采用 `JobID × Stage` 加工时间格式；
- 如果用户要求主体数据为 txt，则不要默认使用 JSON 保存主体数据；
- JSON 只用于索引、配置、结构化画像和结果；
- 如果用户后续要做文献检索，必须输出检索关键词；
- 如果用户后续要做 MIP 实现，必须输出集合、参数、变量、目标和约束；
- 输出应服务后续两个 Skill，而不是只写一段漂亮文字。

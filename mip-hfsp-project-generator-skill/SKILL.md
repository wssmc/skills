# MIP / HFSP 项目生成器 Skill

## 1. Skill 定位

本 Skill 用于根据用户提供的调度、排产、资源分配或组合优化问题描述，生成一套可运行、可验证、可扩展、面向论文的 Python 研究工程。

本 Skill 不应只输出单个脚本，而应输出结构化项目工程。

> **模块索引**：本 Skill 拆分为以下模块文件，按需加载：
> - `modules/structure.md` — 目录结构、数据层、源代码层、configs、outputs、docs、latex、AGENTS.md
> - `modules/algorithms.md` — 算法命名与注册、元启发式模板、编码解码、邻域算子、评价、消融、MIP 建模
> - `modules/scripts.md` — 脚本层架构、核心脚本、MIP 脚本、扩展实验脚本、项目执行步骤
> - `modules/quality.md` — 占位策略、实现状态、问题描述文档、测试、审计、交付、可视化、算法打印

---

## 2. 触发场景

当用户提出以下任一需求时，应使用本 Skill：

- 根据问题描述生成调度 / 排产 / 资源分配 Python 项目
- 需要 MIP 模型代码（Gurobi）
- 需要 demo / small / large 算例生成
- 需要编码、解码、元启发式算法
- 需要 baseline 对比算法
- 需要与 MIP 结果对比
- 需要甘特图或实验可视化
- 需要批量实验脚本（single / bench / batch）
- 需要消融实验、DOE、统计检验
- 明确提到 HFSP、FJSP、JSP、并行机、车间调度、工序调度、资源约束调度

---

## 3. 总体执行原则

1. **可复现**：确定性种子、确定性输出、结果可从 best_seq 复现并校验
2. **可扩展**：算法注册制，新增算法只需注册到 `registry.py`
3. **分层清晰**：数据层、求解层、评估层、输出层、分析层各自独立
4. **面向论文**：所有实验设计围绕论文需求（对比、消融、DOE、统计检验）
5. **禁止随意生成脚本**：优先复用核心脚本（single / bench / batch / analysis）
6. **加速评估**：所有元启发式算法**必须**使用 `EvalCache`（编码序列 → 目标值缓存），上限 500，FIFO 弹出最旧策略。缓存键为编码序列的哈希（如 `tuple(job_sequence)`），评估时先查缓存未命中再解码。此约定必须写入生成项目的 `docs/YYYY-M-D_algorithm_design.md`
7. **改进必须消融**：每次算法组件改进都必须消融，撰写完整消融记录文档
8. **输出隔离**：所有实验输出仅限项目内 `outputs/` 目录
9. **执行安全**：预估耗时超过 1 小时的任务必须后台运行
10. 代码优先，解释为辅
11. demo 算例必须能够跑通
12. 主体数据优先保存为 txt，json 只用于索引、配置或结构化结果
13. **MIP 默认使用 Gurobi**（`gurobipy`）
14. 项目必须模块化
15. 所有算法输出必须统一为 Schedule / Result 格式
16. 所有结果必须经过 `check_feasibility` 和 metrics evaluation
17. **占位允许，但必须透明**：占位目录必须有 `PLACEHOLDER.md`，占位代码必须 raise NotImplementedError
18. **所有可运行算法必须默认注册**到 `registry.py`
19. **结构完整不等于功能完整，必须标记实现状态**
20. **生成项目后必须自检**：生成 `PROJECT_AUDIT.md` 和 `IMPLEMENTATION_STATUS.md`
21. **最终交付必须给出测试、审计和实现状态摘要**
22. 如果问题描述不完整，应先给出"缺失信息清单"和"默认假设"
23. **对话约定必须持久化**：生成过程中所有自然语言约定（澄清、决策、假设、额外要求）必须写入项目内的 `docs/` 或 `configs/`，避免上下文丢失后无法追溯

---

## 4. 问题描述自然语言结构化分析

> 生成项目前，**第一步**必须对用户输入的问题描述进行自然语言结构化分析。

### 4.1 分析流程

```text
1. 阅读用户问题描述
2. 提取关键要素（对象、资源、约束、目标）
3. 结构化为标准化问题定义
4. 识别缺失信息，给出默认假设
5. 输出结构化问题定义文档
```

### 4.2 提取要素

| 要素 | 说明 | 示例 |
|------|------|------|
| **调度对象** | 要安排的是什么 | Job、Order、Task、Operation、Vehicle |
| **资源** | 安排到哪里 | Machine、Stage、Worker、Transporter、Station |
| **顺序规则** | 对象间的优先关系 | Job 内按 Stage 顺序、DAG 前序约束 |
| **冲突规则** | 资源占用约束 | 同一机器同一时间只能加工一个任务 |
| **加工时间** | 时间由什么决定 | Job × Stage、Job × Machine、Job × Stage × Machine |
| **优化目标** | 最小化/最大化什么 | makespan、total tardiness、flow time、weighted |
| **特殊约束** | 问题特有约束 | 根据问题描述提取，无则为空 |

### 4.3 结构化输出

分析完成后，输出结构化问题定义，作为后续所有模块的**问题定义源**：

```text
问题类型：{HFSP / FJSP / JSP / Parallel Machine / General MIP}
调度对象：{描述}
资源定义：{描述}
顺序规则：{描述}
冲突规则：{描述}
加工时间：{描述}
优化目标：{描述}
特殊约束：{根据问题描述提取，无则为空}
默认假设：{对缺失信息的默认假设}
```

> 此结构化定义驱动数据生成、Instance 字段、decoder、feasibility checker、MIP 模型、baseline、邻域算子等所有后续组件。特殊约束部分**根据问题描述智能提取**，不预设固定清单。

### 4.4 算法适配项目（Algorithm Adaptation）

> 当指令是**"算法适配项目"**（即将某已有算法/文献中的算法适配到本项目）时，遵循以下强制流程。

**流程**：

1. **拆解**：从原算法中识别可复用组件
   - 初始化方法（如作者提出的 NEH 变体、启发式排序规则）
   - 邻域算子
   - 编码方式（如已有）
   - 参数策略

2. **提取初始化方法到 `src/metaheuristics/initial/`**，**严格区分单解 / 种群**：
   - **单解生成器** → `initial/single/{方法名}.py`，供 SA/IG/TS 使用，返回 `list[int]`
   - **种群生成器** → `initial/population/{方法名}_pop.py`，供 GA/MA 使用，返回 `list[list[int]]`
   - **严禁混用**：单解生成器直接用于种群会导致所有个体相同，种群丧失多样性
   - 函数签名：
     - 单解：`init_xxx(instance, **kwargs) -> list[int]`
     - 种群：`generate_xxx_population(instance, pop_size, seed=None, **kwargs) -> list[list[int]]`
   - **原算法主体不重复实现初始化逻辑，而是 import 并调用**

3. **原算法主文件放在对应目录**
   - 如 `src/metaheuristics/ig/ig_author2020.py`
   - 顶部 import 提取出的初始化：
     ```python
     from metaheuristics.initial.neh_author2020 import init_neh_author2020
     ```

4. **注册到 `registry.py`**（详见 §3.16 算法注册规则）

**目的**：
- 初始化方法**跨算法复用**（不同元启发式可共用同一初始化）
- 消融实验时可**替换初始化**（如比较 NEH vs 随机 vs 作者变体）
- 便于公平对比（详见 §4.5）

### 4.5 批量对比时的一致性要求

> 使用 `sh_batch_instances_algorithms.sh` 进行多算法批量对比时，**默认要求所有算法使用统一的初始化和缓存**，以保证对比公平性。

**脚本必须支持两个交互式提示或命令行开关**：

| 开关 | 默认 | 含义 |
|------|------|------|
| `--unified-init [y/n]` | `y` | 是否所有算法使用**同一个**初始化方法（如统一用 NEH） |
| `--unified-cache [y/n]` | `y` | 是否所有算法使用**同一个** EvalCache（跨算法共享缓存） |

**运行时行为**：

- **交互模式**（无开关时）：脚本启动后提示用户选择
  ```
  Use unified initialization for all algorithms? [y/n] (default: y):
  Use unified EvalCache across algorithms? [y/n] (default: y):
  ```
- **参数模式**：`bash scripts/sh_batch_instances_algorithms.sh all 0.1 --unified-init y --unified-cache y`

**逻辑**：

| 选项 | y（统一） | n（各自独立） |
|------|----------|--------------|
| unified-init | 所有算法用同一个 `init_xxx()`（默认 NEH），保证起点相同 | 各算法用注册时指定的初始化 |
| unified-cache | 传入同一个 `EvalCache` 实例给所有算法 | 各算法内部各自 `EvalCache(500)` |

**关键约定必须写入项目 `docs/YYYY-M-D_algorithm_design.md`**：
- 批量对比默认使用统一初始化 + 统一缓存
- 使用非统一选项需在 `configs/conventions.md` 中记录理由

### 4.4 约定持久化（重要）

> **在使用 Skill 生成项目的整个对话过程中，所有自然语言描述的约定必须持久化到项目内**，避免上下文丢失后无法追溯。

**需要持久化的约定包括**：

| 类型 | 举例 | 存放位置 |
|------|------|---------|
| 问题澄清对话 | 用户回答的补充信息、默认假设的确认 | `docs/YYYY-M-D_problem_description.md` |
| 建模决策 | 为什么选择 makespan 而非加权目标、为什么使用某种编码 | `docs/YYYY-M-D_modeling_assumptions.md` |
| 算例设计 | demo/small/large 的规模选择依据、参数范围来源 | `docs/YYYY-M-D_instance_design.md` |
| 算法设计约定 | 邻域选择理由、初始化策略选择理由 | `docs/YYYY-M-D_algorithm_design.md` |
| 实验设计 | 为什么 7 轮、为什么 factor=0.05 等 | `docs/YYYY-M-D_experiment_plan.md` |
| 命名与结构约定 | 特定于本项目的命名规则、目录结构调整 | `AGENTS.md` |
| 交互过程约定 | 用户额外要求（如"不使用 CPLEX"、"输出保留 4 位小数"） | `configs/conventions.md`（新增） |
| 问题特征 | 结构化问题定义 + fingerprint | `configs/problem_fingerprint.json` + `configs/problem_statement.md` |

**持久化时机**：
- 每次用户提出新的约定/澄清 → 立即写入对应文件
- 生成项目结束前 → 检查所有对话约定都已持久化
- 交付前 → 在 `PROJECT_AUDIT.md` 中列出所有约定文件

---

## 5. 问题类型识别

- HFSP：混合流水车间，每个 Job 按固定 Stage 顺序加工，每个 Stage 有一组并行机
- FJSP：柔性作业车间，每道 Operation 可选机器，Job 内有工序顺序
- JSP：经典作业车间，每道工序有指定机器
- Parallel Machine Scheduling：并行机调度
- Resource-Constrained Scheduling：资源约束项目调度
- General MIP：无法归类时使用通用 MIP 框架

---

## 6. 用户需要提供什么

### 6.1 必需信息

1. 要安排的对象是什么
2. 安排到哪里
3. 顺序规则
4. 冲突规则
5. 加工时间
6. 优化目标

### 6.2 最低可建模描述

如果用户能说清以下 5 点，就可以开始生成项目：

```text
1. 要安排什么
2. 安排到哪些机器 / 资源
3. 每个任务需要多长时间
4. 哪些任务不能同时发生或必须按顺序发生
5. 优化什么目标
```

如果缺失关键信息，应输出补充问题模板。如果只缺少非关键细节，应继续生成，并明确默认假设。

---

## 7. 输出顺序

当用户要求"生成完整项目"时，按以下顺序输出：

1. 问题描述结构化分析（§4）
2. `configs/` 项目规范文档 + `problem_fingerprint.json`
3. 项目结构（顶层目录树）
4. `data/generate.py` + `data/loader.py`
5. demo 算例数据
6. `src/core/domain.py` 领域模型
7. `src/metaheuristics/encoding/` 编码方案
8. `src/metaheuristics/decoding/` 解码 + feasibility_checker + metrics + eval_cache + result_reproducer
8.5. `tests/smoke_test.py` 冒烟测试（生成后立即运行）
9. `src/metaheuristics/initial/` 初始化方法
10. `src/metaheuristics/neighborhood/` 邻域算子
11. 5 个 basic 算法（SA, MA, IG, GA, TS）——**每个算法必须使用 EvalCache(max_size=500, FIFO)**
12. `src/math_models/gurobi_model.py` + `lower_bound.py`
13. `src/visualization/` 可视化
14. `src/metaheuristics/registry.py` 算法注册表
15. `scripts/run_baselines.py` + sh 脚本
16. `scripts/mip/run_gurobi_mip.py`
17. `scripts/ablation/quick_test_config.py`
18. `tests/` 单元测试
19. `AGENTS.md`
19.5. `docs/YYYY-M-D_algorithm_design.md`（**必须记录 EvalCache 强制约定**）
20. `IMPLEMENTATION_STATUS.md`
21. `PROJECT_AUDIT.md`
22. `README.md`
23. 运行命令
24. 审计摘要

---

## 8. 不应做的事

1. 不要把所有代码写在一个文件中
2. 不要使用 CPLEX/docplex，默认使用 Gurobi
3. 不要让 MIP、decoder、baseline 各自读取不同格式的数据
4. 不要只输出数学模型而不输出代码
5. 不要只输出代码而没有 demo 算例
6. 不要在 `configs/` 放 JSON 配置文件（改为自然语言文档，`problem_fingerprint.json` 除外）
7. 不要在算例生成时传入 seed 参数
8. 不要在 `run_baselines.py` 中设置算法内部开关参数
9. 不要跳过消融实验直接纳入未验证的改进
10. 不要将实验输出写到项目外路径
11. 不要随意生成脚本，优先复用核心脚本
12. **txt 输出不要从 schedule 反推序列，必须保存算法返回的 best_seq**
13. **不要跳过 smoke 测试**
14. **不要让占位模块静默返回伪结果**，必须 raise NotImplementedError
15. **不要让 README 替代 docs/ 中的问题描述文档**
16. **不要在循环内频繁打印日志**，每行至少间隔 N 次迭代
17. **不要在 skill 中写死问题特定内容**（如 re-entry、人工资源等），应根据问题描述智能生成
18. **不要让对话约定停留在上下文中**：任何澄清、决策、默认假设、用户额外要求都必须持久化到 `docs/` 或 `configs/`
19. **不要在算法适配时把初始化写在算法主文件中**：初始化必须提取到 `src/metaheuristics/initial/single/` 或 `src/metaheuristics/initial/population/`（按用途）独立文件，主文件通过 import 调用
20. **不要混用单解生成器与种群生成器**：单解生成器（`initial/single/`，返回 `list[int]`）严禁用于 GA/MA 种群初始化；种群生成器（`initial/population/`，返回 `list[list[int]]`）严禁用于 SA/IG/TS
21. **不要在批量对比时让各算法用不同初始化/缓存**（除非明确要求）：`sh_batch_instances_algorithms.sh` 默认统一初始化 + 统一缓存（单解/种群各自统一）

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
24. **严禁为特殊情况打补丁**：遇到 bug、边界错误、测试失败时，**必须分析根因并修复设计/逻辑本身**，禁止添加局部补丁掩盖问题（详见 §8 代码质量红线）
25. **严禁兼容层（Backward-Compat Layer）**：接口/格式变更必须一次性迁移全部调用点，禁止保留旧接口 shim、DeprecationWarning、双路径分支、模块 alias、"过渡期"共存等破坏可读性的手段

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
19.6. `docs/root_cause_fix_log.md`（**严禁补丁，见 §8；生成时创建空模板供后续填写**）
20. `IMPLEMENTATION_STATUS.md`
21. `PROJECT_AUDIT.md`
22. `README.md`
23. 运行命令
24. 审计摘要

---

## 8. 代码质量红线

> **本节列出的行为在任何情况下都不得出现**。违反红线的代码即使能"跑通"，也必须重写。

### 8.1 严禁为特殊情况打补丁（核心红线）

> 遇到 bug、边界错误、测试失败、意外输入时，**必须分析根因并修复设计/逻辑本身**。禁止添加针对当前特殊情况的局部补丁掩盖问题。

**"打补丁"的典型反模式（严禁）**：

| 反模式 | 举例 | 正确做法 |
|--------|------|---------|
| **特殊值特判** | `if inst_name == "inst_003_20_5_01": return fixed_value` | 分析为什么该算例失败，修复根本原因（如数据加载、边界处理） |
| **异常静默吞掉** | `try: ... except: pass` / `except: return None` | 让异常暴露根因；只捕获**已知且可恢复**的特定异常类型 |
| **魔数硬编码回避 bug** | `if x < 0: x = 0` 掩盖上游算错负值的问题 | 修复上游产生负值的逻辑 |
| **随时间累积的 if-else** | `if condition_A: ... elif condition_B_from_last_bug: ... elif condition_C_from_new_bug: ...` | 重新设计控制流，或抽象为策略/多态 |
| **测试外套 skip** | `@pytest.mark.skip("暂时通不过")` | 修复被测代码，或删除失效测试 |
| **在调用方修复被调用方的问题** | 调用者手动处理被调函数返回的错误数据 | 修复被调函数，让它返回正确数据或抛出明确异常 |
| **for the sake of this instance** 的补丁 | 注释写"临时兼容 X"、"绕过 Y"、"暂时处理 Z" | 补丁不能存在。要么修根因，要么明确不修复并 raise |
| **注释掉失败代码继续跑** | `# schedule = decode(...) # 有 bug` + 用 mock 返回值 | 修复 decode，或者移除依赖它的功能 |
| **catch 后 log 继续** | `except Exception as e: print(e); continue` 让循环带病继续 | 让异常传播；或明确记录后**主动终止**该分支 |

### 8.2 严禁兼容层（Backward-Compat Layer）

> **兼容层严重破坏代码可读性**：同一功能有多个入口、旧接口用 shim 包装、双路径 if 分支、废弃代码堆积。**严禁**保留旧接口、旧参数、旧格式的兼容代码。

**兼容层的典型形式（严禁）**：

| 反模式 | 举例 | 正确做法 |
|--------|------|---------|
| **保留旧函数名 + shim** | `def old_name(*args, **kw): return new_name(*args, **kw)` | 直接删除 `old_name`，全项目替换调用点 |
| **DeprecationWarning 包装旧接口** | `def old_api(...): warnings.warn("use new_api"); return new_api(...)` | 直接删除 `old_api`，改所有调用 |
| **旧参数名 + 新参数名并存** | `def f(new_name=None, old_name=None): name = new_name or old_name` | 只保留 `new_name`，全项目改调用 |
| **双格式支持** | `if isinstance(seq, list): ... elif isinstance(seq, dict): ...` 支持新旧编码格式 | 只支持一种格式，旧格式一次性迁移或抛错 |
| **版本判断分支** | `if data.get("version") == "v1": ... else: ...` | 只支持当前版本；旧版本数据一次性迁移 |
| **模块级 alias** | `OldClass = NewClass` / `from new_mod import X as OldX` | 直接删除，改所有 import |
| **参数默认值维持旧行为** | `def f(strict=False)`：默认 False 保持旧行为，新代码传 `strict=True` | 默认值就是新行为；旧调用点显式改 |
| **旧路径 fallback** | `if not new_path.exists(): return read(old_path)` | 只读新路径；旧数据一次性迁移或删除 |

**为什么禁止**：

1. **可读性灾难**：读者不知道"哪个才是正确入口"，需要跨文件追踪 shim
2. **测试复杂度膨胀**：每条路径都需要覆盖，测试时间 ×2
3. **技术债永久化**：`# 保留 3 个版本后删除` 从未被删除
4. **正确性隐患**：新旧路径微小语义差异会引入难以复现的 bug
5. **破坏红线**：兼容层本质是"特殊情况打补丁"的批量版

**唯一正确的做法：一次性迁移**

```text
接口/格式变更需求
    ↓
【禁止】保留旧接口做 shim
    ↓
【必须】以下三选一：
    A. 全项目一次性搜索替换所有调用点（首选）
    B. 若数据格式变更，写一次性迁移脚本 migrate_vX_to_vY.py，运行后删除旧数据
    C. 若成本过高，明确放弃变更（记录到 docs/），保持旧设计
    ↓
【禁止】"过渡期"、"deprecation 期"、"两版本共存"
```

### 8.3 遇到问题时的强制流程

```text
出现 bug / 测试失败 / 意外行为
    ↓
【禁止】立即写 workaround 让代码 "跑起来"
    ↓
【必须】5-Why 根因分析：为什么出错？为什么该处逻辑允许出错？为什么设计允许这种输入？...
    ↓
【必须】判断根因位置：数据？模型？算法逻辑？边界条件？接口契约？
    ↓
【必须】在根因位置修复；如需修改契约（如函数签名、返回值语义），**同步更新所有调用方**
    ↓
【必须】添加回归测试（`tests/`）覆盖该场景，防止再次出现
    ↓
【必须】在 `docs/YYYY-M-D_algorithm_design.md` 或 `configs/conventions.md` 记录：
    - 根因是什么
    - 修复方式
    - 为什么这样修而不是打补丁
```

### 8.4 允许的例外与写法约定

只有以下情况允许"看起来像补丁"的代码，但必须**显式声明**：

| 情形 | 写法要求 |
|------|---------|
| 依赖外部库的已知 bug 且无法上游修复 | 顶部注释 `# UPSTREAM BUG: <link>`，且必须在 `docs/root_cause_fix_log.md` 记录 |
| 明确的"暂不支持"分支 | `raise NotImplementedError("<明确原因>")`，禁止静默 pass |
| 数值稳定性护栏（如浮点误差 < 1e-6） | 注释解释误差来源（如 `# floating-point epsilon`） |

> **注意**：不再列出"向后兼容"作为例外——**兼容层已被 §8.2 完全禁止**。接口变更必须一次性迁移。

> **通用判据**：如果补丁的注释里出现"临时"、"绕过"、"暂时"、"先这样"、"待重构"、"TODO 后面再修"、"兼容"、"deprecated"、"legacy"，几乎肯定是打补丁或兼容层——**必须重构或直接不修**。

### 8.5 code review 自检清单

写完代码后必须自问：

- [ ] 我加的这段 if / try / 特判，**根因是否已被修复**？如果不是，我在打补丁
- [ ] 我改的这段代码，**是否需要同步更新调用方或被调方**？如果不同步，我在打补丁
- [ ] 我的注释里是否有"临时/暂时/绕过/TODO 后修"？如果有，我在打补丁
- [ ] 我的注释里是否有"兼容/legacy/deprecated/保留旧接口"？如果有，我在建兼容层
- [ ] 我的 except 是否 catch 了 `Exception`/`BaseException`？如果是，几乎必然在打补丁
- [ ] 我的修改是否只针对某一个算例/输入？如果是，我在打补丁
- [ ] 我改动接口时，**是否直接删除了旧接口并全项目替换**？如果保留旧接口，我在建兼容层

### 8.6 审计与执行

- `PROJECT_AUDIT.md` 必须包含 **Code quality red-line check**：扫描 TODO/FIXME/临时/绕过/兼容/legacy/deprecated 等关键字，若出现在核心模块则审计失败
- 对话生成过程中，若用户或 AI 想用补丁或兼容层方式绕过问题，必须**先在对话中显式指出**这是打补丁/兼容层，并给出根因修复或一次性迁移方案供用户选择

---

## 9. 不应做的事

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
22. **严禁为特殊情况打补丁**（红线，详见 §8）：遇到 bug 必须找根因修复，禁止用特殊值特判、异常静默、临时 workaround、注释掉失败代码、pytest.skip 等方式绕过
23. **禁止 `except Exception: pass` 和 `except: pass`**：只能 catch 已知且可恢复的特定异常类型
24. **禁止在注释中使用"临时"、"暂时"、"绕过"、"待重构"字样**留下技术债——要么现在修根因，要么明确 `raise NotImplementedError` 并记录到 `docs/`
25. **严禁兼容层**（红线，详见 §8.2）：接口变更必须一次性删除旧接口并全项目替换调用点。禁止保留旧函数名 shim、`DeprecationWarning` 包装、旧参数/新参数并存、模块 alias（`OldClass = NewClass`）、格式版本判断分支、旧路径 fallback 等
26. **禁止在注释中使用"兼容"、"legacy"、"deprecated"、"保留旧接口"、"过渡期"、"两版本共存"字样**——一旦出现即意味着建立了兼容层

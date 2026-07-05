# MIP / HFSP 项目生成器 Skill

## 1. Skill 定位

本 Skill 用于根据用户提供的调度、排产、资源分配或组合优化问题描述，生成一套可运行、可验证、可扩展、面向论文的 Python 研究工程。

重点支持：

- HFSP：Hybrid Flow Shop Scheduling Problem，混合流水车间调度；
- FJSP / JSP / Parallel Machine Scheduling 的扩展；
- MIP 建模（**Gurobi** 实现）；
- txt 主体数据 + index.json 串联；
- demo / small / large 三级算例生成；
- 编码、解码、增量评估、计算缓存、可行性校验；
- 元启发式算法（SA / MA / IG / GA / TS）+ 论文对比 baselines；
- 三层脚本体系（single / bench / batch）+ 分析 + DOE + 消融 + 统计检验；
- 甘特图、收敛曲线、ARPD 图；
- 论文写作（LaTeX）；
- 后续扩展运输资源、人力资源、换线时间、时间窗、维护窗口等约束。

> **权威结构规范**：项目结构严格遵循 `项目通用结构总结.md`，本 SKILL.md 为其可执行映射。

本 Skill 不应只输出单个脚本，而应输出结构化项目工程。

---

## 2. 触发场景

当用户提出以下任一需求时，应使用本 Skill：

- 根据问题描述生成调度 / 排产 / 资源分配 Python 项目；
- 需要 MIP 模型代码（Gurobi）；
- 需要 demo / small / large 算例生成；
- 需要编码、解码、元启发式算法；
- 需要 baseline 对比算法；
- 需要与 MIP 结果对比；
- 需要甘特图或实验可视化；
- 需要批量实验脚本（single / bench / batch）；
- 需要消融实验、DOE、统计检验；
- 明确提到 HFSP、FJSP、JSP、并行机、车间调度、工序调度、资源约束调度。

---

## 3. 总体执行原则

必须遵守以下原则（源自 `项目通用结构总结.md` 第 0 节）：

1. **可复现**：确定性种子、确定性输出、结果可从 txt 序列复现并校验
2. **可扩展**：算法注册制，新增算法只需注册到 `run_baselines.py`
3. **分层清晰**：数据层、求解层、评估层、输出层、分析层各自独立
4. **面向论文**：所有实验设计围绕论文需求（对比、消融、DOE、统计检验）
5. **禁止随意生成脚本**：优先复用核心脚本（single / bench / batch / analysis）
6. **加速评估**：增量评估 + 计算缓存（FIFO 队列，大小限制 500）避免重复解码，控制内存占用
7. **改进必须消融**：每一次算法组件改进（新增邻域、接受准则、初始化策略等）都必须进行消融实验，量化改进程度（正或负），并撰写完整的消融实验记录文档
8. **组件测试配置**：消融实验取每个规模算例的**第一个**作为测试算例，使用固定种子，repeat=3
9. **输出隔离**：所有实验输出仅限项目内 `outputs/` 目录，禁止输出到项目外路径
10. **执行安全**：预估耗时超过 1 小时的任务必须后台运行（`nohup`/`&`），并提供 `tail -f` 日志跟踪命令
11. 代码优先，解释为辅
12. demo 算例必须能够跑通
13. 主体数据优先保存为 txt，json 只用于索引、配置或结构化结果
14. **MIP 默认使用 Gurobi**（`gurobipy`），不再使用 CPLEX/docplex
15. 项目必须模块化，不能把所有代码堆在 src 根目录
16. MIP、decoder、baseline、元启发式算法必须共用同一个 Instance 数据对象
17. 所有算法输出必须统一为 Schedule / Result 格式
18. 所有结果必须经过 `check_feasibility` 和 metrics evaluation
19. 如果问题描述不完整，应先给出"缺失信息清单"和"默认假设"，但不因为非关键缺失停止生成

---

## 4. 问题类型识别

生成项目之前，必须先识别 problem_type：

- HFSP：混合流水车间，每个 Job 按固定 Stage 顺序加工，每个 Stage 有一组并行机；
- FJSP：柔性作业车间，每道 Operation 可选机器，Job 内有工序顺序；
- JSP：经典作业车间，每道工序有指定机器；
- Parallel Machine Scheduling：并行机调度；
- Resource-Constrained Scheduling：资源约束项目调度；
- General MIP：无法归类时使用通用 MIP 框架。

---

## 5. 用户需要提供什么

### 5.1 必需信息

1. 要安排的对象是什么：Job、Order、Task、Operation、Vehicle、Resource 等
2. 安排到哪里：Machine、Stage、Worker、Transporter、Line、Station 等
3. 顺序规则：Job 内是否按 Stage / Operation 顺序执行
4. 冲突规则：同一机器同一时间是否只能加工一个任务
5. 加工时间：由 Job 决定、Stage 决定、Machine 决定，还是三者共同决定
6. 优化目标：makespan、total tardiness、total cost、flow time、weighted objective 等

### 5.2 推荐补充信息

1. 是否有 release time
2. 是否有 due date
3. 是否允许等待
4. 是否允许抢占
5. 是否允许机器选择
6. 每个 Stage 有几台机器
7. 是否有 setup time
8. 是否有 transport time
9. 是否有人力资源约束
10. 是否有机器维护窗口
11. 是否有批处理或容量约束
12. 数据规模
13. 目标函数权重
14. 希望对比哪些 baseline
15. 本文算法的初步想法

### 5.3 最低可建模描述

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

## 6. 顶层目录结构

生成项目时**严格**使用以下结构（源自 `项目通用结构总结.md` 第 1 节）：

```text
project_name/
├── configs/                    # 自然语言项目规范与要求
├── data/                       # 数据层：生成、读取、算例
│   ├── generate.py             # 数据生成入口
│   ├── loader.py               # 数据读取（load_instance）
│   ├── demo/                   # 展示用算例（含网络图、可视化）
│   ├── small/                  # 小规模基准算例
│   ├── large/                  # 大规模基准算例
│   └── batch_seeds/            # 批量测试确定性种子表
├── docs/                       # 文档（前缀加日期：YYYY-M-Dxxx.md）
├── src/                        # 源代码核心
│   ├── core/                   # 领域模型（Instance, Schedule, Result）
│   ├── math_models/                # MIP / CP 建模（Gurobi 实现）
│   ├── metaheuristics/         # 元启发式算法
│   │   ├── initial/            # 初始化方法
│   │   ├── encoding/           # 编码方案（多套）
│   │   ├── decoding/           # 解码方案（多套）+ 增量评估 + 结果校验
│   │   ├── neighborhood/       # 邻域算子
│   │   ├── baselines/          # 论文正式对比算法
│   │   ├── sa/                 # 模拟退火
│   │   ├── ma/                 # 模因算法
│   │   ├── ig/                 # 迭代贪心
│   │   ├── ga/                 # 遗传算法
│   │   └── ts/                 # 禁忌搜索
│   ├── visualization/          # 甘特图、收敛曲线、网络图
│   ├── ExperimentAnalysis/     # 实验结果分析（自行提供，不实现）
│   └── common/                 # 通用工具
├── scripts/                    # 执行脚本
│   ├── run_baselines.py        # 中央调度枢纽（唯一 Python 入口）
│   ├── sh_single_instance.sh   # 单算例 · 单算法
│   ├── sh_bench_instance.sh    # 单算例 · 多算法对比
│   ├── sh_batch_instances_algorithms.sh  # 全量批量 · 多轮
│   ├── sh_analysis.sh          # 通用结果分析
│   ├── mip/                    # Gurobi MIP 独立入口
│   ├── doe/                    # DOE 参数校核实验
│   ├── ablation/               # 消融实验脚本
│   └── statistics/             # 非参数检验
├── tests/                      # 单元测试
├── outputs/                    # 所有实验输出
├── latex/                      # 论文写作
│   ├── els-cas-templates/      # Elsevier CAS 模板
│   └── ...                     # 其他期刊模板
├── requirements.txt
├── AGENTS.md                   # 项目记忆索引
└── README.md
```

### 6.1 禁止生成的无用目录

以下目录在新项目模板中**已移除**，禁止生成：

| 路径 | 原因 |
|------|------|
| `src/utils/` | 空壳目录，通用工具移至 `src/common/` |
| `src/constraints/` | 约束检查在 `decoding/feasibility_checker.py` |
| `src/resources/` | 空壳目录 |
| `src/problems/` | 问题逻辑合并到 `src/core/` |
| `src/io/` | 数据读取迁移到 `data/loader.py` |
| `src/solvers/` | MIP 建模迁移到 `src/math_models/` |
| `src/algorithms/proposed/` | 被 `metaheuristics/` 下各算法目录替代 |
| `src/algorithms/` | 整个目录替换为 `src/metaheuristics/` |
| `src/evaluation/` | 评估逻辑迁移到 `src/metaheuristics/decoding/` |
| `configs/*.json` | configs/ 改为存放自然语言文档 |

---

## 7. 数据层（`data/`）

### 7.1 目录结构

```text
data/
├── generate.py             # 数据生成入口
├── loader.py               # 数据读取（load_instance）
├── demo/                   # 展示用算例
│   └── demo_01_n_m/        # 命名: demo_0x_n_m
│       ├── *.txt           # 算例数据文件
│       ├── index.json      # 文件索引
│       └── *.png / *.pdf   # 可视化图（demo 专属）
├── small/                  # 小规模基准算例
│   └── inst_xxx_n_m_yy/    # 命名: inst_xxx_n_m_yy
├── large/                  # 大规模基准算例
│   └── inst_xxx_n_m_yy/
└── batch_seeds/            # 统一种子文件
    ├── small/
    │   ├── seed_table.json # 种子主表
    │   └── round{r}.json   # 每轮种子映射
    └── large/
        ├── seed_table.json
        └── round{r}.json
```

### 7.2 数据生成 — `data/generate.py`

- 定义 demo / small / large 三种规模的参数组合
- 每个规模组合生成指定数量的算例
- 算例命名：demo 用 `demo_0x_n_m`，正式算例用 `inst_xxx_n_m_yy`
- **不在算例生成时传入 seed 参数，不写入 index.json**
- `index.json` 仅记录文件索引和问题元信息

### 7.3 数据读取 — `data/loader.py`

统一接口：`load_instance(dir) -> Instance`

### 7.4 demo 算例的特殊性

1. 额外生成可视化（前序网络图、操作关系图等）
2. 运行时输出甘特图 + 排程 JSON + 详细日志
3. 不参与批量统计（不进入 ARPD 计算）
4. 规模小，便于人工验证

### 7.5 统一种子管理

测试阶段读取统一的种子文件，与算例生成解耦：

- `data/batch_seeds/{scale}/seed_table.json` — 种子主表（算例名 → seed）
- `data/batch_seeds/{scale}/round{r}.json` — 每轮种子映射
- 种子源：`random.Random(20260616 + sum(ord(c) for c in scale))`
- 单次运行无指定 seed 时默认 `secrets.randbits(32)`

---

## 8. 源代码层（`src/`）

### 8.1 `src/core/` — 领域模型

核心数据结构，被所有模块共享：

```python
@dataclass
class Instance:          # 算例数据（工时、机器、前序关系等）
@dataclass
class Schedule:          # 排程结果（操作列表、目标值）
@dataclass
class Result:            # 完整结果（方法、状态、目标值、运行时间、排程）
@dataclass
class Operation:         # 单个操作（作业、阶段、机器、开始/结束时间）
@dataclass
class PrecedenceArc:     # 前序弧
```

### 8.2 `src/math_models/` — MIP / CP 建模（Gurobi）

> 不再放在 `solvers/` 下，直接作为 `src/` 下的一级目录。

- **MIP**：用 Gurobi 实现，建模文件 `gurobi_model.py`
- **CP**：如需实现，放同一目录下
- **下界计算**：`lower_bound.py`（快速下界 + 精确下界）
- **结果校核**：MIP 求解后必须调用 `check_feasibility(instance, schedule)` 验证约束满足

**Gurobi 测试要求**：
- 输出 **LB（下界）** 和 **规定时间内的最优可行解**
- 默认时限 **3600 秒**（正式实验），小规模测试 60s
- 输出 `result.json`（含 status, objective, LB, gap, runtime, violations）+ `schedule.csv` + `gantt.png`

### 8.3 `src/metaheuristics/` — 元启发式算法

> 目录名不用 `algorithms`，因为研究范围涵盖精确算法、启发式、元启发式、强化学习、LLM 辅助设计等多种方法。

#### 目录结构

```text
src/metaheuristics/
├── initial/              # 初始化方法
│   ├── dispatching.py    # 调度规则初始化（SPT, LPT 等）
│   ├── neh.py            # NEH 启发式
│   ├── random_init.py    # 随机初始化
│   └── topological.py    # 拓扑排序初始化
├── encoding/             # 编码方案（多套）
│   ├── sequence_encoding.py        # 置换序列编码
│   ├── machine_order_encoding.py   # 机器顺序编码
│   └── ...                         # 其它编码（按需扩展）
├── decoding/             # 解码方案（多套）+ 评估校验
│   ├── list_decoder.py             # 列表解码
│   ├── block_decoder.py            # 分块解码
│   ├── incremental_eval.py         # 增量评估（加速解码方法）
│   ├── eval_cache.py               # 计算缓存（FIFO 队列，限制大小 500）
│   ├── feasibility_checker.py      # 可行性检查
│   ├── metrics.py                  # 目标值计算（Cmax 等）
│   └── result_reproducer.py        # 从 txt 序列复现目标值并校验
├── neighborhood/         # 邻域算子
│   ├── operators.py                # 邻域算子定义与实现
│   ├── critical_path.py            # 关键路径相关邻域
│   ├── frameworks.py               # 邻域选择框架（VNS / ALNS / 随机均匀等）
│   └── structure_context.py        # 结构上下文缓存
├── baselines/            # 论文正式对比算法（文献复现）
├── sa/                   # 模拟退火 (SA)
├── ma/                   # 模因算法 (MA)
├── ig/                   # 迭代贪心 (IG)
├── ga/                   # 遗传算法 (GA)
└── ts/                   # 禁忌搜索 (TS)
```

> **evaluation 与 decoding 的关系**：可行性检查、目标值计算、结果复现都依赖解码逻辑，因此 evaluation 相关文件**放在 `decoding/` 目录下**，与解码器紧密耦合。

#### `decoding/` 详细说明

| 文件 | 职责 |
|------|------|
| `list_decoder.py` 等 | 各套解码器，将编码转化为可行排程并计算目标值 |
| `incremental_eval.py` | 增量评估，在邻域搜索中避免全量重解码 |
| `eval_cache.py` | 计算缓存，FIFO 队列保存编码→目标值映射，**队列大小限制 500** |
| `feasibility_checker.py` | `check_feasibility(instance, schedule) -> violations` |
| `metrics.py` | 目标值计算（Cmax 等） |
| `result_reproducer.py` | 从 txt 输出的序列复现目标值，并校验约束条件 |

#### `neighborhood/` — 邻域算子

集中管理所有邻域移动操作，供 SA / IG / MA / GA / TS 等算法共享调用。

```text
src/metaheuristics/neighborhood/
├── operators.py              # 邻域算子定义与实现
├── critical_path.py          # 关键路径相关邻域
├── frameworks.py             # 邻域选择框架（VNS / ALNS / 随机均匀等）
└── structure_context.py      # 结构上下文缓存
```

邻域选择框架：

| 框架 | 说明 |
|------|------|
| `VnsState` | 变邻域搜索：按固定顺序 N1→NK 遍历，接受最优改进时回 N1 |
| `UniformRandomState` | 均匀随机选择：所有算子等概率 |
| `AlnsState` | 自适应大邻域搜索：根据算子历史表现动态调整权重 |

#### 新问题默认实现

对于新问题，默认实现以下 **5 个基础元启发式**：

| 算法 | 目录 | 说明 |
|------|------|------|
| SA | `sa/` | 模拟退火 |
| MA | `ma/` | 模因算法 |
| IG | `ig/` | 迭代贪心 |
| GA | `ga/` | 遗传算法 |
| TS | `ts/` | 禁忌搜索 |

### 8.4 `src/visualization/` — 可视化

| 文件 | 职责 |
|------|------|
| `gantt.py` | 甘特图绘制 |
| `gantt_plotter.py` | 甘特图高级封装（自行提供，不实现） |
| `convergence.py` | 收敛曲线绘制 |
| `nest_lot_graph.py` | 前序网络图（由问题决定是否需要） |

### 8.5 `src/ExperimentAnalysis/` — 实验结果分析

> **自行提供，不实现**。保留目录结构，具体内容由使用者手动提供。

### 8.6 `src/common/` — 通用工具

| 文件/子目录 | 职责 |
|------------|------|
| `plot_converge.py` | 收敛曲线绘图工具 |
| `plot_heat/xlsx_heatmap.py` | 从 xlsx 数据生成热力图 |
| `picture_config/` | 绘图配色方案与调色板配置 |
| `hfsp_benchmark_2021.py` | 基准算例工具 |

---

## 9. `configs/` — 项目规范与要求

`configs/` 存放**自然语言描述的项目规范与要求**文档（不再放 JSON 配置）：

| 文件 | 内容 |
|------|------|
| `problem_statement.md` | 问题描述：业务背景、调度对象、目标函数 |
| `constraints_spec.md` | 约束规范：所有约束的数学描述与自然语言解释 |
| `algorithm_requirements.md` | 算法要求：需要实现哪些算法、各算法的设计要求 |
| `experiment_plan.md` | 实验计划：对比实验设计、算例规模、评价指标 |

---

## 10. 算法命名、分支与注册规范

### 10.1 算法命名层级

算法命名遵循 **`{父算法}_{变体}`** 模式，分为三个层级，**子算法必须带父算法名作为前缀**：

| 层级 | 命名示例 | 说明 |
|------|---------|------|
| **basic** | `sa_basic`, `ig_basic`, `ma_basic` | 最基础实现，是 study 的起点 |
| **study** | `sa_basic_study`, `ig_basic_study` | 在 basic 基础上完善的研究版本，命名带 `basic` 前缀 |
| **branch** | `sa_basic_study_conditioned`, `sa_basic_study_qlig` | 基于 study 的改进分支，命名带完整父链前缀 |

### 10.2 算法分支树状结构

算法演进呈现**树状结构**，每个子节点必须带父节点名作为前缀，以清晰体现继承关系：

```text
sa_basic (基础 SA)
  └── sa_basic_study (研究版 SA，完善邻域、冷却、接受准则)
        ├── sa_basic_study_conditioned (条件化邻域分支)
        ├── sa_basic_study_qlig (Q-Learning 引导分支)
        ├── sa_basic_study_split4 (四序列分支)
        └── ... (更多分支)

ig_basic (基础 IG)
  └── ig_basic_study (研究版 IG)
        ├── ig_basic_study_tour_inc (锦标赛插入分支)
        ├── ig_basic_study_no_hamming (关闭 Hamming 分支)
        └── ...
```

**命名规则**：
- **basic**：`{algo}_basic`，最小可运行实现，验证基本框架正确性
- **study**：`{algo}_basic_study`，在 basic 基础上完善各组件，作为后续分支的统一基础
- **branch**：`{algo}_basic_study_{branch_name}`，基于 study，通过开关组合不同策略，**每个分支用一个独立文件固化开关选择**
- 消融变体：`{algo}_basic_study_{branch_name}_no_{component}`（关闭组件）、`{algo}_basic_study_core{N}`（只保留前 N 个组件）

### 10.3 分支管理规范

> **核心原则**：分支的开关选择固化在分支自己的文件中，**不在 `run_baselines.py` 中设置开关**。

1. **study 文件**提供可配置的开关参数
2. **branch 文件**继承 study 的框架，在文件内部固化特定的开关组合
3. **branch 注册到 `run_baselines.py`**：与 basic/study 一样走 5 步注册流程
4. **`run_baselines.py` 不设开关**：中枢只负责调度

### 10.4 算法注册步骤（`run_baselines.py`）

所有算法（basic / study / branch / baselines）必须注册：

1. 在 `ALGO_XXX` 常量区添加算法标识
2. 在 `ALGO_INFO` 添加 `AlgoInfo(name, short_name, full_name, zh_name, comment)` 元数据
3. 在 `ALGO_DEFAULTS` 添加默认参数
4. 在 `_get_solver()` 添加 solver 函数映射（elif 分支）
5. 在 `elif algo in (...)` 分支条件加入算法标识

### 10.5 组件改进消融实验规范

> **强制要求**：每一次算法组件改进都必须进行消融实验，量化改进程度，并撰写完整的消融实验记录文档。未经消融验证的改进不得纳入正式版本。

#### 设计目的

算法改进过程中，验证某组件是否优于改进前时，**不想用所有算例来测试**（耗时过长）。因此用每个规模的**第一个**算例进行快速验证。这套规则已固化为 `scripts/ablation/quick_test_config.py`，默认作为所有小实验（消融、DOE、参数扫描）的算例数据来源，避免每次手动指定算例和种子。

#### 测试配置

| 配置项 | 规定 | 说明 |
|--------|------|------|
| 测试算例 | 每个规模的**第一个**算例 | 如 small 取 `inst_001_10_5_01`，large 取 `inst_001_50_5_01` |
| 种子 | 固定种子（seed=1,2,3） | 从 `data/batch_seeds/` 读取或直接指定 |
| 重复次数 | repeat=3 | 每个算例 × 每个种子运行 3 次 |
| 时间限制 | `N_jobs * M_stages * factor` | factor=0.05，与正式实验一致 |

此配置固化为 `scripts/ablation/quick_test_config.py`。

#### 消融实验原始结果输出目录

消融实验的**原始运行结果**也放进 `outputs/`，目录命名规范：

```
outputs/ablation/{algo}/{ablation_name}/
  raw/                                    # 原始运行结果（每个 算例×种子×重复）
    {instance}_{seed}_{repeat}/
      {algo_variant}_result.json
      {algo_variant}_schedule.json
      {algo_variant}_trace.csv
      {algo_variant}_gantt.png
  comparison.xlsx                         # 对比表（best/avg/std）
  arpd.png                                # ARPD 图
```

其中 `{ablation_name}` 命名为 `{branch_name}_vs_{baseline}` 或 `{branch_name}_no_{component}`。

#### 消融实验记录文档

每次消融实验必须撰写完整的记录文档（md 文件），存放于算法目录下（如 `src/metaheuristics/ig/消融实验记录.md`）。文档结构：

```markdown
# {算法名} 消融实验记录

## 组件总览
| # | 组件 | 说明 | 参数与取值 |

## 组件 N: {组件名}
### 机制描述
### 参数
### 消融结果
### 结论（正收益/负收益/中性，是否保留）

## 综合效果
## 实验脚本（附录，含双链到脚本索引）
```

---

## 11. 脚本层（`scripts/`）

### 11.1 架构总览

```
sh_single_instance.sh  ─┐  (单算例 · 单算法)
sh_bench_instance.sh   ─┼──> run_baselines.py ──> src/metaheuristics/*
sh_batch_instances_*.sh ─┘  (全量 · 多轮)       ──> src/math_models/*

scripts/mip/run_gurobi_mip.py ──> src/math_models/* (精确求解, 独立入口)
```

所有脚本共享同一数据管线：

```
load_instance(dir) ──> solve(instance, time_limit, seed) ──> (Schedule, trace, best_seq) ──> check_feasibility ──> write_artifacts
```

### 11.2 核心脚本

#### `run_baselines.py` — 中央调度枢纽

**职责**：注册全部算法，解析算例目录，`ProcessPoolExecutor` 并行调度，统一写产物。

**输出（每个 算例 × 算法）**：

```
{out}/{instance}/{algo}_result.json      # Result(method, status, makespan, runtime, extra{seed})
{out}/{instance}/{algo}_schedule.json    # 完整排程 (operations 列表)
{out}/{instance}/{algo}_trace.csv        # 迭代收敛 (iteration, time, objective)
{out}/{instance}/{algo}_gantt.png        # 甘特图
{out}/convergence.json                   # 汇总收敛数据
```

txt 模式额外产出：`{txt_out}/{algo}.txt`

> **txt 序列来源**：txt 保存的序列必须是算法运行过程中的 **best_seq（最优编码序列）**，直接从算法返回值中获取，**不是从 schedule 反推的结果**。算法函数返回值必须包含 best_seq。

**算法返回值签名**：

```python
def solve_xxx(instance, time_limit, seed, **kwargs) -> tuple[Schedule, list, dict]:
    """
    Returns:
        schedule: Schedule 对象（排程结果）
        trace: list[tuple] 收敛轨迹 [(iteration, time, objective), ...]
        best_seq: dict 最优编码序列，格式由编码方案决定，例如:
            {"job_sequence": [0, 3, 1, ...], "machine_assignment": {(j,s): m, ...}}
    """
```

**txt 文件格式**（保存 best_seq）：

```text
# job_sequence
0 3 1 2 4 5 6 7 8 9
# machine_assignment (job_id stage_id machine_id)
0 0 1
0 1 0
1 0 0
...
```

#### `sh_single_instance.sh` — 单算例 · 单算法

```bash
bash scripts/sh_single_instance.sh --inst <算例名|路径> --algo <算法名> [--time N] [--seed N] [--verbose 1]
```

**必须输出** `schedule.json` 和 `gantt.png`。

#### `sh_bench_instance.sh` — 单算例 · 多算法对比

```bash
bash scripts/sh_bench_instance.sh [算例路径|N_M_K|N_M] [算法1 算法2 ...]
```

#### `sh_batch_instances_algorithms.sh` — 全量批量 · 多轮

```bash
bash scripts/sh_batch_instances_algorithms.sh [small|large|all] [time_factor]
```

**固定模式**：
- 7 轮循环，已有 `round{r}/` 数据则跳过（断点续跑）
- 种子源：`random.Random(20260616 + sum(ord(c) for c in scale))`
- 时间公式：`time = N_jobs * M_stages * factor`，factor 默认 `0.05`（单）/ `0.1`（批量）
- 并行：`ProcessPoolExecutor` + `--workers`，大规模 `W=2`，小规模 `W=4`

#### `sh_analysis.sh` — 通用结果分析

```bash
bash scripts/sh_analysis.sh <结果目录> [--standard auto|none|xlsx] [--profile auto] [--no-plots]
```

### 11.3 MIP 脚本（`scripts/mip/`）

| 脚本 | 职责 |
|------|------|
| `run_gurobi_mip.py` | Gurobi MIP 精确求解（单算例），默认时限 60s |
| `run_gurobi_mip_small.py` | 小规模批量求解 |
| `calc_lower_bounds.py` | 下界计算 |
| `tune_gurobi_mip_params.py` | Gurobi 参数调优 |
| `reproduce_mip_with_decode.py` | MIP 结果解码复现 |
| `compare_mip_solvers.py` | 多求解器对比 |

### 11.4 扩展实验脚本

#### DOE 参数校核（`scripts/doe/`）

| 脚本 | 职责 |
|------|------|
| `run_doe.py` | DOE 实验入口 |
| `sh_doe.sh` | DOE 批量脚本 |

#### 消融实验（`scripts/ablation/`）

| 脚本 | 职责 |
|------|------|
| `quick_test_config.py` | 固化小实验默认配置：每规模第一个算例 + 固定种子 + repeat=3 |
| `run_ablation.py` | 消融实验入口，读取 `quick_test_config` 配置 |

#### 非参数检验（`scripts/statistics/`）

- Friedman 检验、Wilcoxon 秩和检验、Holm/Hochberg 校正
- 输出 p 值矩阵 + 临界差图（CD diagram）

---

## 12. 输出目录规范（`outputs/`）

所有实验输出统一放在 `outputs/` 下：

```
outputs/
├── single_{INST}_{ALGO}/              # single 脚本输出
├── bench_{INST}/                      # bench 脚本输出
├── batch/
│   └── {batch_name}/                  # batch 脚本输出
│       ├── round{r}/{scale}/          # 每轮产物
│       └── txt/{scale}/{algo}.txt     # 汇总 txt（保存 best_seq）
├── mip/                               # MIP 求解输出
├── doe/{algo}/{param_name}/           # DOE 输出
├── ablation/{algo}/{ablation_name}/   # 消融实验输出
│   ├── raw/                           # 原始运行结果（算例×种子×重复）
│   │   └── {instance}_{seed}_{repeat}/
│   ├── comparison.xlsx                # 对比表（best/avg/std）
│   └── arpd.png                       # ARPD 图
├── statistics/{experiment_name}/      # 统计检验输出
└── lower_bounds_all/                  # 下界计算结果
```

---

## 13. 文档规范（`docs/`）

- 文件名前缀加日期：`YYYY-M-D主题.md`
- 示例：`2026-6-2problem_interpretation.md`、`2026-5-31mip_formulation.md`
- 常见文档类型：问题解释、数据格式规范、数学模型、算法设计、扩展计划

---

## 14. 论文写作（`latex/`）

```
latex/
├── els-cas-templates/          # Elsevier CAS 模板
├── {project_name}_bundle/      # 当前论文工作目录
│   ├── {project_name}.tex      # 主文件
│   ├── {project_name}_refs.bib # 参考文献
│   ├── figures/                # 论文用图
│   ├── tables/                 # 论文用表
│   └── notes/                  # 写作笔记
└── 论文写作参考.pdf             # 参考论文
```

### 14.1 写作 Skill 调用

论文写作应调用项目中的写作 Skill 来完成初稿，写作 Skill 位于 `thirdPartSkills.md` 中定义。以下章节由写作 Skill 辅助生成初稿：

| 章节 | 写作 Skill | 说明 |
|------|-----------|------|
| 引言 (Introduction) | 调用 `thirdPartSkills.md` 中的写作 skill | 基于问题描述和文献矩阵生成引言初稿 |
| 相关工作 (Related Work) | 调用 `thirdPartSkills.md` 中的写作 skill | 基于文献矩阵组织相关工作综述 |
| 问题描述 (Problem Description) | 调用 `thirdPartSkills.md` 中的写作 skill | 基于 `configs/problem_statement.md` 和 `configs/constraints_spec.md` 生成 |

### 14.2 文献矩阵要求

文献矩阵使用 `literature-matrix-review-skill-v2.1`，要求生成**两类文献矩阵**：

| 类型 | 说明 | 用途 |
|------|------|------|
| **广泛搜索矩阵** | 现有文献的广泛搜索，包含关联度等级 | 用于引言和相关工作综述，展示研究领域的全貌 |
| **紧密相关矩阵** | 与本问题紧密相关的文献 | 可直接放入论文中的**比较表格**，用于对比本文方法与已有方法 |

**广泛搜索矩阵**要求：
- 搜索范围覆盖问题领域的主要文献
- 每篇文献标注关联度等级（高/中/低）
- 按主题分类组织

**紧密相关矩阵**要求：
- 仅包含与本文问题直接相关的文献
- 包含可直接对比的维度（问题规模、算法类型、目标函数、约束类型等）
- 可直接转为论文中的比较表格（Table）

---

## 15. AGENTS.md — 项目记忆索引

每个项目根目录下必须有 `AGENTS.md`，作为项目约定的持久化记录。

内容包括：

| 章节 | 内容 |
|------|------|
| **脚本约定** | 核心脚本关键词映射表（batch/single/bench/analysis → 脚本路径），使用规则 |
| **算法注册** | 注册入口（`run_baselines.py`），注册步骤 |
| **维护规则** | 新增约定时同步更新本文件、删除过时条目 |

---

## 16. 实验设计体系

| 实验类型 | 说明 |
|---------|------|
| **对比实验（batch）** | 多算法 × 多算例 × 多轮（默认 7 轮），指标 ARPD |
| **消融实验（ablation）** | 组件级消融，每次改进必须消融，每规模第一个算例，repeat=3 |
| **参数校核（DOE）** | 因子筛选 + 参数调优 + 验证 |
| **统计检验（statistics）** | Friedman + Wilcoxon + Holm 校正 + CD diagram |
| **MIP 基准** | 小规模精确求解（3600s），输出 LB + 最优解，计算 Gap |

---

## 17. 固定模式总结

| 要素 | 固定模式 |
|------|----------|
| **数据层** | `load_instance(dir) -> Instance`；算例目录含标准 txt 文件集 + `index.json` |
| **数据生成** | `data/generate.py`，不在算例生成时传 seed，不写入 index.json |
| **数据读取** | `data/loader.py`，统一 `load_instance` 接口 |
| **种子管理** | 测试阶段读取统一种子文件 `data/batch_seeds/`，与算例生成解耦 |
| **求解层** | 每个算法签名: `solve_xxx(instance, time_limit, seed, **kwargs) -> (Schedule, trace_list, best_seq)` |
| **评估层** | `check_feasibility(instance, schedule) -> violations`，放在 `decoding/` 下 |
| **计算缓存** | `decoding/eval_cache.py`，FIFO 队列，**队列大小限制 500** |
| **输出层** | 固定四件套: `result.json` / `schedule.json|csv` / `trace.csv` / `gantt.png` |
| **txt 序列** | 保存 **best_seq**（算法返回的最优编码序列），不从 schedule 反推 |
| **结果复现** | 从 txt 读取 best_seq → 解码 → 计算目标值 → 校验约束 |
| **三层脚本** | `sh_single` (单×单) → `sh_bench` (单×多) → `sh_batch` (全×多轮)；共享 `run_baselines.py` |
| **MIP 独立** | `mip/run_gurobi_mip.py` 独立入口，不走 `run_baselines.py`；输出 LB + 最优解；3600s 时限；结果校核 |
| **时间公式** | `time = N_jobs * M_stages * factor`，factor 默认 `0.05`（单）/ `0.1`（批量） |
| **并行** | `ProcessPoolExecutor` + `--workers`，大规模 `W=2`，小规模 `W=4` |
| **断点续跑** | batch 脚本检测 `round{r}/` 目录非空则跳过该轮 |
| **文档命名** | `docs/` 下文件前缀加日期 `YYYY-M-D` |
| **算法命名** | basic → study → branch 三级；**子算法带父算法前缀**（如 `sa_basic_study_conditioned`）；分支用独立文件固化开关 |
| **算法注册** | 必须注册到 `run_baselines.py`（5 步注册流程）；开关不在中枢设置 |
| **消融实验** | 每次改进必须消融；每规模取第一个算例（快速验证），固定种子，repeat=3；原始结果存 `outputs/ablation/{algo}/{name}/raw/` |
| **默认算法** | 新问题默认实现 SA, MA, IG, GA, TS 五个基础元启发式 |
| **邻域算子** | `metaheuristics/neighborhood/` 集中管理 |
| **实验体系** | 对比(batch) + 消融(ablation) + DOE + 统计检验 + MIP 基准 |
| **论文** | `latex/` 含期刊模板 + 项目论文工作目录 |
| **项目记忆** | `AGENTS.md` 作为项目约定持久化记录 |
| **smoke 测试** | 生成后立即运行 `tests/smoke_test.py`，验证核心链路 |
| **解码器接口** | 相似解码器输入输出一致；seq 与 seq_machine 不强制一致 |
| **算法打印** | `[algo_name]` 前缀，verbose 分级（0 静默 / 1 启动结束 / 2 进度） |
| **收敛曲线** | trace.csv: (iteration, time, objective)；200 DPI，图例，网格 |
| **默认求解器** | **Gurobi**（`gurobipy`），不再使用 CPLEX/docplex |

---

## 18. MIP 建模默认方案（Gurobi）

对于基础 HFSP，默认变量包括：

```text
S[j, s]        Job j 在 Stage s 的开始时间
C[j, s]        Job j 在 Stage s 的完工时间
x[j, s, m]     Job j 在 Stage s 是否分配给该 Stage 的机器 m
y[i, j, s, m]  在 Stage s 的机器 m 上，Job i 是否排在 Job j 前
Cmax           最大完工时间
T[j]           Job j 的延期
```

默认约束包括：

1. 每个 Job 每个 Stage 必须选择一台机器
2. 完工时间定义
3. Stage 顺序约束
4. 同一 Stage 同一机器上的非重叠约束
5. release time
6. due date 和 tardiness
7. makespan 定义
8. 可选 setup time
9. 可选 transport time
10. 可选 worker / transport resource capacity

目标函数默认：`minimize Cmax`

若有 due date，可扩展为：`minimize alpha * Cmax + beta * sum(T[j])`

**Gurobi 要求**：
- 输出 LB 和规定时间内的最优可行解
- 默认时限 3600 秒（正式实验），60s（小规模测试）
- 结果必须经过 `check_feasibility` 校核
- 输出 `result.json`（含 status, objective, LB, gap, runtime, violations）+ `schedule.csv` + `gantt.png`

---

## 19. 编码与解码默认方案

### 19.1 编码方案

HFSP 默认编码：

```text
job_sequence + machine_assignment
```

### 19.2 解码器接口规范

> **相似解码器**的输入和输出要控制一致；**不同编码类型的解码器不强制一致**。

不同编码类型有不同的解码器接口：

| 编码类型 | 解码器接口 | 输入 | 输出 |
|---------|-----------|------|------|
| 纯序列编码 (seq) | `decode(job_sequence, instance) -> Schedule` | 作业排列 | Schedule |
| 序列+机器编码 (seq_machine) | `decode(job_sequence, machine_assignment, instance) -> Schedule` | 作业排列 + 机器分配 | Schedule |

- 同类解码器（如多个 `seq_machine` 解码器：list_decoder, block_decoder）**必须保持输入输出一致**
- 不同编码类型之间（seq vs seq_machine）**不强制一致**，因为输入数据结构不同
- 所有解码器**输出统一为 Schedule 对象**

### 19.3 解码器输出格式

解码器必须输出统一格式：

```text
Schedule
├── operations
│   ├── job_id
│   ├── stage_id
│   ├── machine_id
│   ├── start
│   ├── end
│   └── processing_time
├── objective
└── metrics
```

解码必须满足：
1. Stage precedence
2. machine no-overlap
3. release time
4. transport time
5. optional resource capacity
6. optional worker constraint

### 19.4 结果复现

算法输出的 txt 中保存 **best_seq**（算法返回的最优编码序列），通过 `result_reproducer.py` 重新解码并计算目标值，复现结果必须与原始结果一致，并校验约束条件。**不从 schedule 反推序列**。

---

## 20. 评价与对比

所有方法必须统一输出 Result，并由 `decoding/metrics.py` 计算指标：

```text
makespan
total_tardiness
average_flow_time
machine_utilization
constraint_violations
objective_value
runtime
gap_to_mip
```

对比表格式：

```text
method	status	objective	makespan	total_tardiness	runtime	gap
MIP	Optimal	...	...	...	...	0.00%
SA_basic	Feasible	...	...	...	...	...
Proposed	Feasible	...	...	...	...	...
```

---

## 21. 可视化与算法打印规范

### 21.1 默认生成

```text
gantt.png                    # 甘特图
convergence.png              # 收敛曲线
arpd.png                     # ARPD 对比图
summary_table.csv            # 汇总表
```

### 21.2 甘特图要求

1. 横轴为时间
2. 纵轴为 Stage / Machine
3. 不同 Job 使用不同颜色
4. 标注 JobID 和 StageID
5. 显示 makespan
6. 支持保存 PNG 和 PDF

### 21.3 收敛曲线数据与绘制规范

**trace.csv 数据格式**（每个算法运行必须输出）：

```csv
iteration,time,objective
0,0.00,12.50
1,0.01,11.80
2,0.02,11.20
...
```

- `iteration`：迭代次数（从 0 开始）
- `time`：累计运行时间（秒，保留两位小数）
- `objective`：当前最优目标值（makespan 等）

**收敛曲线绘制规范**：

1. 横轴为迭代次数（或时间），纵轴为目标值
2. 多算法对比时，每条曲线一种颜色，附图例
3. 纵轴范围自动适配，必要时使用对数刻度
4. 标注最终目标值
5. 支持保存 PNG（200 DPI）和 PDF
6. 图片尺寸：宽 10 英寸 × 高 6 英寸
7. 字体大小：标题 14pt，轴标签 12pt，图例 10pt
8. 网格线 alpha=0.3

### 21.4 算法打印规范

算法运行过程中必须按以下规范打印日志：

**启动信息**（算法开始时打印）：

```text
[{algo_name}] Start | instance={inst_name} | time_limit={N}s | seed={seed}
```

**进度信息**（定期打印，建议每 10% 进度或每 N 次迭代）：

```text
[{algo_name}] iter={iteration} | time={elapsed:.1f}s | best={best_obj:.4f} | current={curr_obj:.4f}
```

**结束信息**（算法结束时打印）：

```text
[{algo_name}] Done | best={best_obj:.4f} | runtime={elapsed:.2f}s | iterations={total_iter}
```

**打印规则**：
1. 每行日志以 `[算法名]` 前缀，便于多算法并行时区分
2. 数值保留 4 位小数（目标值）或 2 位小数（时间）
3. 进度信息频率可控（通过 `verbose` 参数），`verbose=0` 静默，`verbose=1` 仅打印启动和结束，`verbose=2` 打印进度
4. 禁止在循环内频繁打印（每行至少间隔 1 秒或 N 次迭代）

---

## 22. 测试要求

### 22.1 Smoke 测试（冒烟测试）

> Smoke 测试是项目生成后的**第一道验证**，确保核心链路能跑通。生成项目后必须立即执行 smoke 测试。

**Smoke 测试范围**：

| 测试项 | 验证内容 | 通过标准 |
|--------|---------|---------|
| 数据读取 | `load_instance(demo_dir)` 能成功加载 | 返回 Instance 对象，`validate()` 无错误 |
| 编码生成 | `generate_random_encoding(instance)` 能成功 | 返回合法编码，`validate()` 通过 |
| 解码运行 | `decode(job_seq, machine_assign, instance)` 能成功 | 返回 Schedule，operations 非空 |
| 可行性检查 | `check_feasibility(instance, schedule)` 能运行 | 返回 violations 列表（可为空） |
| 指标计算 | `evaluate_schedule(instance, schedule)` 能运行 | 返回 metrics 字典，含 makespan |
| 单算法运行 | `solve_sa_basic(instance, time_limit=5, seed=1)` 能跑完 | 返回 (Schedule, trace, best_seq)，objective 有限 |
| 产物写入 | result.json / schedule.json / trace.csv / gantt.png 能写出 | 文件存在且非空 |

**Smoke 测试脚本**：`tests/smoke_test.py`，生成项目后立即运行 `python tests/smoke_test.py`。

### 22.2 单元测试

必须提供 `tests/` 目录，至少包括：

```text
smoke_test.py                # 冒烟测试（核心链路验证）
test_loader.py              # 数据读取测试
test_decoder.py             # 解码器测试
test_feasibility_checker.py # 可行性检查测试
test_gurobi_model.py        # Gurobi MIP 模型测试
test_gantt.py               # 甘特图测试
test_eval_cache.py          # 计算缓存测试
test_result_reproducer.py   # 结果复现测试
```

测试重点：
1. 数据是否能正确读取
2. demo 算例是否可行
3. decoder 是否满足 Stage precedence
4. decoder 是否满足 machine no-overlap
5. MIP 解是否能提取成 Schedule
6. evaluator 是否能重新计算 objective
7. gantt 是否能正常输出图像文件
8. 结果复现是否与原始结果一致（从 best_seq 复现）
9. 计算缓存是否正确命中
10. **smoke 测试**：核心链路（读取→编码→解码→评估→可行性→运行→输出）能跑通

---

## 23. 项目执行步骤（放入 README.md）

### 阶段一：问题定义与数据准备

| 步骤 | 内容 | 产出 |
|------|------|------|
| 1 | 撰写 `configs/` 下的项目规范文档 | `configs/*.md` |
| 2 | 实现 `data/generate.py`，生成 demo/small/large 算例 | `data/demo/`, `data/small/`, `data/large/` |
| 3 | 实现 `data/loader.py`，统一 `load_instance(dir) -> Instance` 接口 | `data/loader.py` |
| 4 | 撰写 `docs/` 下的数据格式文档（日期前缀） | `docs/YYYY-M-Ddata_format_spec.md` |

### 阶段二：核心框架搭建

| 步骤 | 内容 | 产出 |
|------|------|------|
| 5 | 实现 `src/core/domain.py` 领域模型 | `src/core/domain.py` |
| 6 | 实现 `src/metaheuristics/encoding/` 编码方案 | `encoding/*.py` |
| 7 | 实现 `src/metaheuristics/decoding/` 解码方案 + `feasibility_checker.py` | `decoding/*.py` |
| 8 | 初期校验：用 demo 算例验证解码正确性 | demo 运行通过 |
| 8.5 | 编写 `tests/smoke_test.py` 并运行通过 | `tests/smoke_test.py` |

### 阶段三：基础算法实现

| 步骤 | 内容 | 产出 |
|------|------|------|
| 9 | 实现 `src/metaheuristics/initial/` 初始化方法 | `initial/*.py` |
| 10 | 实现 `src/metaheuristics/neighborhood/` 邻域算子 | `neighborhood/*.py` |
| 11 | 实现 5 个 basic 算法（SA, MA, IG, GA, TS） | `sa/`, `ma/`, `ig/`, `ga/`, `ts/` |
| 12 | 注册全部 basic 算法到 `run_baselines.py` | `run_baselines.py` |
| 13 | 用 `sh_single_instance.sh` 在 demo 算例上逐一验证 | `outputs/single_*` |

### 阶段四：数学模型与基准

| 步骤 | 内容 | 产出 |
|------|------|------|
| 14 | 实现 `src/math_models/gurobi_model.py` MIP 建模 | `math_models/gurobi_model.py` |
| 15 | 实现 `src/math_models/lower_bound.py` 下界计算 | `math_models/lower_bound.py` |
| 16 | 用 `scripts/mip/run_gurobi_mip.py` 求解 small 算例，校核结果 | `outputs/mip/` |

### 阶段五：算法研究与改进

| 步骤 | 内容 | 产出 |
|------|------|------|
| 17 | 将 basic 升级为 study 版本（命名带父前缀：`sa_basic_study`） | `sa/sa_basic_study.py` 等 |
| 18 | 每次组件改进**必须消融**，撰写消融记录文档 | `sa/消融实验记录.md` 等 |
| 19 | 基于 study 开发 branch 分支（命名带父前缀：`sa_basic_study_xxx`），每分支注册到中枢 | `sa/sa_basic_study_conditioned.py` 等 |
| 20 | 实现 `src/metaheuristics/baselines/` 论文对比算法 | `baselines/*.py` |

### 阶段六：正式实验

| 步骤 | 内容 | 产出 |
|------|------|------|
| 21 | 生成 `data/batch_seeds/` 确定性种子表 | `batch_seeds/*.json` |
| 22 | 运行 `sh_batch_instances_algorithms.sh` 全量批量测试（7 轮） | `outputs/batch/` |
| 23 | 运行 `sh_analysis.sh` 分析结果 | `outputs/batch/*/analysis.xlsx` |
| 24 | 运行 DOE 参数校核 | `outputs/doe/` |
| 25 | 运行消融实验（使用 `quick_test_config.py`） | `outputs/ablation/` |
| 26 | 运行非参数检验 | `outputs/statistics/` |

### 阶段七：论文写作

| 步骤 | 内容 | 产出 |
|------|------|------|
| 27 | 在 `latex/` 下建立论文工作目录，选择期刊模板 | `latex/{project}_bundle/` |
| 28 | 整理实验结果表格与图表 | `latex/figures/`, `latex/tables/` |
| 29 | 调用 `thirdPartSkills.md` 中的写作 Skill 生成引言、相关工作、问题描述初稿 | `latex/{project}.tex` 初稿 |
| 30 | 使用 `literature-matrix-review-skill-v2.1` 生成两类文献矩阵（广泛搜索+紧密相关） | 文献矩阵 |
| 31 | 撰写论文正文（算法设计、实验分析、结论） | `latex/{project}.tex` |

---

## 24. 输出顺序

当用户要求"生成完整项目"时，建议按以下顺序输出：

1. 问题理解与假设
2. `configs/` 项目规范文档（problem_statement.md, constraints_spec.md, algorithm_requirements.md, experiment_plan.md）
3. 项目结构（顶层目录树）
4. `data/generate.py` + `data/loader.py`
5. demo 算例数据
6. `src/core/domain.py` 领域模型
7. `src/metaheuristics/encoding/` 编码方案
8. `src/metaheuristics/decoding/` 解码方案 + feasibility_checker + metrics + eval_cache
8.5. `tests/smoke_test.py` 冒烟测试（生成后立即运行验证核心链路）
9. `src/metaheuristics/initial/` 初始化方法
10. `src/metaheuristics/neighborhood/` 邻域算子
11. 5 个 basic 算法（SA, MA, IG, GA, TS）
12. `src/math_models/gurobi_model.py` + `lower_bound.py`
13. `src/visualization/` 可视化
14. `scripts/run_baselines.py` + sh 脚本
15. `scripts/mip/run_gurobi_mip.py`
16. `scripts/ablation/quick_test_config.py`
17. `tests/` 单元测试
18. `AGENTS.md`
19. `README.md`
20. 运行命令
21. 后续扩展说明

---

## 25. 不应做的事

1. 不要把所有代码写在一个 `mip_model.py` 中
2. 不要使用 CPLEX/docplex，默认使用 Gurobi
3. 不要生成 `src/algorithms/`、`src/solvers/`、`src/io/`、`src/problems/`、`src/constraints/`、`src/resources/`、`src/utils/`、`src/evaluation/` 等已废弃目录
4. 不要让 MIP、decoder、baseline 各自读取不同格式的数据
5. 不要把 baseline 和 proposed 混在一个目录
6. 不要只输出数学模型而不输出代码
7. 不要只输出代码而没有 demo 算例
8. 不要在 `configs/` 放 JSON 配置文件（改为自然语言文档）
9. 不要在算例生成时传入 seed 参数
10. 不要让新增运输 / 人力资源需要推翻整个代码结构
11. 不要在 `run_baselines.py` 中设置算法内部开关参数
12. 不要跳过消融实验直接纳入未验证的改进
13. 不要将实验输出写到项目外路径
14. 不要随意生成脚本，优先复用核心脚本（single / bench / batch / analysis）
15. **txt 输出不要从 schedule 反推序列，必须保存算法返回的 best_seq**
16. **不要跳过 smoke 测试**，生成项目后必须立即运行 `python tests/smoke_test.py`
17. **不要将不同编码类型的解码器接口强制一致**（seq 和 seq_machine 输入不同，不应统一）
18. **算法分支命名不要省略父算法前缀**（如 `sa_conditioned` 应为 `sa_basic_study_conditioned`）
19. **不要在循环内频繁打印日志**，每行至少间隔 1 秒或 N 次迭代

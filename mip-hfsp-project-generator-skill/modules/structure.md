# 模块：项目结构规范

## 1. 顶层目录结构

```text
project_name/
├── configs/                    # 自然语言项目规范与要求
├── data/                       # 数据层：生成、读取、算例
│   ├── generate.py
│   ├── loader.py
│   ├── demo/
│   ├── small/
│   ├── large/
│   └── batch_seeds/
├── docs/                       # 文档（前缀加日期：YYYY-M-Dxxx.md）
├── src/
│   ├── core/                   # 领域模型
│   ├── math_models/            # MIP / CP 建模（Gurobi）
│   ├── metaheuristics/         # 元启发式算法
│   │   ├── initial/
│   │   ├── encoding/
│   │   ├── decoding/
│   │   ├── neighborhood/
│   │   ├── baselines/
│   │   ├── sa/
│   │   ├── ma/
│   │   ├── ig/
│   │   ├── ga/
│   │   └── ts/
│   ├── visualization/
│   ├── ExperimentAnalysis/
│   └── common/
├── scripts/
│   ├── run_baselines.py
│   ├── sh_single_instance.sh
│   ├── sh_bench_instance.sh
│   ├── sh_batch_instances_algorithms.sh
│   ├── sh_analysis.sh
│   ├── mip/
│   ├── doe/
│   ├── ablation/
│   └── statistics/
├── tests/
├── outputs/
├── latex/
├── requirements.txt
├── AGENTS.md
└── README.md
```

---

## 2. 数据层（`data/`）

### 2.1 目录结构

```text
data/
├── generate.py             # 数据生成入口
├── loader.py               # 数据读取（load_instance）
├── demo/                   # 展示用算例
│   └── demo_01_n_m/        # 命名: demo_0x_n_m
│       ├── *.txt
│       ├── index.json
│       └── *.png / *.pdf   # 可视化图（demo 专属）
├── small/                  # 小规模基准算例
│   └── inst_xxx_n_m_yy/
├── large/                  # 大规模基准算例
└── batch_seeds/            # 统一种子文件
    ├── small/
    │   ├── seed_table.json
    │   └── round{r}.json
    └── large/
        ├── seed_table.json
        └── round{r}.json
```

### 2.2 数据生成 — `data/generate.py`

- 定义 demo / small / large 三种规模的参数组合
- 算例命名：demo 用 `demo_0x_n_m`，正式算例用 `inst_xxx_n_m_yy`
- **不在算例生成时传入 seed 参数，不写入 index.json**
- `index.json` 仅记录文件索引和问题元信息

### 2.3 数据读取 — `data/loader.py`

统一接口：`load_instance(dir) -> Instance`

### 2.4 demo 算例特殊性

1. 额外生成可视化
2. 运行时输出甘特图 + 排程 JSON + 详细日志
3. 不参与批量统计
4. 规模小，便于人工验证

### 2.5 统一种子管理

- `data/batch_seeds/{scale}/seed_table.json` — 种子主表
- `data/batch_seeds/{scale}/round{r}.json` — 每轮种子映射
- 种子源：`random.Random(20260616 + sum(ord(c) for c in scale))`
- 单次运行无指定 seed 时默认 `secrets.randbits(32)`

---

## 3. 源代码层（`src/`）

### 3.1 `src/core/` — 领域模型

```python
@dataclass
class Instance:          # 算例数据
@dataclass
class Schedule:          # 排程结果
@dataclass
class Result:            # 完整结果
@dataclass
class Operation:         # 单个操作
@dataclass
class PrecedenceArc:     # 前序弧
```

### 3.2 `src/math_models/` — MIP / CP 建模（Gurobi）

- **MIP**：Gurobi 实现，建模文件 `gurobi_model.py`
- **下界计算**：`lower_bound.py`（快速下界 + 精确下界）
- **结果校核**：MIP 求解后必须调用 `check_feasibility(instance, schedule)`
- 默认时限 **3600 秒**（正式实验），60s（小规模测试）
- 输出 `result.json` + `schedule.csv` + `gantt.png`

### 3.3 `src/metaheuristics/`

```text
src/metaheuristics/
├── initial/              # 初始化方法（SPT, LPT, NEH, random 等）
├── encoding/             # 编码方案（多套）
├── decoding/             # 解码 + 增量评估 + 结果校验
│   ├── list_decoder.py
│   ├── incremental_eval.py
│   ├── eval_cache.py     # FIFO 队列，限制大小 500
│   ├── feasibility_checker.py
│   ├── metrics.py
│   └── result_reproducer.py
├── neighborhood/         # 邻域算子（详见算法模块）
├── baselines/            # 论文正式对比算法
├── sa/                   # 模拟退火
├── ma/                   # 模因算法
├── ig/                   # 迭代贪心
├── ga/                   # 遗传算法
├── ts/                   # 禁忌搜索
└── registry.py           # 算法注册表
```

> 评估逻辑（feasibility_checker, metrics, eval_cache, result_reproducer）放在 `decoding/` 下，与解码器紧密耦合。

### 3.4 `src/visualization/`

| 文件 | 职责 |
|------|------|
| `gantt.py` | 甘特图绘制 |
| `gantt_plotter.py` | 甘特图高级封装（自行提供，不实现） |
| `convergence.py` | 收敛曲线绘制 |

### 3.5 `src/ExperimentAnalysis/`

**自行提供，不实现**。保留目录结构。

### 3.6 `src/common/`

通用工具：绘图工具、配色方案、基准算例工具等。

---

## 4. `configs/` — 项目规范与要求

自然语言文档（不放 JSON，`problem_fingerprint.json` 除外）：

| 文件 | 内容 |
|------|------|
| `problem_statement.md` | 问题描述 |
| `constraints_spec.md` | 约束规范 |
| `algorithm_requirements.md` | 算法要求 |
| `experiment_plan.md` | 实验计划 |
| `conventions.md` | **用户交互过程的约定记录**（求解器偏好、输出格式、命名调整等） |
| `problem_fingerprint.json` | 问题特征（根据问题描述生成） |

> `conventions.md` 是**关键文件**：使用 Skill 生成项目过程中，用户提出的所有额外约定都必须写入此文件，避免对话上下文丢失后无法追溯。详见 `modules/quality.md` §3。

---

## 5. 输出目录规范（`outputs/`）

```
outputs/
├── single_{INST}_{ALGO}/
├── bench_{INST}/
├── batch/{batch_name}/
│   ├── round{r}/{scale}/
│   └── txt/{scale}/{algo}.txt     # 保存 best_seq
├── mip/
├── doe/{algo}/{param_name}/
├── ablation/{algo}/{ablation_name}/
│   ├── raw/{instance}_{seed}_{repeat}/
│   ├── comparison.xlsx
│   └── arpd.png
├── statistics/{experiment_name}/
└── lower_bounds_all/
```

---

## 6. 文档规范（`docs/`）

- 文件名前缀加日期：`YYYY-M-D主题.md`
- 最低文档集合：problem_description, modeling_assumptions, instance_design, algorithm_design, experiment_plan, project_audit

---

## 7. 论文写作（`latex/`）

```
latex/
├── paper/
│   ├── main.tex                          # 正式论文入口
│   ├── sections/
│   │   ├── 01_introduction.tex           # 引言
│   │   ├── 02_related_work.tex           # 相关工作
│   │   ├── 03_problem_formulation.tex    # 问题建模
│   │   ├── 04_solution_approaches.tex    # 求解方法
│   │   ├── 05_computational_experiments.tex # 实验分析
│   │   └── 06_conclusion.tex             # 结论
│   ├── figures/                          # 甘特图、网络图、算法框架图
│   ├── tables/                           # 实验结果表、参数表
│   ├── algorithms/                       # 伪代码（GA, SA, IG, 本文算法等）
│   ├── bib/
│   │   └── references.bib                # 参考文献
│   └── appendices/                       # MIP 模型、补充实验、参数表
├── templates/
│   └── els-cas-templates/                # 期刊模板原文件（不混入正文工程）
└── README.md
```

### 7.1 各文件职责

| 文件 | 内容 |
|------|------|
| `main.tex` | 论文入口，引用所有 sections |
| `01_introduction.tex` | 工业背景、问题动机、研究贡献 |
| `02_related_work.tex` | 文献综述，按主题组织 |
| `03_problem_formulation.tex` | 数学符号、约束、目标函数 |
| `04_solution_approaches.tex` | 算法设计（编码/解码/邻域/元启发式） |
| `05_computational_experiments.tex` | 实验设置、结果表、消融分析、统计检验 |
| `06_conclusion.tex` | 总结、未来工作 |

### 7.2 写作 Skill 调用

论文写作应调用项目中的写作 Skill（位于 `thirdPartSkills.md`）来生成初稿：

| 章节 | 撰写方式 |
|------|---------|
| 引言 | 调用写作 Skill，基于问题描述和文献矩阵生成 |
| 相关工作 | 调用写作 Skill，基于文献矩阵组织综述 |
| 问题建模 | 调用写作 Skill，基于 `configs/` 文档生成 |

### 7.3 文献矩阵要求

使用 `literature-matrix-review-skill-v2.1`，生成**两类文献矩阵**：

| 类型 | 说明 | 用途 |
|------|------|------|
| **广泛搜索矩阵** | 现有文献的广泛搜索，包含关联度等级 | 引言和相关工作综述 |
| **紧密相关矩阵** | 与本问题紧密相关的文献 | 可直接放入论文中的**比较表格** |

---

## 8. AGENTS.md

每个项目根目录必须有 `AGENTS.md`，包含：

| 章节 | 内容 |
|------|------|
| 项目目的 | 问题描述摘要 |
| 问题类型 | 问题类型判定 |
| 核心假设 | 默认假设列表 |
| 脚本约定 | 核心脚本关键词映射表，使用规则 |
| 算法注册表 | 注册入口 `registry.py`，注册步骤 |
| 占位策略 | 占位模块规则 |
| 禁止路径 | 旧版路径清单 |
| 输出策略 | 输出隔离 + 审计 |
| 维护规则 | 新增约定时同步更新 |

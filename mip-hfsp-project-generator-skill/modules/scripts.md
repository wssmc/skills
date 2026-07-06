# 模块：脚本与执行

## 1. 脚本层架构

```
sh_single_instance.sh  ─┐  (单算例 · 单算法)
sh_bench_instance.sh   ─┼──> run_baselines.py ──> src/metaheuristics/*
sh_batch_instances_*.sh ─┘  (全量 · 多轮)       ──> src/math_models/*

scripts/mip/run_gurobi_mip.py ──> src/math_models/* (独立入口)
```

数据管线：

```
load_instance(dir) ──> solve(...) ──> (Schedule, trace, best_seq) ──> check_feasibility ──> write_artifacts
```

---

## 2. 核心脚本

### 2.1 `run_baselines.py` — 中央调度枢纽

注册全部算法，解析算例目录，`ProcessPoolExecutor` 并行调度，统一写产物。

**输出（每个 算例 × 算法）**：

```
{out}/{instance}/{algo}_result.json
{out}/{instance}/{algo}_schedule.json
{out}/{instance}/{algo}_trace.csv        # iteration, time, objective
{out}/{instance}/{algo}_gantt.png
```

txt 模式：`{txt_out}/{algo}.txt`（保存 **best_seq**，不从 schedule 反推）

**算法返回值**：`(Schedule, trace, best_seq)`，`best_seq = {"job_sequence": [...], "machine_assignment": {...}}`

### 2.2 `sh_single_instance.sh` — 单算例 · 单算法

```bash
bash scripts/sh_single_instance.sh --inst <算例名|路径> --algo <算法名> [--time N] [--seed N] [--verbose 1]
```

必须输出 `schedule.json` 和 `gantt.png`。

### 2.3 `sh_bench_instance.sh` — 单算例 · 多算法对比

```bash
bash scripts/sh_bench_instance.sh [算例路径] [算法1 算法2 ...]
```

默认运行所有已注册且状态为 `complete` 或 `runnable_mvp` 的算法。

### 2.4 `sh_batch_instances_algorithms.sh` — 全量批量 · 多轮

```bash
bash scripts/sh_batch_instances_algorithms.sh [small|large|all] [time_factor]
```

固定模式：
- 7 轮循环，已有 `round{r}/` 数据则跳过（断点续跑）
- 种子源：`random.Random(20260616 + sum(ord(c) for c in scale))`
- 时间公式：`time = N_jobs * M_stages * factor`，factor 默认 `0.05`（单）/ `0.1`（批量）
- 并行：大规模 `W=2`，小规模 `W=4`

### 2.5 `sh_analysis.sh` — 通用结果分析

```bash
bash scripts/sh_analysis.sh <结果目录> [--standard auto|none|xlsx] [--no-plots]
```

---

## 3. MIP 脚本（`scripts/mip/`）

| 脚本 | 职责 |
|------|------|
| `run_gurobi_mip.py` | Gurobi MIP 精确求解（单算例），默认时限 60s |
| `run_gurobi_mip_small.py` | 小规模批量求解 |
| `calc_lower_bounds.py` | 下界计算 |
| `tune_gurobi_mip_params.py` | Gurobi 参数调优 |
| `reproduce_mip_with_decode.py` | MIP 结果解码复现 |

MIP 输出：`result.json`（status, objective, LB, gap, runtime, violations）+ `schedule.csv` + `gantt.png`

---

## 4. 扩展实验脚本

### 4.1 DOE（`scripts/doe/`）

| 脚本 | 职责 |
|------|------|
| `run_doe.py` | DOE 实验入口 |
| `sh_doe.sh` | DOE 批量脚本 |

输出：`outputs/doe/{algo}/{param_name}/doe_results.csv` + 主效应图 + 交互效应图

### 4.2 消融实验（`scripts/ablation/`）

| 脚本 | 职责 |
|------|------|
| `quick_test_config.py` | 固化小实验默认配置 |
| `run_ablation.py` | 消融实验入口 |

### 4.3 统计检验（`scripts/statistics/`）

- Friedman 检验、Wilcoxon 秩和检验、Holm/Hochberg 校正
- 输出 p 值矩阵 + 临界差图（CD diagram）

---

## 5. 项目执行步骤

### 阶段一：问题定义与数据准备

| 步骤 | 内容 | 产出 |
|------|------|------|
| 1 | 问题描述结构化分析（SKILL.md §4） | 结构化问题定义 |
| 2 | 撰写 `configs/` 项目规范文档 + `problem_fingerprint.json` | `configs/*.md` |
| 3 | 实现 `data/generate.py`，生成算例 | `data/demo/`, `data/small/`, `data/large/` |
| 4 | 实现 `data/loader.py` | `data/loader.py` |
| 5 | 撰写 `docs/` 数据格式文档 | `docs/YYYY-M-D*.md` |

### 阶段二：核心框架搭建

| 步骤 | 内容 | 产出 |
|------|------|------|
| 6 | 实现 `src/core/domain.py` | `src/core/domain.py` |
| 7 | 实现 encoding + decoding + feasibility_checker + metrics + eval_cache | `decoding/*.py` |
| 8 | 初期校验：demo 算例验证解码正确性 | demo 运行通过 |
| 8.5 | 编写 `tests/smoke_test.py` 并运行通过 | `tests/smoke_test.py` |

### 阶段三：基础算法实现

| 步骤 | 内容 | 产出 |
|------|------|------|
| 9 | 实现 initial + neighborhood | `initial/*.py`, `neighborhood/*.py` |
| 10 | 实现 5 个 basic 算法（SA, MA, IG, GA, TS） | `sa/`, `ma/`, `ig/`, `ga/`, `ts/` |
| 11 | 注册到 `registry.py` | `registry.py` |
| 12 | 用 `sh_single_instance.sh` 在 demo 上验证 | `outputs/single_*` |

### 阶段四：数学模型与基准

| 步骤 | 内容 | 产出 |
|------|------|------|
| 13 | 实现 `src/math_models/gurobi_model.py` | `math_models/gurobi_model.py` |
| 14 | 实现 `lower_bound.py` | `math_models/lower_bound.py` |
| 15 | 用 `run_gurobi_mip.py` 求解 small 算例 | `outputs/mip/` |

### 阶段五：算法研究与改进

| 步骤 | 内容 | 产出 |
|------|------|------|
| 16 | basic → study（命名带父前缀） | `sa/sa_basic_study.py` 等 |
| 17 | 每次组件改进**必须消融** | 消融记录文档 |
| 18 | study → branch（命名带父前缀），注册到中枢 | `sa/sa_basic_study_xxx.py` |
| 19 | 实现 baselines 论文对比算法 | `baselines/*.py` |

### 阶段六：正式实验

| 步骤 | 内容 | 产出 |
|------|------|------|
| 20 | 生成 `data/batch_seeds/` 种子表 | `batch_seeds/*.json` |
| 21 | 运行 `sh_batch_instances_algorithms.sh`（7 轮） | `outputs/batch/` |
| 22 | 运行 `sh_analysis.sh` | `outputs/batch/*/analysis.xlsx` |
| 23 | 运行 DOE | `outputs/doe/` |
| 24 | 运行消融实验 | `outputs/ablation/` |
| 25 | 运行统计检验 | `outputs/statistics/` |

### 阶段七：论文写作

| 步骤 | 内容 | 产出 |
|------|------|------|
| 26 | 建立 `latex/` 工作目录 | `latex/{project}_bundle/` |
| 27 | 整理实验结果表格与图表 | `latex/figures/`, `latex/tables/` |
| 28 | 调用写作 Skill 生成引言、相关工作、问题描述初稿 | `latex/{project}.tex` |
| 29 | 使用 `literature-matrix-review-skill-v2.1` 生成两类文献矩阵 | 文献矩阵 |
| 30 | 撰写论文正文 | `latex/{project}.tex` |

### 阶段八：审计与交付

| 步骤 | 内容 | 产出 |
|------|------|------|
| 31 | 生成 `IMPLEMENTATION_STATUS.md` | `IMPLEMENTATION_STATUS.md` |
| 32 | 生成 `PROJECT_AUDIT.md` 并通过审计 | `PROJECT_AUDIT.md` |
| 33 | 运行 smoke test + pytest | 测试通过 |
| 34 | 输出审计摘要 | 审计摘要 |

# 模块：质量保障

## 1. 占位策略

允许占位，但必须透明、可审计、不可伪装成完整实现。

### 1.1 允许占位的模块

```text
scripts/doe/
scripts/ablation/
scripts/statistics/
src/ExperimentAnalysis/
latex/els-cas-templates/
部分未要求实现的元启发式算法目录
```

### 1.2 不允许占位的核心模块

```text
data/generate.py
data/loader.py
src/core/
src/metaheuristics/decoding/
src/metaheuristics/baselines/
scripts/run_baselines.py
tests/
README.md
AGENTS.md
docs/*_problem_description.md
```

### 1.3 占位要求

每个占位目录必须包含 `PLACEHOLDER.md`：

```markdown
# Placeholder Module

## Status
placeholder

## Why this module is placeholder
{说明}

## Expected implementation
- Input:
- Output:
- Main function:
- Integration point:
```

占位代码不得静默返回伪结果：

```python
def run(*args, **kwargs):
    raise NotImplementedError("This algorithm is a placeholder. See PLACEHOLDER.md.")
```

---

## 2. 实现状态登记

项目根目录必须生成 `IMPLEMENTATION_STATUS.md`。

| 状态 | 含义 |
|---|---|
| `complete` | 功能完整 |
| `runnable_mvp` | 可运行，基础实现 |
| `placeholder` | 占位，未实现 |
| `not_applicable` | 当前问题不需要 |

---

## 3. 问题描述文档要求

`docs/` 必须包含问题定义文档，作为项目**问题定义源**。

### 3.1 最低文档集合

```text
docs/
├── YYYY-M-D_problem_description.md
├── YYYY-M-D_modeling_assumptions.md
├── YYYY-M-D_instance_design.md
├── YYYY-M-D_algorithm_design.md
├── YYYY-M-D_experiment_plan.md
└── YYYY-M-D_project_audit.md
```

### 3.2 问题描述文档

`YYYY-M-D_problem_description.md` 是项目的问题定义源文档。内容**根据问题描述智能生成**，不预设固定清单。通常包含：

1. 工业背景
2. 问题类型判定
3. 调度对象与资源定义
4. 工艺路线 / 加工流程
5. 加工时间定义
6. 调度约束
7. 优化目标
8. 与相关问题的区别
9. 本项目默认假设

> 具体包含哪些条目取决于问题描述。如果问题没有某种特征（如无 re-entry、无人工资源），则不生成对应条目。

---

## 4. 测试要求

### 4.1 Smoke 测试

生成项目后**第一道验证**，确保核心链路能跑通。

| 测试项 | 通过标准 |
|--------|---------|
| 数据读取 | `load_instance(demo_dir)` 返回 Instance，`validate()` 无错误 |
| 编码生成 | 返回合法编码，`validate()` 通过 |
| 解码运行 | 返回 Schedule，operations 非空 |
| 可行性检查 | `check_feasibility` 能运行 |
| 指标计算 | 返回 metrics 字典，含 makespan |
| 单算法运行 | 返回 (Schedule, trace, best_seq)，objective 有限 |
| 产物写入 | result.json / schedule.json / trace.csv / gantt.png 能写出 |

脚本：`tests/smoke_test.py`，运行 `python tests/smoke_test.py`。

### 4.2 单元测试

```text
smoke_test.py                # 冒烟测试
test_loader.py
test_decoder.py
test_feasibility_checker.py
test_gurobi_model.py
test_gantt.py
test_eval_cache.py
test_result_reproducer.py
```

---

## 5. 自动审计

生成 zip 前必须创建 `PROJECT_AUDIT.md`。

### 审计项目

```text
1. 顶层目录结构检查
2. data 目录结构检查
3. src 目录结构检查
4. 空目录检查
5. placeholder 检查
6. 核心模块非占位检查
7. 算法注册检查
8. demo 加载检查
9. demo 解码检查
10. feasibility checker 检查
11. pytest 检查
12. 输出隔离检查
```

---

## 6. 交付回答规则

每次交付必须包含审计摘要：

```text
Audit summary:
- Tests: N passed
- Demo: feasible=True/False
- Empty directories: N
- Placeholder modules: N
- Runnable MVP algorithms: N
- Complete algorithms: N
- Registered runnable algorithms: N
```

---

## 7. 可视化规范

### 7.1 默认生成

```text
gantt.png          # 甘特图
convergence.png    # 收敛曲线
arpd.png           # ARPD 对比图
```

### 7.2 甘特图

1. 横轴为时间，纵轴为 Stage / Machine
2. 不同 Job 使用不同颜色
3. 标注 JobID 和 StageID
4. 显示 makespan
5. 支持 PNG（200 DPI）和 PDF

### 7.3 收敛曲线

**trace.csv 数据格式**：

```csv
iteration,time,objective
0,0.00,12.50
1,0.01,11.80
```

**绘制规范**：
- 横轴迭代/时间，纵轴目标值
- 多算法对比附图例
- 200 DPI，宽 10 英寸 × 高 6 英寸
- 网格 alpha=0.3

---

## 8. 算法打印规范

> 算法打印主要针对 single / bench / batch 场景。

### 8.1 single 场景打印规范

**启动前**：打印基础信息

```text
[SA] instance=demo_01_10_5  algo=sa_basic  time_limit=30s  seed=42
[SA] initializing...
[SA] initial solution: makespan=856.30
```

**运行中**：每 N 次迭代打印一次（默认 N=10）

每次打印包含：迭代次数、已执行时间、当前最优解、当前解等。不同算法打印信息有区别。

**SA 示例**：

```text
[SA]  it=    10  time=1.7s  best=683  base=759  cur=708  accept=1  T=25.9285
[SA]  it=    20  time=3.4s  best=683  base=712  cur=695  accept=1  T=12.1503
[SA]  it=    30  time=5.1s  best=683  base=705  cur=722  accept=0  T=5.7108
```

字段说明：

| 字段 | 说明 |
|------|------|
| `it=` | 迭代次数 |
| `time=` | 已执行时间（秒） |
| `best=` | 当前最优目标值 |
| `base=` | 基础解目标值（当前搜索链的起点） |
| `cur=` | 当前解目标值 |
| `accept=` | 本次移动是否被接受（1=接受, 0=拒绝） |
| `T=` | 当前温度 |

**IG 示例**：

```text
[IG]  it=    10  time=1.7s  best=683  cur=695  d=3  accept=1
```

**GA 示例**：

```text
[GA]  gen=   10  time=1.7s  best=683  avg=712  worst=768  pop=30
```

**TS 示例**：

```text
[TS]  it=    10  time=1.7s  best=683  cur=695  tabu_size=7  aspiration=0
```

**结束**：

```text
[SA] Done | best=683.00 | runtime=30.02s | iterations=1823
```

### 8.2 bench / batch 场景

- bench：每个算法启动和结束时各打印一行，运行中不打印（避免干扰）
- batch：每个 算例×算法 组合打印一行进度：

```text
[batch] small/inst_001_10_5_01 x sa_basic ... Done | best=683.00 | 30.1s
[batch] small/inst_001_10_5_01 x ig_basic ... Done | best=679.00 | 30.0s
```

### 8.3 打印规则

1. 每行日志以 `[算法名]` 前缀
2. 数值保留适当小数位（目标值 2 位，时间 1 位）
3. 迭代间隔 N 可配置（默认 10），通过 `verbose` 参数控制：
   - `verbose=0`：静默
   - `verbose=1`：仅启动和结束
   - `verbose=2`：每 N 次迭代打印进度（默认）
4. 禁止在循环内每轮都打印

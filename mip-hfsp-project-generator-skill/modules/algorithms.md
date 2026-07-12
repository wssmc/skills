# 模块：算法规范

## 1. 算法命名、分支与注册规范

### 1.1 命名层级

算法命名遵循 **`{父算法}_{变体}`** 模式，子算法必须带父算法名作为前缀：

| 层级 | 命名示例 | 说明 |
|------|---------|------|
| **basic** | `sa_basic`, `ig_basic` | 最基础实现 |
| **study** | `sa_basic_study`, `ig_basic_study` | 在 basic 基础上完善 |
| **branch** | `sa_basic_study_conditioned` | 基于 study 的改进分支 |

### 1.2 分支树状结构

```text
sa_basic
  └── sa_basic_study
        ├── sa_basic_study_conditioned
        ├── sa_basic_study_qlig
        └── ...

ig_basic
  └── ig_basic_study
        ├── ig_basic_study_tour_inc
        └── ...
```

消融变体：`{algo}_basic_study_{branch}_no_{component}`（关闭组件）、`{algo}_basic_study_core{N}`（只保留前 N 个组件）

### 1.3 分支管理

- **study 文件**提供可配置的开关参数
- **branch 文件**继承 study 框架，在文件内部固化开关组合
- **`run_baselines.py` 不设开关**：中枢只负责调度

### 1.4 算法注册

所有可运行算法必须注册到 `src/metaheuristics/registry.py`：

```python
ALGORITHM_REGISTRY = {
    "sa": solve_sa_basic,
    "ga": solve_ga_basic,
    ...
}
ALGORITHM_STATUS = {
    "sa": "runnable_mvp",
    "ga": "runnable_mvp",
    ...
}
```

注册步骤：
1. 在 `ALGORITHM_REGISTRY` 添加 `名称: solver函数`
2. 在 `ALGORITHM_STATUS` 添加状态（complete / runnable_mvp / placeholder）
3. 占位算法不注册；若注册则运行时必须报错

---

## 2. 通用元启发式模板

所有算法必须遵守统一流程：

```text
Instance → Encoding → Decoder → Schedule → Feasibility Checker → Metrics → Result
```

算法签名：`solve_xxx(instance, time_limit, seed, **kwargs) -> (Schedule, trace, best_seq)`

### 2.0 强制要求：计算缓存 EvalCache

> **所有元启发式算法（包括 baselines 中需要重复评估的算法）必须使用 `EvalCache`**。

**约定**：

| 项 | 值 |
|---|---|
| 缓存对象 | 编码序列 → 目标值 的映射 |
| 缓存上限 | `MAX_SIZE = 500`（固定，不得修改） |
| 弹出策略 | **FIFO**（先入先出，最旧条目最先被弹出，超过上限时自动弹出） |
| 缓存键 | 编码序列的哈希，如 `tuple(job_sequence)` 或 `(tuple(seq), frozenset(machine_assign.items()))` |
| 评估流程 | 先查缓存 → 命中则直接返回 → 未命中则解码 + 计算 + 存入缓存 |
| 位置 | `src/metaheuristics/decoding/eval_cache.py` |
| 引入 | `from metaheuristics.decoding.eval_cache import EvalCache` |

**标准使用范式**（每个算法必须实现）：

```python
from metaheuristics.decoding.eval_cache import EvalCache
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule

def solve_xxx(instance, time_limit, seed=None, **kwargs):
    cache = EvalCache(max_size=500)  # 上限 500，FIFO

    def evaluate(seq):
        """带缓存的目标值评估。"""
        key = tuple(seq)
        cached = cache.get(key)
        if cached is not None:
            return cached
        sched = decode(seq, machine_assign, instance)
        evaluate_schedule(instance, sched)
        cache.put(key, sched.objective)
        return sched.objective

    # ... 算法主循环，调用 evaluate(seq) 而非直接 decode+evaluate_schedule
```

**为什么强制**：
- 元启发式在邻域搜索、种群迭代中会**大量重复评估相同编码**（尤其是 GA/MA 种群、SA 拒绝后回退、IG 修复过程）
- 无缓存时，重复解码成本极高，大规模算例可能占 80% 以上运行时间
- 上限 500 与 FIFO 弹出策略是内存与命中率的平衡点，实证有效

**在项目 `docs/YYYY-M-D_algorithm_design.md` 中必须明确写入此约定**。

### 2.1 GA 模板

```text
1. 初始化种群 (random / NEH / 问题相关初始化)
2. 评价 (decode + feasibility + metrics)
3. 选择 (tournament)
4. 交叉 (OX / POX)
5. 变异 (swap / insert / reverse)
6. 精英保留
7. 可选局部搜索
8. 输出最优 Result
```

### 2.2 SA 模板

```text
1. 生成初始解
2. 设定初始温度
3. 随机选择邻域
4. decode + evaluate
5. Metropolis 接受准则
6. 降温
7. 终止
8. 输出 Result
```

### 2.3 IG 模板

```text
1. 生成初始序列
2. destruction（移除部分作业）
3. reconstruction（重新插入）
4. local search（邻域搜索）
5. acceptance criterion（接受准则）
6. 重复步骤 2-5 直到时间耗尽
7. 输出 Result
```

### 2.4 TS 模板

```text
1. 生成初始解
2. 生成候选邻域
3. 过滤 tabu move
4. aspiration criterion（藐视准则）
5. 更新 tabu list
6. 更新 best
7. 输出 Result
```

### 2.5 MA 模板

```text
1. GA 主循环
2. 对 elite 或 promising offspring 做 local education
3. local search 使用问题相关邻域
4. 输出 Result
```

---

## 3. 编码与解码

### 3.1 编码方案

根据问题特征选择编码，常见方案：
- 置换序列编码：全作业的一个排列
- 序列+机器编码：作业排列 + 机器分配
- 每阶段序列编码：每个阶段一个排列
- 其它编码：按需扩展

### 3.2 解码器接口规范

> **相似解码器**的输入和输出要控制一致；**不同编码类型的解码器不强制一致**。

| 编码类型 | 解码器接口 | 输入 |
|---------|-----------|------|
| 纯序列 (seq) | `decode(job_sequence, instance) -> Schedule` | 作业排列 |
| 序列+机器 (seq_machine) | `decode(job_sequence, machine_assignment, instance) -> Schedule` | 排列 + 机器分配 |

所有解码器**输出统一为 Schedule 对象**。

### 3.3 解码器输出格式

```text
Schedule
├── operations (job_id, stage_id, machine_id, start, end, processing_time)
├── objective
└── metrics
```

### 3.4 解码约束

解码必须满足的**通用约束**（根据问题特征增减）：

1. 工序顺序约束（前序完成后才能开始）
2. 资源容量约束（同一资源同一时间容量不超限）
3. 释放时间约束（不早于 release time 开始）

### 3.5 结果复现

txt 保存 **best_seq**（算法返回的最优编码序列），通过 `result_reproducer.py` 重新解码并计算目标值，复现结果必须与原始结果一致。**不从 schedule 反推序列**。

---

## 4. 邻域算子

### 4.1 通用邻域

```text
swap(i, j)          # 交换两个位置
insert(i, j)        # 将位置 i 的元素插入到位置 j
reverse(i, j)       # 逆序 [i, j) 区间
block_insert        # 块插入
```

### 4.2 关键路径邻域

```text
critical_path_swap       # 关键路径上的交换
critical_path_insert     # 关键路径上的插入
critical_path_block_move # 关键路径上的块移动
```

### 4.3 邻域选择框架

| 框架 | 说明 |
|------|------|
| `VnsState` | 变邻域搜索：按固定顺序遍历，接受最优改进时回 N1 |
| `UniformRandomState` | 均匀随机选择 |
| `AlnsState` | 自适应大邻域搜索：动态调整权重 |

---

## 5. 评价与对比

所有方法统一输出 Result，`decoding/metrics.py` 计算指标：

```text
makespan
total_tardiness
average_flow_time
constraint_violations
objective_value
runtime
gap_to_mip
```

---

## 6. 消融实验规范

> **强制要求**：每次算法组件改进都必须消融。

### 6.1 设计目的

算法改进过程中，验证某组件是否优于改进前时，不想用所有算例来测试。因此用每个规模的**第一个**算例进行快速验证。

### 6.2 测试配置

| 配置项 | 规定 |
|--------|------|
| 测试算例 | 每个规模的**第一个**算例 |
| 种子 | 固定种子（从 `data/batch_seeds/` 读取或用户指定） |
| 重复次数 | repeat=3 |
| 时间限制 | `N_jobs * M_stages * 0.05` |

配置固化为 `scripts/ablation/quick_test_config.py`。

### 6.3 原始结果输出

```
outputs/ablation/{algo}/{ablation_name}/
  raw/{instance}_{seed}_{repeat}/
    {algo_variant}_result.json
    {algo_variant}_schedule.json
    {algo_variant}_trace.csv
    {algo_variant}_gantt.png
  comparison.xlsx
  arpd.png
```

### 6.4 消融记录文档

存放于算法目录下（如 `src/metaheuristics/ig/消融实验记录.md`），结构：组件总览 → 组件 N（机制+参数+结果+结论）→ 综合效果 → 实验脚本附录（含双链）。

---

## 7. MIP 建模默认方案（Gurobi）

### 7.1 默认变量

根据问题类型定义变量，HFSP 示例：

```text
S[j, k]        开始时间
C[j, k]        完工时间
x[j, k, l]     机器分配（二值）
y[i, j, k, l]  排序（二值）
Cmax           最大完工时间
```

### 7.2 默认约束

1. 资源分配约束（每个操作必须分配资源）
2. 完工时间定义
3. 顺序约束（前序关系）
4. 资源非重叠约束
5. 释放时间
6. makespan 定义

### 7.3 目标函数

默认 `minimize Cmax`，可扩展为加权多目标。

### 7.4 Gurobi 要求

- 输出 LB 和最优可行解
- 默认时限 3600 秒（正式）/ 60s（测试）
- 结果经过 `check_feasibility` 校核
- 无 Gurobi 环境时测试应跳过：`pytest.importorskip("gurobipy")`

---

## 8. 算法适配（Algorithm Adaptation）

> 当指令是"算法适配项目"时，遵循以下强制流程。

### 8.1 初始化拆解为单解 / 种群两类

> **强制**：初始化方法必须按用途区分为两类，分别放在两个子目录：

```text
src/metaheuristics/initial/
├── single/                       # 单解生成器（供 SA/IG/TS 及 baselines 使用）
│   ├── dispatching.py            # SPT / LPT / EDD 等调度规则
│   ├── neh.py                    # NEH 启发式
│   ├── random_init.py            # 单个随机排列
│   └── {author_year}.py          # 适配的文献单解初始化
└── population/                   # 种群生成器（供 GA/MA 使用）
    ├── random_pop.py             # 生成 pop_size 个不同的随机排列
    ├── neh_pop.py                # NEH + 扰动策略生成多样化种群
    └── {author_year}_pop.py      # 适配的文献种群初始化
```

### 8.2 用途约束（强制）

| 生成器类型 | 函数签名返回 | 允许用于 | **严禁用于** |
|-----------|-------------|---------|-------------|
| **单解生成器** `initial/single/` | `list[int]` — 单个作业排列 | SA / IG / TS / baselines | GA / MA 的种群初始化 |
| **种群生成器** `initial/population/` | `list[list[int]]` — pop_size 个排列 | GA / MA 的种群初始化 | 单解算法的起点 |

**为什么强制区分**：
- **单解生成器直接用于种群会失败**：
  - 确定性生成器（NEH、SPT）会产生 pop_size 个**相同**个体，种群丧失多样性
  - 循环调用随机生成器不保证个体互不相同
- **种群生成器返回 list[list[int]]，语义不同**：不能直接用于单解算法（会浪费计算）

### 8.3 命名与文件约定

**单解生成器**：
- 文件命名：`src/metaheuristics/initial/single/{方法名}.py`
- 函数签名：`init_xxx(instance, **kwargs) -> list[int]`
- 顶部注释必须声明：`⚠ 用途约定：仅用于单解元启发式（SA / IG / TS）`

**种群生成器**：
- 文件命名：`src/metaheuristics/initial/population/{方法名}_pop.py`（后缀 `_pop` 明示种群）
- 函数签名：`generate_xxx_population(instance, pop_size, seed=None, **kwargs) -> list[list[int]]`
- 顶部注释必须声明：`⚠ 用途约定：仅用于种群元启发式（GA / MA）`
- **保证多样性**：内部实现应确保 pop_size 个个体互不相同（`ensure_diversity=True`），无法保证时（如 pop_size 接近 n!）应有 fallback 逻辑

### 8.4 从文献适配算法时

1. 识别文献算法中的初始化是**单解**还是**种群**类型
2. 单解 → 提取到 `initial/single/{author_year}.py`
3. 种群 → 提取到 `initial/population/{author_year}_pop.py`
4. 原算法主文件通过 import 调用对应模块

**示例**：

```python
# src/metaheuristics/ig/ig_ruiz2007.py（单解算法，用 single/）
from metaheuristics.initial.single.neh_ruiz2003 import init_neh_ruiz2003

def solve_ig_ruiz2007(instance, time_limit, seed=None, **kwargs):
    cache = kwargs.get("cache") or EvalCache(max_size=500)
    initial_seq = init_neh_ruiz2003(instance)
    ...

# src/metaheuristics/ga/ga_liu2018.py（种群算法，用 population/）
from metaheuristics.initial.population.neh_pop import generate_neh_population

def solve_ga_liu2018(instance, time_limit, seed=None, **kwargs):
    cache = kwargs.get("cache") or EvalCache(max_size=500)
    pop_size = 30
    initial_pop = generate_neh_population(instance, pop_size, seed=seed, strategy="mixed")
    ...
```

---

## 9. 批量对比一致性

### 9.1 强制交互提示

`sh_batch_instances_algorithms.sh` 在启动时必须提示用户选择或接受两个开关：

```bash
bash scripts/sh_batch_instances_algorithms.sh all 0.1
# 若未指定开关，脚本交互式提示:
#   Use unified initialization for all algorithms? [y/n] (default: y):
#   Use unified EvalCache across algorithms? [y/n] (default: y):
```

支持命令行开关：

```bash
bash scripts/sh_batch_instances_algorithms.sh all 0.1 \
    --unified-init y --unified-cache y
```

### 9.2 两个开关的行为

| 开关 | y（统一，默认） | n（独立） |
|------|---------------|----------|
| `--unified-init` | **按算法类型分派**：单解算法用同一个 `initial/single/xxx` 生成器（默认 `neh`）；种群算法用同一个 `initial/population/xxx_pop` 生成器（默认 `neh_pop`） | 各算法用注册时指定的初始化 |
| `--unified-cache` | 传入**同一个 EvalCache 实例**给所有算法（跨算法共享编码→目标值） | 各算法内部各自 `EvalCache(500)` |

> **重要**：`--unified-init` 不会把单解生成器强加给种群算法（反之亦然）。统一是指**同类内统一**：所有单解算法共用一个单解生成器，所有种群算法共用一个种群生成器。

### 9.3 CLI 参数

```bash
bash scripts/sh_batch_instances_algorithms.sh all 0.1 \
    --unified-init y \
    --init-method-single neh \
    --init-method-pop neh_pop \
    --unified-cache y
```

- `--init-method-single NAME`：单解算法使用的初始化方法（默认 `neh`）
- `--init-method-pop NAME`：种群算法使用的种群生成器（默认 `neh_pop`）

### 9.4 默认策略

- **默认**：`--unified-init y --unified-cache y`
- 原因：批量对比目的是评估算法**搜索能力**，应控制初始化和缓存变量
- 使用非默认选项需在 `configs/conventions.md` 中记录理由

### 9.5 实现要点

`run_baselines.py` 需支持接收外部注入的 `init_fn` 和 `cache`：

```python
def run_single(instance_dir, algo, time_limit, seed=None,
               shared_cache=None, shared_init_fn=None, ...):
    solver = get_algorithm(algo)
    if shared_cache is not None and shared_init_fn is not None:
        # 统一模式
        schedule, trace, best_seq = solver(
            instance, time_limit, seed,
            cache=shared_cache, init_fn=shared_init_fn,
        )
    else:
        # 独立模式
        schedule, trace, best_seq = solver(instance, time_limit, seed)
```

算法函数签名支持可选参数：

```python
def solve_xxx(instance, time_limit, seed=None, cache=None, init_fn=None, **kwargs):
    if cache is None:
        cache = EvalCache(max_size=500)
    if init_fn is None:
        init_fn = default_init_for_this_algo
    initial_seq = init_fn(instance)
    ...
```

### 7.1 默认变量

根据问题类型定义变量，HFSP 示例：

```text
S[j, s]        开始时间
C[j, s]        完工时间
x[j, s, m]     机器分配（二值）
y[i, j, s, m]  排序（二值）
Cmax           最大完工时间
```

### 7.2 默认约束

1. 资源分配约束（每个操作必须分配资源）
2. 完工时间定义
3. 顺序约束（前序关系）
4. 资源非重叠约束
5. 释放时间
6. makespan 定义

### 7.3 目标函数

默认 `minimize Cmax`，可扩展为加权多目标。

### 7.4 Gurobi 要求

- 输出 LB 和最优可行解
- 默认时限 3600 秒（正式）/ 60s（测试）
- 结果经过 `check_feasibility` 校核
- 无 Gurobi 环境时测试应跳过：`pytest.importorskip("gurobipy")`

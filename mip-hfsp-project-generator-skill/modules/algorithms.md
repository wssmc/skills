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

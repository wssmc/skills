# 算法设计约定记录

> 本文件记录项目中所有算法的**设计约定**与**关键决策**。
> 生成日期：{{YYYY-MM-DD}}

## 1. 强制约定：计算缓存 EvalCache

> **所有元启发式算法必须使用 `EvalCache`**，此为项目级强制约定。

### 1.1 约定内容

| 项 | 值 |
|---|---|
| 缓存对象 | **编码序列 → 目标值** 的映射 |
| 缓存上限 | `MAX_SIZE = 500` |
| 弹出策略 | **FIFO**（先入先出，超过上限时最旧的条目最先被弹出） |
| 缓存键 | 编码序列的哈希，如 `tuple(job_sequence)` |
| 引入位置 | `src/metaheuristics/decoding/eval_cache.py` |
| 引入方式 | `from metaheuristics.decoding.eval_cache import EvalCache` |

### 1.2 目的

对**序列 → 目标值**的计算进行缓存，节省重复解码计算的时间。

元启发式在以下情况会**大量重复评估相同编码**：
- SA 拒绝后回退到基础解
- IG 破坏-修复过程中的候选序列
- GA/MA 种群中的相同个体
- TS 的邻域重访

无缓存时，这些重复解码成本极高，可占大规模算例运行时间的 80% 以上。

### 1.3 标准使用范式

```python
from metaheuristics.decoding.eval_cache import EvalCache
from metaheuristics.decoding.list_decoder import decode
from metaheuristics.decoding.metrics import evaluate_schedule

def solve_xxx(instance, time_limit, seed=None, **kwargs):
    cache = EvalCache(max_size=500)  # 上限 500，FIFO 弹出

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

    # 算法主循环中一律调用 evaluate(seq)，不再直接 decode + evaluate_schedule
    ...
```

### 1.4 已集成的算法

| 算法 | 文件 | 使用 EvalCache | 上限 | 策略 |
|------|------|---------------|------|------|
| SA | `src/metaheuristics/sa/sa_basic.py` | ✓ | 500 | FIFO |
| MA | `src/metaheuristics/ma/ma_basic.py` | ✓ | 500 | FIFO |
| IG | `src/metaheuristics/ig/ig_basic.py` | ✓ | 500 | FIFO |
| GA | `src/metaheuristics/ga/ga_basic.py` | ✓ | 500 | FIFO |
| TS | `src/metaheuristics/ts/ts_basic.py` | ✓ | 500 | FIFO |
| baseline_template | `src/metaheuristics/baselines/` | ✓ | 500 | FIFO |

---

## 2. 算法参数约定

### 2.1 SA
- 初始温度: {{init_temp}}
- 冷却率: {{cooling_rate}}
- 最低温度: {{min_temp}}
- 接受准则: Metropolis

### 2.2 IG
- 破坏大小: `d = {{destruction_size}}`
- 修复策略: {{repair_strategy}}
- 接受准则: {{acceptance}}

### 2.3 GA
- 种群大小: {{pop_size}}
- 交叉算子: {{crossover}}
- 变异率: {{mutation_rate}}
- 精英保留: {{elite_size}}

### 2.4 TS
- 禁忌表长度: {{tabu_length}}
- 藐视准则: {{aspiration}}

### 2.5 MA
- GA + Local Search
- 局部搜索概率: {{ls_prob}}

---

## 3. 邻域算子约定

### 3.1 通用邻域
- `swap(i, j)`
- `insert(i, j)`
- `reverse(i, j)`
- `block_insert`

### 3.2 关键路径邻域
- `critical_path_swap`
- `critical_path_insert`
- `critical_path_block_move`

### 3.3 邻域选择框架
- 默认：{VNS / UniformRandom / ALNS}

---

## 4. 初始化约定

- 随机初始化：`random_init`
- 调度规则：SPT / LPT / EDD（按需选择）
- NEH 启发式：`neh_basic`
- 问题相关初始化：{{problem_specific_init}}

---

## 5. 决策记录

| 日期 | 决策点 | 选择 | 理由 |
|------|--------|------|------|
| {{YYYY-MM-DD}} | 计算缓存 | EvalCache 500 FIFO | 项目级强制约定 |
| {{YYYY-MM-DD}} | 默认算法集合 | SA/MA/IG/GA/TS | 覆盖主流元启发式家族 |

---

## 6. 变更历史

| 日期 | 变更 | 原因 |
|------|------|------|
| {{YYYY-MM-DD}} | 初始版本 | 项目生成 |

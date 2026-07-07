# 算法要求

## 1. MIP 精确求解
- 求解器: Gurobi (`gurobipy`)
- 默认时限: 3600 秒（正式实验），60 秒（测试）
- 输出: LB + 最优可行解 + gap
- 结果必须经过 `check_feasibility` 校核

## 2. 元启发式算法（默认实现 5 个）

| 算法 | 目录 | 说明 |
|------|------|------|
| SA | `src/metaheuristics/sa/` | 模拟退火，基础版 `sa_basic.py` |
| MA | `src/metaheuristics/ma/` | 模因算法，基础版 `ma_basic.py` |
| IG | `src/metaheuristics/ig/` | 迭代贪心，基础版 `ig_basic.py` |
| GA | `src/metaheuristics/ga/` | 遗传算法，基础版 `ga_basic.py` |
| TS | `src/metaheuristics/ts/` | 禁忌搜索，基础版 `ts_basic.py` |

## 3. 计算缓存 EvalCache（强制要求）

> **所有元启发式算法必须使用 `EvalCache`**，无例外。

| 项 | 值 |
|---|---|
| 缓存对象 | 编码序列 → 目标值 的映射 |
| 缓存上限 | `MAX_SIZE = 500` |
| 弹出策略 | **FIFO**（先入先出，最旧条目最先弹出） |
| 缓存键 | 编码序列的哈希，如 `tuple(job_sequence)` |
| 位置 | `src/metaheuristics/decoding/eval_cache.py` |
| 引入 | `from metaheuristics.decoding.eval_cache import EvalCache` |

**标准使用范式**：

```python
cache = EvalCache(max_size=500)

def evaluate(seq):
    key = tuple(seq)
    cached = cache.get(key)
    if cached is not None:
        return cached
    sched = decode(seq, machine_assign, instance)
    evaluate_schedule(instance, sched)
    cache.put(key, sched.objective)
    return sched.objective
```

**目的**：节省重复编码的解码计算时间。元启发式在邻域搜索/种群迭代中会大量重复评估相同编码，无缓存时可能占 80% 以上运行时间。

## 4. 算法命名规范
- **basic**: 最小可运行实现
- **study**: 在 basic 基础上完善的研究版本
- **branch**: 基于 study 的改进分支，用独立文件固化开关

## 5. 论文对比算法 (baselines)
- 存放于 `src/metaheuristics/baselines/`
- 每个对比算法一个文件
- 注册到 `registry.py` 统一调度

## 6. 消融实验要求
- 每次组件改进必须消融
- 测试配置: 每规模第一个算例，固定种子（从 `data/batch_seeds/` 读取），repeat=3
- 使用 `scripts/ablation/quick_test_config.py`
- 撰写消融记录文档（机制+参数+结果+结论+脚本附录+双链）

## 7. 注册要求
所有可运行算法必须注册到 `src/metaheuristics/registry.py`:
1. `ALGORITHM_REGISTRY` 添加 `名称: solver 函数`
2. `ALGORITHM_STATUS` 添加状态（complete / runnable_mvp / placeholder）
3. 占位算法不注册；若注册则运行时必须 raise NotImplementedError

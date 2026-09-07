# C++ 算法设计约定记录

> 本文件记录 C++ 核心算法的设计约定、关键决策、参数和消融结果。Python 只负责读取结果和生成统计。
> 生成日期：{{YYYY-MM-DD}}

## 1. 强制约定：EvalCache

| 项 | 值 |
|---|---|
| 实现位置 | `cpp/include/hfsp/decoding/eval_cache.hpp` |
| 容量 | 500 |
| 淘汰 | FIFO |
| 键 | 实例身份 + job sequence + machine assignment |
| 生命周期 | 每个算例 × 算法 × 轮次独立 |
| Python 关系 | Python 不参与核心评估，不创建第二个 cache |

每个算法的评估只能经过同一个 C++ decoder/checker 入口。实际命中率和收益必须由实验测量，不能预填。

## 2. 统一接口

```cpp
SolveResult solve_xxx(const Instance&, const SolveConfig&);
```

`SolveResult` 必须保存 `Schedule`、有限 objective、trace、seed、feasible 和直接产生的 `best_sequence`。C++ 输出 `result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`。

## 3. 默认算法与参数

| 算法 | C++ 入口 | 关键参数 |
|---|---|---|
| SA | `solve_sa_basic` | 初温 {{init_temp}}、冷却率 {{cooling_rate}}、最低温 {{min_temp}} |
| IG | `solve_ig_basic` | 破坏大小 {{destruction_size}}、修复 {{repair_strategy}} |
| GA | `solve_ga_basic` | 种群 {{pop_size}}、交叉 {{crossover}}、变异 {{mutation_rate}}、精英 {{elite_size}} |
| TS | `solve_ts_basic` | 禁忌长度 {{tabu_length}}、aspiration {{aspiration}} |
| MA | `solve_ma_basic` | GA + local search，局部搜索概率 {{ls_prob}} |

## 4. 初始化与邻域

- 单解生成器：`cpp/include/hfsp/metaheuristics/initial/single/`
- 种群生成器：`cpp/include/hfsp/metaheuristics/initial/population/`
- 邻域：`cpp/include/hfsp/metaheuristics/neighborhood/`，至少定义 swap、insert、reverse
- 单解与种群类型不可混用；小于两个 job 时邻域安全终止

## 5. 算法适配和消融

文献算法适配必须记录来源、真实差异、C++ 文件、初始化/邻域组件和参数。新编码同步更新序列化、cache key、decoder、checker、MIP 和测试。每个改进组件增加消融记录，Python 只生成汇总表和图。

## 6. 批量一致性

- 同类算法使用相同初始化、时间预算、seed 公式和 `EvalCache(500)` 配置
- 每个任务 cache 独立；不得提供跨任务共享开关
- 非默认初始化、轮数、时间因子和统计方法写入 `configs/conventions.md`

## 7. 决策记录

| 日期 | 决策点 | 选择 | 理由 |
|---|---|---|---|
| {{YYYY-MM-DD}} | 核心语言 | C++17 | 避免算法/解码存在第二套 Python 实现 |
| {{YYYY-MM-DD}} | 辅助语言 | Python 3 | 复用统计和绘图库，不承担求解状态 |
| {{YYYY-MM-DD}} | 缓存 | EvalCache 500 FIFO | 统一公平比较和可复现性 |

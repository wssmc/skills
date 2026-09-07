# 算法要求

## 1. 语言与 MIP

- 主体实现：C++17，使用 CMake 构建
- 辅助实现：Python 3，仅用于算例生成、结果分析、统计和可视化
- MIP：Gurobi C++ API；缺少 `GUROBI_HOME` 或 license 时标 `NOT_RUN`
- Python 不得重复实现 solver、decoder、checker 或 objective

## 2. 元启发式算法（默认集合）

| 算法 | C++ 位置 | 说明 |
|---|---|---|
| SA | `cpp/src/metaheuristics/sa/` | 模拟退火，`sa_basic` |
| MA | `cpp/src/metaheuristics/ma/` | 模因算法，`ma_basic` |
| IG | `cpp/src/metaheuristics/ig/` | 迭代贪心，`ig_basic` |
| GA | `cpp/src/metaheuristics/ga/` | 遗传算法，`ga_basic` |
| TS | `cpp/src/metaheuristics/ts/` | 禁忌搜索，`ts_basic` |

只有通过 C++ smoke、checker 和 best-sequence 重放的算法才能标为 runnable。

## 3. 计算缓存 EvalCache（强制）

所有元启发式必须使用 C++ `EvalCache(500)`，FIFO 淘汰。缓存键为 `instance_id + job_sequence + machine_assignment`，生命周期是一次“算例 × 算法 × 轮次”。禁止跨任务共享。Python 分析阶段不创建求解缓存。

## 4. 算法命名

- `basic`：最小可运行实现
- `study`：在 basic 上经验证的研究版本
- `branch`：独立文件固化的改进分支

## 5. 基线与消融

- 基线与研究算法都注册到 `cpp/include/hfsp/registry.hpp` / `cpp/src/registry.cpp`
- 每次组件改进必须消融；Python 只汇总 C++ 结果
- 测试配置固定 seed，并记录在 `configs/conventions.md` 与 `docs/`

## 6. 统一结果契约

每个 solver 返回 `SolveResult`，包含 `Schedule`、有限 objective、trace、seed、feasible 和直接保存的 `best_sequence`。输出 `result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`，全部写入 `outputs/`。

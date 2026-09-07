# 模块：C++ 算法规范

## 导航

- §1 注册表与命名
- §2 统一接口与完整编码
- §3 EvalCache
- §4 Solver 生命周期
- §5 默认算法行为
- §6 初始化与邻域
- §7 算法适配和变体
- §8 Python 辅助边界与验收

## 1. 注册表与命名

`cpp/include/hfsp/registry.hpp` / `cpp/src/registry.cpp` 是唯一算法名称来源。默认键为：

```text
random_search, sa_basic, ma_basic, ig_basic, ga_basic, ts_basic
```

注册表的 value 是 C++ `SolverFunction`；状态表必须与键一一对应。只有经过 C++ smoke、`best_seq` 复现和可行性检查的实现才允许标记 `runnable_mvp`。未实现算法应明确为 `placeholder` 或 `not_verified`，不能被批处理脚本悄悄调用。

算法文件使用 `cpp/src/metaheuristics/{sa,ma,ig,ga,ts}/` 或集中实现文件；分支命名采用 `sa_basic_study_conditioned` 形式。Python 不得维护第二个注册表。

## 2. 统一接口与完整编码

所有 C++ 算法遵守：

```cpp
SolveResult solve_xxx(const Instance&, const SolveConfig&);
```

`SolveResult` 必须包含：

- `Schedule`：每个操作的 job、stage、machine、start、end；
- `Result`：算法名、有限 objective、运行时间、seed、feasible、完整 `best_sequence`；
- `TracePoint` 序列：iteration、elapsed、objective。

编码至少包含作业排列和阶段机器分配。机器资源键必须是 `(stage_id, machine_id)`，不能只用 `machine_id`。decoder 必须拒绝重复/缺失 job、非法机器或不满足 eligibility 的分配。

## 3. EvalCache

所有会重复评估候选解的算法必须创建独立 `EvalCache(500)`：

| 项 | 约定 |
|---|---|
| 容量 | 固定 500 |
| 淘汰 | FIFO |
| 键 | `make_eval_key(instance_id, job_sequence, machine_assignment)` |
| 生命周期 | 一个算例 × 一个算法 × 一轮 |

缓存不能跨算法、跨算例或跨轮次共享。Python 分析阶段不创建求解缓存，也不把 pandas 缓存结果当作 C++ 评估缓存。

## 4. Solver 生命周期

公共 C++ solver 负责：

```text
validate Instance / time limit
  -> reset run state
  -> create deterministic std::mt19937_64
  -> create isolated EvalCache
  -> run algorithm-specific search
  -> check best schedule and feasibility
  -> write SolveResult / trace
```

每次调用都重置 trace、best、iteration、cache 和 RNG。时间限制用 `std::chrono::steady_clock`；不得用日志打印消耗随机流。公共评估入口是唯一允许调用 decoder 的位置。

## 5. 默认算法最小行为

- `random_search`：生成合法 job permutation 和机器分配，保留真实最优 pair。
- `sa_basic`：初始解先评估并记录，再对邻域使用 Metropolis 接受准则；温度有正下界。
- `ig_basic`：破坏—修复后更新 current，而不只是更新 best；小规模序列安全。
- `ts_basic`：tabu 语义记录 job 身份或完整 move；支持优于全局 best 的 aspiration。
- `ga_basic`：交叉、变异后仍为合法 permutation；精英保留不改变种群大小。
- `ma_basic`：局部搜索候选必须走同一 EvalCache 入口，不能自行解码。

上述行为必须在 C++ 中实现并测试。Python 只能读取结果，不得以同名函数提供替代实现。

## 6. 初始化与邻域

初始化和邻域是 C++ 可复用组件：单解生成器与种群生成器使用不同类型，不能混用。长度小于 2 时 swap/insert/reverse 必须返回副本或安全终止，不能通过重复随机抽样造成死循环。若论文算法需要额外资源、可选路线或重入操作，先更新 `Instance`、encoding、decoder、checker 和 MIP，再写算法。

## 7. 算法适配和变体

适配文献算法时：

1. 在 `docs/*_algorithm_design.md` 记录来源、真正实现的差异和参数；
2. 在 C++ 中提取初始化、邻域和评价策略，避免复制逻辑；
3. 新编码同步更新序列化、缓存键、decoder、checker、result reproducer 和 C++ 测试；
4. 新约束同步更新 checker 与 Gurobi C++ MIP，二者语义一致；
5. 注册新 C++ solver，先标 `not_verified`，验证后才能升级；
6. 每个改进组件增加消融记录，Python 只负责汇总消融输出。

不保留旧接口 shim、双格式或双语言求解器。接口变更必须一次性更新全部 C++ 调用点。

## 8. Python 辅助边界与验收

允许的 Python 模块：`python/tools/` 算例生成、`python/analysis/` 结果汇总、`python/statistics/` 统计检验、`python/visualization/` 绘图。它们只能消费 C++ 产物，且必须对缺失文件、非法 JSON 和路径穿越显式失败。

每个 C++ 注册算法验收：

1. demo 上运行成功；
2. 评估缓存 miss 大于 0，且容量/隔离符合约定；
3. `best_sequence` 可稳定序列化；
4. 用 `best_sequence` 重新 decode 的 objective 与结果一致；
5. schedule 通过 checker；
6. trace 包含初始 best，时间和 objective 有限；
7. 产物全部写入项目 `outputs/`。

未经 C++ smoke 和项目审计，不得在 `IMPLEMENTATION_STATUS.md` 或 `PROJECT_AUDIT.md` 中写 PASS。

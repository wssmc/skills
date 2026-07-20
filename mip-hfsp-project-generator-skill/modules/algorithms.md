# 模块：算法规范

## 导航

- §1 注册表与命名
- §2 统一接口与完整编码
- §3 EvalCache
- §4 BaseSolver 生命周期
- §5 默认算法最小行为
- §6 初始化与邻域
- §7 算法适配和变体
- §8 可复现性与验收

## 1. 注册表与命名

基础算法注册名与文件名保持一致：

| 注册名 | 工厂函数 | 文件 |
|---|---|---|
| `random_search` | `solve_random_search` | `baselines/baseline_template.py` |
| `sa_basic` | `solve_sa_basic` | `sa/sa_basic.py` |
| `ma_basic` | `solve_ma_basic` | `ma/ma_basic.py` |
| `ig_basic` | `solve_ig_basic` | `ig/ig_basic.py` |
| `ga_basic` | `solve_ga_basic` | `ga/ga_basic.py` |
| `ts_basic` | `solve_ts_basic` | `ts/ts_basic.py` |

`src/metaheuristics/registry.py` 是唯一算法名称来源：

```python
ALGORITHM_REGISTRY = {
    "random_search": solve_random_search,
    "sa_basic": solve_sa_basic,
    "ma_basic": solve_ma_basic,
    "ig_basic": solve_ig_basic,
    "ga_basic": solve_ga_basic,
    "ts_basic": solve_ts_basic,
}

ALGORITHM_STATUS = {name: "runnable_mvp" for name in ALGORITHM_REGISTRY}
```

`ALGORITHM_STATUS` 与 registry 的键必须完全相同。占位算法不得注册。命名层级使用 `{parent}_{variant}`：例如 `sa_basic` → `sa_basic_study` → `sa_basic_study_conditioned`。

## 2. 统一接口与完整编码

所有算法工厂遵守：

```python
solve_xxx(instance, time_limit, seed=None, **kwargs)
    -> (Schedule, trace, best_seq)
```

其中：

- `Schedule.objective` 是有限数值，且已由统一指标函数写入。
- `trace` 为 `[{"iteration": int, "time": float, "objective": float}, ...]`。
- `best_seq` 必须是 JSON 可序列化字典，包含 `job_sequence` 与 `machine_assignment`。
- `machine_assignment` 序列化为记录列表，例如 `[{"job_id": 0, "stage_id": 1, "machine_id": 0}]`；不得把 tuple 作为 JSON 对象键。

完整编码由两部分组成：

```text
job_sequence: 每个 job 恰好一次的排列
machine_assignment[(job_id, stage_id)]: 该工序选择的阶段内机器
```

decoder 必须拒绝重复/缺失 job、缺失机器分配或不符合 eligibility 的机器。机器资源键是 `(stage_id, machine_id)`，不能只用 `machine_id`，因为不同阶段允许重复编号。

## 3. EvalCache

所有会重复评估候选解的算法必须通过 `EvalCache`：

| 项 | 约定 |
|---|---|
| 容量 | 固定 500 |
| 淘汰 | FIFO |
| 键 | `make_eval_key(instance, job_sequence, machine_assignment)` |
| 值 | 目标值 |
| 生命周期 | 每次“算例 × 算法 × 轮次”独立创建 |

标准逻辑：

```python
key = make_eval_key(instance, sequence, assignment)
cached = cache.get(key)
if cached is not None:
    return cached
schedule = decode(sequence, assignment, instance)
value = evaluate_schedule(instance, schedule)["makespan"]
cache.put(key, value)
return value
```

禁止事项：

- 只创建缓存但仍直接调用 decoder；
- 键中遗漏机器分配或算例身份；
- 用 `kwargs.get("cache") or EvalCache(...)` 接收空缓存，因为空缓存可能因 `__len__` 被误判；应显式判断 `is None`；
- 跨算法、跨算例或跨轮次共享同一实例。

若测试注入缓存，必须是容量 500 的空缓存。生产 runner 不暴露跨任务缓存注入。

## 4. BaseSolver 生命周期

五个 basic 元启发式使用 `BaseSolver` 管理公共生命周期，算法子类只实现 `_solve()`：

```text
solve()
  -> validate instance / time limit
  -> reset all mutable run state
  -> create deterministic RNG
  -> create isolated EvalCache
  -> _solve()
  -> assert best schedule exists
  -> return schedule, trace, JSON-safe best_seq
```

公共职责：

- `evaluate(sequence, assignment)`：唯一候选评估入口；
- `record_best(...)`：同时保存 schedule、sequence 与 assignment；
- `elapsed()` / `time_exceeded()`：使用 `time.perf_counter()`；
- `log_iteration(...)`：只有在 best 已建立后才能调用；
- 每次 `solve()` 重置 trace、best、iteration、cache 和 RNG，避免复用 solver 对象污染下一次运行。

初始化日志不得通过 `rng.random()` 展示“seed”，因为这会消耗随机流并改变结果。

## 5. 默认算法最小行为

### 5.1 `random_search`

循环生成合法随机排列和机器分配，经缓存评估并保存真实最优 assignment。返回的 best assignment 必须对应最优 sequence，不能误用最后一次循环的 assignment。

### 5.2 `sa_basic`

- 初始解评估并登记 best 后才进入日志；
- 每个邻居只计算一次 Metropolis 接受判定；
- 接受后更新 current，改进时更新 best；
- 温度下界避免除零，并遵守时间上限。

### 5.3 `ig_basic`

- 对 current 执行破坏—修复；
- 修复候选通过缓存评估；
- 接受后必须更新 current，而不只是 best；
- 删除规模和小规模序列边界必须安全。

### 5.4 `ts_basic`

- 邻域 move 使用 job 身份描述，不用易漂移的位置下标作为 tabu 语义；
- 支持 aspiration：优于全局 best 的 tabu move 可接受；
- tabu 队列与集合淘汰保持一致；
- 序列长度小于 2 时安全终止。

### 5.5 `ga_basic` / `ma_basic`

- 初始化必须使用 population 生成器；
- 交叉、变异后个体仍为 job permutation；
- 精英保留不改变种群大小；
- MA 的局部搜索候选走同一缓存评估入口；
- 种群大小、精英数和小规模实例边界经过校验。

## 6. 初始化与邻域

初始化严格分层：

| 类型 | 路径 | 返回值 | 使用者 |
|---|---|---|---|
| 单解 | `initial/single/` | `list[int]` | random_search、SA、IG、TS |
| 种群 | `initial/population/` | `list[list[int]]` | GA、MA |

`neh.py` 必须做真实插入评估，不得只按总工时排序却声称 NEH。基础 HFSP 的候选评估可以使用每阶段首个 eligible 机器；若问题扩展后这一假设不成立，NEH 也必须适配。

通用邻域放入 `neighborhood/operators.py`：swap、insert、reverse 等。随机选择两个位置时，长度小于 2 直接返回副本，禁止用 `while i == j` 造成无限循环。

## 7. 算法适配和变体

适配论文算法时：

1. 明确来源与差异，不把论文名贴到未实现的近似算法上。
2. 初始化提取到 `initial/single/` 或 `initial/population/`，主算法通过 import 使用。
3. 新编码同步更新序列化、缓存键、decoder、result reproducer 和测试。
4. 新约束同步更新 feasibility checker 与 MIP；二者语义必须一致。
5. 注册新工厂函数，并把状态设为 `not_verified`，验证后才升为 `runnable_mvp`。
6. 每个改进组件必须有消融记录。

变体优先使用组合或配置注入，不强制建立深层继承树。无论实现方式如何，外部接口、结果格式和验收标准保持一致。

## 8. 可复现性与验收

公平对比要求：

- 相同算例、轮次与算法使用种子表中的确定性 seed；
- 单解算法与种群算法分别统一初始化方法，不混用生成器；
- 所有算法使用相同时间预算公式与缓存容量/淘汰策略；
- 缓存内容相互隔离；
- 运行顺序不能改变单个任务的结果。

每个注册算法的验收：

1. 在 demo 上运行成功；
2. cache misses 大于 0，证明实际走过缓存评估；
3. `best_seq` 能被 `json.dumps(..., allow_nan=False)` 序列化；
4. 由 `best_seq` 重新 decode 的 objective 与结果一致；
5. schedule 通过 `check_feasibility`；
6. trace 至少包含初始 best，时间和 objective 有限且不倒退到更差 best；
7. 结果文件写入项目 `outputs/` 内。

上述检查由 `tests/smoke_test.py` 与 `scripts/audit_project.py` 执行。未经运行，不得在状态或审计报告中写 PASS。

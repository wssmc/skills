# 模块：脚本与执行

## 导航

- §1 执行链
- §2 单次与对比运行
- §3 批量实验
- §4 MIP 与扩展实验
- §5 失败、续跑与产物契约
- §6 推荐执行顺序

## 1. 执行链

生成项目只有两个直接 Python 求解入口：

```text
scripts/run_baselines.py          -> 元启发式与 random_search
scripts/mip/run_gurobi_mip.py     -> Gurobi MIP
```

Shell 脚本只负责组合参数，不复制求解逻辑：

```text
sh_single_instance.sh ─┐
sh_bench_instance.sh  ─┼─> run_baselines.py -> registry -> solver
sh_batch_instances_algorithms.sh ┘
```

统一数据流：

```text
load_instance(dir)
  -> solver(instance, time_limit, seed, ...)
  -> (Schedule, trace, best_seq)
  -> check_feasibility
  -> JSON / CSV / PNG
```

## 2. 单次与对比运行

### 2.1 `run_baselines.py`

示例：

```bash
python scripts/run_baselines.py \
  --inst data/demo/demo_01_10_5 \
  --algo sa_basic \
  --time 30 \
  --seed 42 \
  --out outputs/single
```

`--algo` 必须是注册表中的精确名称。默认注册：

```text
random_search
sa_basic
ma_basic
ig_basic
ga_basic
ts_basic
```

每个任务写出：

```text
{out}/{instance}/{algo}_result.json
{out}/{instance}/{algo}_schedule.json
{out}/{instance}/{algo}_trace.csv
{out}/{instance}/{algo}_gantt.png
```

启用 `--txt` 时额外保存 JSON 可序列化的 `best_seq`。不得从 schedule 反推编码。

### 2.2 `sh_single_instance.sh`

```bash
bash scripts/sh_single_instance.sh \
  --inst data/demo/demo_01_10_5 \
  --algo sa_basic \
  --time 30 \
  --seed 42
```

脚本以 Bash 数组传参，禁止 `eval`。底层求解、可行性校验或绘图失败时，脚本必须返回非零状态。

### 2.3 `sh_bench_instance.sh`

```bash
bash scripts/sh_bench_instance.sh data/demo/demo_01_10_5
bash scripts/sh_bench_instance.sh data/demo/demo_01_10_5 sa_basic ig_basic
```

未显式给算法时，从 `get_runnable_algorithms()` 读取全部可运行算法。注册表是唯一名称来源。

### 2.4 `sh_analysis.sh`

```bash
bash scripts/sh_analysis.sh outputs/batch/<batch-name>
```

脚本递归读取 `*_result.json`，写出 `analysis_summary.csv`。若目录不存在、没有结果或 JSON 无效，返回非零状态。它不依赖一个并未生成的外部分析包。

## 3. 批量实验

```bash
bash scripts/sh_batch_instances_algorithms.sh small 0.1 \
  --batch-name experiment_01 \
  --rounds 7 \
  --unified-init y
```

批量规则：

1. 默认顺序执行，当前模板不宣称并行能力。
2. 时间上限为 `max(1, int(num_jobs * num_stages * factor))`。
3. 每轮每个算例使用确定性运行种子，种子表写入 `data/batch_seeds/{scale}/round{r}.json`。
4. `--unified-init y` 只统一同类算法的初始化配置；单解与种群初始化仍严格分开。
5. 每个“算例 × 算法 × 轮次”运行创建独立 `EvalCache(max_size=500)`。禁止跨任务共享缓存。
6. 结果位于 `outputs/batch/{batch_name}/round{r}/{scale}/...`。

断点续跑以单个 `{algo}_result.json` 存在且非空为判断条件。使用相同 `--batch-name` 才会续跑同一批次；不得用“整轮目录非空”跳过未完成任务。

## 4. MIP 与扩展实验

### 4.1 Gurobi MIP

```bash
python scripts/mip/run_gurobi_mip.py \
  --inst data/demo/demo_01_10_5 \
  --time 60 \
  --out outputs/mip
```

唯一默认 MIP 脚本是 `run_gurobi_mip.py`。输出必须区分无解、未找到可行解和已有 incumbent；非有限目标、下界与 gap 写为 JSON `null`，不得输出 `NaN`/`Infinity`。

### 4.2 DOE、消融与统计

默认模板包含：

```text
scripts/doe/run_doe.py
scripts/doe/sh_doe.sh
scripts/ablation/quick_test_config.py
scripts/statistics/run_statistics.py
```

这些入口只允许报告实际实现的能力。统计模块使用 Friedman、配对 Wilcoxon signed-rank 和多重比较校正；依赖缺失或数据不满足检验条件时必须明确失败。

## 5. 失败、续跑与产物契约

- 核心求解、解码、可行性检查、序列化和必需绘图不能被 `except Exception: pass` 吞掉。
- CLI 参数错误返回状态码 2；运行失败返回非零状态。
- 所有输出路径必须解析到项目 `outputs/` 内，拒绝路径穿越。
- `result.json` 使用 `allow_nan=False`，并保存算法名、算例、目标、运行时间、种子和可行性状态。
- `best_seq` 必须能重新解码出与 result 相同的目标，并通过 `check_feasibility`。
- 新增并行前必须实现进程隔离、任务级错误传播、独立缓存和确定性结果路径，并增加回归测试。

## 6. 推荐执行顺序

```bash
python tests/smoke_test.py
python scripts/audit_project.py
bash scripts/sh_single_instance.sh --inst data/demo/demo_01_10_5 --algo sa_basic
bash scripts/sh_bench_instance.sh data/demo/demo_01_10_5
bash scripts/sh_batch_instances_algorithms.sh small 0.1 --batch-name experiment_01
bash scripts/sh_analysis.sh outputs/batch/experiment_01
```

只有 smoke 与审计均成功后，才能把 `IMPLEMENTATION_STATUS.md` 中对应模块改为 `runnable_mvp` 或 `complete`。

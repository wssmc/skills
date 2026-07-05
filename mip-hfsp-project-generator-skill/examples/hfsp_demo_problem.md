# HFSP demo problem

有 10 个 Job，5 个 Stage。每个 Job 必须依次经过 Stage_0 到 Stage_4。
每个 Stage 内有若干台并行机，同一机器同一时刻只能加工一个 Job。
允许等待，不允许抢占。
目标函数默认最小化 makespan；若存在 due date，可扩展为 makespan + total tardiness。

工时数据使用 `processing_times.txt` 的 JobID × Stage 表。

## 项目结构对应

- 数据目录: `data/demo/demo_01_10_5/`
- 数据生成: `data/generate.py`（不在算例生成时传 seed）
- 数据读取: `data/loader.py` → `load_instance(dir) -> Instance`
- MIP 求解: `src/math_models/gurobi_model.py`（Gurobi 实现）
- 元启发式: `src/metaheuristics/{sa,ma,ig,ga,ts}/` 各 basic 版本
- 脚本入口: `scripts/run_baselines.py`（中央调度枢纽）
- MIP 独立入口: `scripts/mip/run_gurobi_mip.py`

## 运行命令

```bash
# 单算例单算法
bash scripts/sh_single_instance.sh --inst demo_01_10_5 --algo sa_basic --time 30

# 单算例多算法对比
bash scripts/sh_bench_instance.sh demo_01_10_5 sa_basic ig_basic ts_basic

# Gurobi MIP 求解
python scripts/mip/run_gurobi_mip.py --inst data/demo/demo_01_10_5 --time 60
```

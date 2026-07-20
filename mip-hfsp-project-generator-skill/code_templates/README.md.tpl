# {{project_name}}

基于 Gurobi 与 Python 的基础混合流水车间调度（HFSP）研究工程。

## 支持边界

本项目直接支持：所有作业依次经过相同阶段、每阶段有并行机、加工时间为 `p[j][s]`、允许等待、不允许抢占、作业间没有额外 precedence、以 makespan 为目标。

若 `configs/problem_fingerprint.json` 标记为 `adapter_required`，必须先完成领域模型、数据格式、编码、解码、可行性检查、MIP 和回归测试适配；当前基础结果不能代表扩展问题已实现。

## 安装

需要 Python 3.10 或更高版本。

```bash
python -m pip install -r requirements.txt
```

Gurobi MIP 还需要可用的 Gurobi license。元启发式和 smoke 测试不依赖 Gurobi license。

## 数据与种子

```bash
python data/generate.py --base-dir . --master-seed 42
```

每个算例的 `index.json` 记录 `instance_seed`；算法运行 seed 独立记录在 `data/batch_seeds/`。

## 验证

```bash
python tests/smoke_test.py
python scripts/audit_project.py
```

`PROJECT_AUDIT.md` 初始为 `NOT_RUN`。只有审计脚本成功后才可把对应状态标为 PASS。

## 运行

```bash
python scripts/run_baselines.py \
  --inst data/demo/demo_01_10_5 \
  --algo sa_basic \
  --time 30 \
  --seed 42

python scripts/mip/run_gurobi_mip.py \
  --inst data/demo/demo_01_10_5 \
  --time 60
```

默认注册算法：`random_search`、`sa_basic`、`ma_basic`、`ig_basic`、`ga_basic`、`ts_basic`。每个算法运行使用独立的 500 项 FIFO 评估缓存。

批量与分析命令见 `AGENTS.md` 和 `docs/`。所有运行产物必须写入 `outputs/`。

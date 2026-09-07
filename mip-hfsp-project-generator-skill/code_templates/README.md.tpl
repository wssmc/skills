# {{project_name}}

基于 C++17 与 Gurobi C++ API 的基础混合流水车间调度（HFSP）研究工程。Python 只用于算例生成、结果分析、统计和可视化。

## 语言边界

- `cpp/`：Instance、编码/解码、checker、目标函数、EvalCache、SA/MA/IG/GA/TS、registry 和 MIP。
- `python/`：txt 算例、JSON/CSV 汇总、统计、绘图和报告；不实现第二套求解器。
- `AGENTS.md`：本项目级系统提示词。任何生成、修改、审计和运行前先读取它。

## 支持边界

本项目直接支持：所有作业依次经过相同阶段、每阶段有并行机、加工时间为 `p[j][s]`、允许等待、不允许抢占、作业间没有额外 precedence、以 makespan 为目标。

若 `configs/problem_fingerprint.json` 标记为 `adapter_required`，必须先完成 C++ 领域模型、数据格式、编码、解码、可行性检查、MIP 和回归测试适配。

## 构建与验证

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
python scripts/audit_project.py
```

Gurobi MIP 需要可用的 Gurobi C++ API、`GUROBI_HOME` 和 license。缺少时只能报告 `NOT_RUN`。

## 数据、运行与分析

```bash
python python/tools/generate_instances.py --output data/demo/demo_01_10_5 --jobs 10 --stages 5 --seed 42
build/hfsp_run data/demo/demo_01_10_5 sa_basic
python python/analysis/analyze_results.py --input outputs --output outputs/analysis_summary.csv
```

默认注册算法：`random_search`、`sa_basic`、`ma_basic`、`ig_basic`、`ga_basic`、`ts_basic`。每次运行使用独立的 500 项 FIFO C++ EvalCache。所有结果必须写入 `outputs/`，Python 只能读取 C++ 产物。

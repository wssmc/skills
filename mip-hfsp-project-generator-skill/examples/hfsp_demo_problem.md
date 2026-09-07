# HFSP demo problem

有 10 个 Job，5 个 Stage。每个 Job 必须依次经过 Stage_0 到 Stage_4；每个 Stage 内有若干台并行机，同一机器同一时刻只能加工一个 Job。允许等待，不允许抢占。目标函数默认最小化 makespan；若存在 due date，可扩展为 makespan + total tardiness。

工时数据使用 `processing_times.txt` 的 JobID × Stage 表。

## 项目结构对应

- 数据目录：`data/demo/demo_01_10_5/`
- 数据生成：`python python/tools/generate_instances.py --output data/demo/demo_01_10_5 --jobs 10 --stages 5 --seed 42`
- 数据读取：C++ `cpp/src/io/instance_loader.cpp`
- MIP：C++ Gurobi API 适配器
- 元启发式：`cpp/src/metaheuristics/{sa,ma,ig,ga,ts}/`
- 分析：`python/analysis/analyze_results.py`

## 运行命令

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
build/hfsp_run data/demo/demo_01_10_5 sa_basic
python python/analysis/analyze_results.py --input outputs --output outputs/analysis_summary.csv
```

生成、修改或审计前先读取项目根目录的 `AGENTS.md`；它是项目级系统提示词。

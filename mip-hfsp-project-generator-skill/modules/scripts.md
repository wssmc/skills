# 模块：脚本与执行

## 1. 执行链

核心执行链必须是 C++：

```text
python/tools/generate_instances.py
        ↓ txt + index.json
cmake --build build
        ↓ hfsp_run -> C++ registry -> solver -> decoder/checker
        ↓ result.json / schedule.csv / trace.csv / best_seq.json
python/analysis/analyze_results.py
        ↓ summary.csv / statistics / figures
```

Python 脚本不得调用或复制 C++ 算法逻辑；shell 只组合参数并传播失败状态。

## 2. 构建与单次运行

推荐入口：

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
build/hfsp_run data/demo/demo_01_10_5 sa_basic
```

Windows 使用 `build/Release/hfsp_run.exe`，具体路径必须写入项目根 `AGENTS.md`。`hfsp_run` 从 C++ 注册表读取精确算法名；未知名称、非法算例或不可行结果都返回非零状态。

每个任务输出：

```text
outputs/single/{instance}/{algo}_result.json
outputs/single/{instance}/{algo}_schedule.csv
outputs/single/{instance}/{algo}_trace.csv
outputs/single/{instance}/{algo}_best_seq.json
```

## 3. 批量实验

`scripts/run_batch.sh` 顺序调用 C++ runner：

1. 读取 `data/batch_seeds/{scale}/round{r}.json`；
2. 每个“算例 × 算法 × 轮次”传入独立 seed 和 time limit；
3. 失败立即返回非零状态，不以空文件或整轮目录掩盖失败；
4. 只有单个 `{algo}_result.json` 已存在且有效时才允许断点续跑；
5. 不跨任务共享 EvalCache。

Python 的 `python/analysis/analyze_results.py` 递归读取 C++ JSON/CSV，输出 `analysis_summary.csv`。目录不存在、没有结果或 JSON 不合法时必须失败。

## 4. MIP 与扩展实验

MIP 入口是 C++ `hfsp_run --mip` 或独立的 C++ app，使用 Gurobi C++ API。没有 license 或 `GUROBI_HOME` 时，脚本必须报告 `NOT_RUN`，不能回退到 `gurobipy` 伪装成功。DOE、消融和统计脚本只负责传参、收集和分析已生成的结果。

## 5. 失败、续跑与产物契约

- 核心求解、解码、checker、序列化和必要输出失败必须传播到 shell/CLI 的非零退出码。
- JSON 不得写 `NaN`/`Infinity`；结果中的 `best_sequence` 必须能重新解码。
- 所有输出路径必须解析到项目 `outputs/` 内，拒绝路径穿越。
- Python 分析不能修改 C++ 结果或“修正”目标值；发现错误应停止并回到 C++ 根因修复。
- 预计超过一小时的批量任务必须后台运行，并记录 PID、日志和重启命令到 `docs/`。

## 6. 推荐执行顺序

```bash
python python/tools/generate_instances.py --output data/demo/demo_01_10_5 --jobs 10 --stages 5 --seed 42
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
build/hfsp_run data/demo/demo_01_10_5 sa_basic
python python/analysis/analyze_results.py --input outputs --output outputs/analysis_summary.csv
python scripts/audit_project.py
```

只有 C++ smoke、Python 分析检查和项目审计均成功后，才能把状态改为 `runnable_mvp` 或 `complete`。

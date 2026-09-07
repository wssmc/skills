# AGENTS.md - 项目级系统提示词

> 本文件不是普通 README。每次生成、修改、审计或运行项目前，先读取本文件以及当前目录适用的 AGENTS.md。它记录本项目的可执行规则，架构变化必须同步更新。

## 项目目的
{project_purpose}

## 问题类型
{problem_type}

## 核心语言边界

- **C++17（主体）**：`cpp/` 负责 Instance、编码/解码、checker、metrics、EvalCache、SA/MA/IG/GA/TS、注册表和 Gurobi C++ MIP。
- **Python 3（辅助）**：`python/tools/` 负责 txt 算例，`python/analysis/`、`python/statistics/`、`python/visualization/` 负责结果分析、统计和绘图。
- Python 不得重新实现 C++ solver、decoder、feasibility checker 或 objective，不得建立第二个算法注册表。

## 构建与运行

```text
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
```

Windows 运行 `build/Release/hfsp_run.exe`；Unix 运行 `build/hfsp_run`。所有结果写入项目内 `outputs/`。

## 脚本约定

| 关键词 | 入口 | 用途 |
|---|---|---|
| build | CMake | 构建 C++ 核心 |
| single | `scripts/run_single.sh` | 单算例单算法 |
| batch | `scripts/run_batch.sh` | 多算例、多轮顺序运行 |
| analysis | `python/analysis/analyze_results.py` | 汇总 C++ JSON/CSV |
| mip | C++ MIP app | Gurobi C++ API 精确求解 |

脚本只传递参数并传播非零状态，不复制算法逻辑。预计超过一小时的任务必须后台运行并记录日志。

## 算法注册表

唯一入口：`cpp/include/hfsp/registry.hpp` + `cpp/src/registry.cpp`。

- 默认注册名：`random_search`、`sa_basic`、`ma_basic`、`ig_basic`、`ga_basic`、`ts_basic`
- 只有通过 C++ smoke、checker 和 `best_sequence` 重放的实现才能标 `runnable_mvp`
- 占位或未验证算法必须明确标记，不能被批处理悄悄运行

## 评估与缓存

- 每个“算例 × 算法 × 轮次”独立创建 `EvalCache(500)`，FIFO 淘汰
- 键必须包含算例身份、作业序列和机器分配
- `best_sequence` 必须由 C++ solver 直接保存，禁止从 schedule 反推
- C++ 输出 `result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`

## 数据与适配门禁

- 主体数据使用 txt，`index.json` 只做索引；Python 生成，C++ loader 读取
- 基础 HFSP 以外的 FJSP/JSP/重入/额外资源特征，必须同步更新 C++ Instance、编码、解码、checker、MIP 和回归测试，并在 fingerprint 中标记状态

## 占位策略

- 占位模块必须有 `PLACEHOLDER.md`
- 占位入口必须显式 `raise`/抛出明确错误
- 未验证功能不能写 PASS，不能静默返回伪结果

## 禁止路径和红线

以下旧路径不得生成：`src/algorithms/`、`src/solvers/`、`src/io/`、`src/evaluation/`、Python 元启发式核心目录。

- 不按算例名、job ID 或阶段数打补丁
- 不用裸 `catch`、静默异常、跳过失败测试
- 不保留旧接口 shim、模块 alias、旧路径 fallback 或双格式迁移层
- Python 分析失败必须返回非零状态，不得修改 C++ 结果

## 约定持久化与维护

- 用户澄清、假设、算法选择和实验设置写入 `docs/` 或 `configs/conventions.md`
- 新约定立即同步本文件；架构变化同步 `README.md`、`IMPLEMENTATION_STATUS.md`、`PROJECT_AUDIT.md` 和项目树
- 交付前必须运行 C++ smoke、Python 分析检查和项目审计

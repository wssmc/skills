# AGENTS.md - 项目级系统提示词

> 每次生成、修改、审计或运行前必须先读取本文件及当前目录适用的 AGENTS.md。它不是普通 README，而是本项目范围内的工程规则来源。

## 语言边界

- **C++17 主体**：`cpp/` 负责领域模型、编码/解码、可行性检查、目标函数、EvalCache、SA/MA/IG/GA/TS、registry 和 Gurobi MIP。
- **Python 辅助**：`python/tools/` 生成 txt，`python/analysis/`、`python/statistics/`、`python/visualization/` 分析 C++ 结果。
- Python 不得重复实现 solver、decoder、checker、objective 或第二个 registry。

## 构建命令

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
ctest --test-dir build --output-on-failure
```

## 注册与输出

- 唯一算法注册入口：`cpp/include/hfsp/registry.hpp` + `cpp/src/registry.cpp`
- 默认算法：`random_search`、`sa_basic`、`ma_basic`、`ig_basic`、`ga_basic`、`ts_basic`
- 结果必须写入 `outputs/`：`result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`
- 每个任务独立 `EvalCache(500)`，FIFO，键包含实例、序列和机器分配

## 数据与质量

- txt 是主体数据，`index.json` 只做索引；Python 生成，C++ loader 读取
- 基础 HFSP 以外的特征必须同步更新 C++ Instance、编码、解码、checker、MIP 和测试
- 未验证功能使用 `not_verified` 或 `placeholder`，不能写 PASS 或静默返回伪结果
- 不按特殊算例打补丁，不保留旧接口 shim、旧路径 fallback 或双格式迁移层
- Python 分析失败必须返回非零状态，不得修改 C++ 结果

## 约定持久化

用户澄清、默认假设、算法选择和实验设置必须立即写入 `configs/conventions.md` 或 `docs/`。架构变化同步本文件、`README.md`、`IMPLEMENTATION_STATUS.md`、`PROJECT_AUDIT.md` 和项目树。

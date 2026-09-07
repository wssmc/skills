# 模块：项目结构规范

## 0. 语言边界（必须先读）

生成项目采用“双语言、单方向依赖”架构：

| 内容 | 唯一实现语言 | 规则 |
|---|---|---|
| 领域模型、编码、解码、可行性检查、目标函数、EvalCache、SA/MA/IG/GA/TS、MIP 适配器 | C++17 | 编译为 `hfsp_core`；算法状态和求解结果只能在 C++ 中产生 |
| 算例生成、结果汇总、统计、绘图、报告 | Python 3 | 只能读写约定的 txt/JSON/CSV 产物，不实现第二套求解器或解码器 |
| 编排 | CMake + shell/轻量 Python CLI | 只传递参数，不复制算法逻辑 |

Python 不能为了“方便分析”重新实现 C++ 的 decoder、feasibility checker、objective 或算法。C++ 求解器必须输出稳定的 `result.json`、`schedule.csv`、`trace.csv` 与 `best_seq.json`，Python 分析工具只消费这些文件。

## 1. 顶层目录结构

```text
project_name/
├── CMakeLists.txt
├── cmake/                         # 可选：Gurobi C++ API 检测和平台配置
├── cpp/
│   ├── include/hfsp/
│   │   ├── core/domain.hpp        # Instance / Operation / Schedule / Result
│   │   ├── io/instance_loader.hpp
│   │   ├── encoding/              # 编码契约
│   │   ├── decoding/              # decoder / checker / metrics / EvalCache
│   │   ├── metaheuristics/        # C++17 solver、SA/MA/IG/GA/TS
│   │   ├── math_models/            # Gurobi C++ MIP 接口
│   │   └── registry.hpp            # 唯一算法注册入口
│   ├── src/                       # 与 include 对应的实现
│   ├── apps/hfsp_run.cpp          # 求解 CLI
│   └── tests/smoke_test.cpp       # C++ 冒烟测试
├── python/
│   ├── tools/generate_instances.py # 只负责 txt 算例生成/索引
│   ├── analysis/analyze_results.py # 结果汇总、统计入口
│   ├── statistics/                 # Friedman/Wilcoxon 等
│   └── visualization/              # 甘特图、收敛曲线、对比图
├── scripts/
│   ├── build.sh / build.ps1
│   ├── run_single.sh
│   ├── run_batch.sh
│   ├── analyze_results.py          # Python 分析 CLI 薄包装
│   └── audit_project.py            # 只审计，不实现算法
├── data/                           # txt 算例、index.json、batch_seeds
├── configs/                         # 自然语言规范；仅 fingerprint 用 JSON
├── docs/                            # 决策、假设、算法和实验记录
├── outputs/                         # 唯一实验输出根目录
├── latex/
├── requirements.txt                # 仅 Python 辅助依赖
├── AGENTS.md
├── IMPLEMENTATION_STATUS.md
├── PROJECT_AUDIT.md
└── README.md
```

`src/`、`gurobipy`、Python 元启发式目录不是默认生成路径。仓库内的旧 Python 模板如需参考，必须明确标为非默认参考，不能被物化到新项目。

## 2. 数据层

- 主体数据仍使用 txt；`index.json` 只串联文件、规模、种子和元信息。
- `python/tools/generate_instances.py --master-seed N` 生成 `instance_seed`；算法运行 seed 单独保存于 `data/batch_seeds/`。
- C++ `instance_loader` 读取规范化 txt，并把数据转成唯一的 `hfsp::Instance`。Python 不得创建第二个运行时 `Instance`。
- demo 必须包含可由 C++ runner 直接加载的小算例；生成后先运行 C++ smoke。

## 3. C++ 核心层

### 3.1 领域模型

`cpp/include/hfsp/core/domain.hpp` 至少定义 `Instance`、`Operation`、`Schedule`、`Result` 和 `TracePoint`，并在边界处校验维度、正加工时间和机器数量。

### 3.2 解码、可行性与缓存

`cpp/include/hfsp/decoding/` 是唯一评估入口。decoder 必须维护作业前序、阶段资源和机器不重叠；checker 与 decoder 使用同一套资源键 `(stage_id, machine_id)`。每个“算例 × 算法 × 轮次”独立创建 `EvalCache(500)`，FIFO 淘汰，键包含算例身份、作业序列和机器分配。

### 3.3 元启发式与 MIP

- `cpp/include/hfsp/metaheuristics/` 和 `cpp/src/metaheuristics/` 实现 SA、MA、IG、GA、TS 及基线；`Solver` 返回统一的 `SolveResult`。
- `cpp/include/hfsp/registry.hpp` / `cpp/src/registry.cpp` 是唯一算法注册入口；只有实际通过 C++ smoke 的算法才能标为 runnable。
- MIP 使用 Gurobi C++ API。若本机未配置 `GUROBI_HOME`，MIP 模块必须标为 `not_verified` 或 `placeholder`，不能用 Python `gurobipy` 冒充核心实现。

## 4. Python 辅助层

Python 只做四类工作：txt 算例与索引生成、结果 JSON/CSV 汇总、统计检验、图表/报告。辅助脚本必须拒绝路径穿越，失败返回非零状态，并把产物写入 `outputs/`。不得在 Python 中再次计算 makespan 或修复不可行排程；如发现核心结果错误，应回到 C++ 根因修复。

## 5. configs、outputs、docs 和 LaTeX

- `configs/` 存放自然语言项目规范；`problem_fingerprint.json` 是唯一默认 JSON 配置。
- `outputs/` 是唯一实验输出根目录，禁止写项目外路径。
- `docs/` 记录问题澄清、建模假设、C++ 算法设计、实验计划和根因修复。
- `latex/` 只引用已生成并审计的结果，不把 Python 图表脚本当作求解实现。

## 6. AGENTS.md：项目级系统提示词

每个生成项目根目录必须有 `AGENTS.md`。它不是普通 README，也不是可选的“记忆笔记”，而是该项目范围内优先级最高的本地工程指令：

1. 修改或生成任何代码前，先读取根目录及当前子目录适用的 `AGENTS.md`。
2. 它明确 C++/Python 语言边界、CMake 构建命令、算法注册入口、输出目录、禁止路径、状态语义和质量红线。
3. 当本文件与通用默认约定冲突时，以项目 `AGENTS.md` 为准；但不能违反上游安全约束。
4. 每次用户作出新的实现约定，立即同步 `AGENTS.md`、`configs/conventions.md` 或 `docs/`，避免依赖对话记忆。
5. 架构变化后必须同步更新 `AGENTS.md`、`README.md`、`IMPLEMENTATION_STATUS.md` 和项目树。

这就是“系统提示词遗忘”问题的解决办法：把可执行规则写入项目内的 AGENTS 文件，并在生成、修改、审计三处设置读取门禁。

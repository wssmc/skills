# 模块：项目结构与问题数据模型

## 1. 通用工程边界

本 Skill 生成的是“问题特定核心 + 通用实验外壳”：

| 层 | 语言 | 职责 |
|---|---|---|
| 问题核心 | C++17 | 问题数据模型、解表示、构造/解码、评价、可行性、启发式算法 |
| Python 层 | Python 3 | 算例生成、CPLEX MIP、汇总、统计、绘图、报告 |
| 编排 | Bash | 构建、测试、固定种子运行、批处理、分析、审计 |

除 CPLEX 精确模型外，Python 不能复制 C++ 的求解语义。Bash 不能包含算法逻辑。项目不生成 EvalCache。

## 2. 推荐目录

~~~text
project_name/
├── CMakeLists.txt
├── cpp/
│   ├── include/scheduling/
│   │   ├── core/domain.hpp        # 问题数据模型与结果契约
│   │   ├── io/instance_loader.hpp
│   │   ├── representation/        # 候选解表示
│   │   ├── evaluation/            # 构造/解码、目标、checker
│   │   ├── algorithms/
│   │   └── registry.hpp
│   ├── src/
│   ├── apps/solver_run.cpp
│   └── tests/smoke_test.cpp
├── python/
│   ├── tools/generate_instances.py
│   ├── math_models/solve_cplex.py
│   ├── analysis/analyze_results.py
│   ├── statistics/
│   └── visualization/
├── scripts/
│   ├── build.sh
│   ├── generate_instances.sh
│   ├── run_single.sh
│   ├── run_batch.sh
│   ├── run_all.sh
│   ├── analyze.sh
│   ├── lib/allocate_result_root.sh
│   └── audit.sh
├── data/
├── configs/
│   └── seeds/
│       └── solve_seeds.txt
├── docs/
│   └── convergence_protocol.md
├── outputs/
│   ├── tmp/
│   └── formal/
├── latex/
├── AGENTS.md
├── IMPLEMENTATION_STATUS.md
├── PROJECT_AUDIT.md
└── README.md
~~~

生成器可以根据项目替换 scheduling 命名空间和文件名，但 C++/Python/Bash 三层职责不能混淆。

## 3. 问题数据模型

问题数据模型是对研究对象的最小 C++ 表达。它通常包括：

- ProblemInstance：静态输入、资源、参数和 validate()；
- CandidateSolution：算法直接操作的解表示；
- Operation/DecisionRecord：一次决策或安排；
- Solution/Schedule：完整可行解；
- Objective/Violation：目标和约束违反信息；
- SolveConfig：时限、round、solve_seed 和算法参数；
- SolveResult：状态、目标、界、gap、运行时间和可重放解。

这些类型必须来自问题描述。非调度问题不应被迫使用 Job、Stage、Machine；流水车间参考模型也不能成为所有项目的父类。

## 4. 当前流水车间参考

当前参考代码可以定义 FlowShopInstance，包含：

- job 与 stage；
- 每阶段并行机；
- processing time；
- instance_seed；
- 可选 release time、due date、eligibility 或 machine-dependent time。

FPSP/FSP/PFSP/HFSP 的具体含义必须在项目 docs/problem_model.md 中定义。名称相似不代表数据结构和约束相同。

## 5. 数据与种子

- 主体算例数据使用 txt；index.json 只保存索引和元信息。
- 每个算例目录必须保存 instance_seed。
- 求解种子由 configs/seeds/solve_seeds.txt 提供，一行一个十进制无符号整数。
- N 轮实验要求文件中恰好 N 个不重复种子；种子列表本身纳入版本控制。
- 同一 round 的所有算法使用相同 solve_seed。

## 6. 输出

所有结果只能写入项目 outputs/。推荐目录：

~~~text
outputs/tmp/...                                  # 烟测、调试、待审阅曲线
outputs/formal/{test_id}[__changed-params][_N]/ # 与正式测试脚本一一对应
└── {instance}/{algorithm}/round_{round}_seed_{solve_seed}/
    ├── result.json
    ├── solution.json
    ├── schedule.csv
    └── trace.csv
~~~

非调度问题可以省略 schedule.csv，但必须提供能够重放和检查的 solution.json。

`{test_id}` 等于正式测试脚本文件名。参数改变时追加明确的 `key-value` 标签；脚本与参数都未改变的重复运行依次追加 `_1`、`_2`。不得覆盖已有正式目录。底层 runner 未收到 `SCHED_OUTPUT_ROOT` 时只能写入 outputs/tmp/unclassified/。

## 7. AGENTS.md

每个生成项目都必须有 AGENTS.md。它负责记录：

- 当前问题类型和问题数据模型；
- C++、Python、Bash 边界；
- CPLEX Python API 配置与运行方式；
- 固定种子文件和轮次规则；
- registry、可执行程序和输出路径；
- 状态语义、禁止事项和验证命令。

新约定出现时立即同步 AGENTS.md、configs/conventions.md 或 docs/。架构变更时同步 README、IMPLEMENTATION_STATUS、PROJECT_AUDIT 和项目树。

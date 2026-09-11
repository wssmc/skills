# {{project_name}}

可复现的 C++17 核心调度/运筹研究工程。MIP 使用 IBM 官方低层 `cplex` Python API，Python 还负责算例和分析，Bash 统一组织构建、固定种子实验、分析和审计。

## 问题模型

当前问题：{{problem_type}}

问题数据模型定义在 cpp/include/scheduling/core/domain.hpp，并在 docs/problem_model.md 解释实体、资源、参数、候选解、可行性和目标。当前流水车间代码只是参考适配，不代表项目自动支持全部调度问题。

## 核心规则

- C++ 负责启发式求解、评价、checker 和 registry。
- 每算法独立 .cpp，共享评价与运行支持按职责拆分；一条语句一行，使用 .clang-format 统一格式。
- AGENTS.md 内嵌完整规则；configs/required_agent_rules.json 用于逐节完整性审计，规则补充写在管理块外。
- Python 只做算例、CPLEX MIP、汇总、统计、绘图和报告。
- 不使用 EvalCache。
- 每个算例记录 instance_seed。
- N 轮实验使用 configs/seeds/solve_seeds.txt 中恰好 N 个固定 seeds。
- 烟测、调试和待审阅曲线写入 outputs/tmp/。
- 正式脚本 `{test_id}.sh` 写入 outputs/formal/{test_id}/；改参数用 RESULT_VARIANT 标在目录名，未改配置的重复运行自动追加 `_1`、`_2`。

## 执行

~~~bash
scripts/build.sh
ctest --test-dir build --output-on-failure
scripts/generate_instances.sh data/demo/demo_01 10 5 1009
scripts/run_single.sh data/demo/demo_01 sa_basic 104729 1
scripts/run_batch.sh data/demo configs/seeds/solve_seeds.txt
RESULT_VARIANT=time-limit-600 scripts/run_batch.sh data/demo configs/seeds/solve_seeds.txt
scripts/run_mip.sh data/demo/demo_01 104729 1
scripts/analyze.sh
scripts/format.sh
scripts/format.sh --check
scripts/audit.sh
~~~

配置 CPLEX Python API：

~~~bash
PYTHON=/path/to/python scripts/run_mip.sh data/demo/demo_01 104729 1
~~~

所选 Python 无法 import cplex 或 license 不可用时，CPLEX 状态必须为 NOT_RUN。audit.sh 只检查项目、种子、语法、C++ 构建/测试和 CPLEX import 状态，不安装求解器或改动实验结果。

CPU 收敛事件、100 点离线采样和绘图规则见 docs/convergence_protocol.md。

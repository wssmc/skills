# AGENTS.md - 项目级系统提示词

> 生成、修改、运行或审计前先读取本文件及当前目录适用的 AGENTS.md。架构和实验约定变化后同步更新。

## 项目与问题模型

- 项目目的：{project_purpose}
- 问题类型：{problem_type}
- 当前 C++ 问题数据模型：{problem_model_types}
- 直接支持范围：{supported_scope}
- 尚需适配：{adapter_required_scope}

问题数据模型只表达当前研究需要的实体、资源、参数、候选解和结果，不建立容纳所有调度问题的万能类。

<!-- BEGIN REQUIRED RESEARCH RULES -->

## 规则完整性

- 本规则块必须完整保留在根 AGENTS.md 内，不得缩写成摘要或仅链接其他文档。项目补充和经用户确认的例外写在块外并说明对应规则；子目录 AGENTS.md 不得静默放宽这些约定。
- configs/required_agent_rules.json 保存生成时的逐节规则基线；审计逐节核对正文，不能只检查标题或关键词。规则变更须同步生成源、AGENTS.md、基线和相关文档，不得删除基线来绕过检查。

## 语言边界

- C++17：问题数据模型、解表示、评价、checker、启发式算法、registry 和结果。
- Python 3：算例生成、结果汇总、统计、绘图和报告；CPLEX MIP 是唯一求解例外。
- Bash：构建、生成数据、单次运行、固定种子批量实验、分析和审计。
- Python 不得实现 CPLEX MIP 以外的第二套 solver、decoder、checker、objective 或 registry。
- 项目不使用 EvalCache 或跨任务隐藏缓存。

## C++ 文件组织与格式

- 每个算法的主流程独立放在 cpp/src/algorithms/<algorithm>.cpp，头文件声明接口；禁止把多个算法主体集中到 algorithms.cpp、main.cpp 或单一巨型头文件。
- 问题数据模型、解表示、评价/checker、公共算子、运行支持、输入输出与 registry 按职责拆分；算法调用共享模块，不复制评价逻辑。runner 只解析参数、分派调用和处理退出状态。
- 一条语句一行；语句结束的分号后换行。for (...) 头部的分号、字符串和注释中的分号不作机械拆分。
- 函数体、循环体、条件分支和 lambda 体展开多行；禁止压缩多个语句到一行。使用 4 空格缩进，建议行宽 100，长表达式按语法换行。
- 提供 .clang-format 和 scripts/format.sh；交付前执行格式化与只读检查。格式工具缺失标 NOT_RUN，不能宣称格式检查通过；仍须人工检查逐语句换行和职责拆分。
- docs/algorithm_design.md 列出算法主文件、共享模块与调用关系；拆分后同步 CMake 源文件清单并验证编译、注册调用和固定种子重放。

## C++ 求解契约

- 使用统一 solve(problem, config) 接口；SolveConfig 显式携带 solve_seed、round、时限和算法参数，每次调用创建局部 std::mt19937_64，不共享随机状态。
- 所有候选解经过同一 C++ evaluator/checker 入口；直接维护并保存可重放的最优解，不从最终 schedule 反推。
- registry 只注册实际实现；算法集合来自当前问题和文献依据，不强制凑齐算法名，不以别名包装其他算法冒充实现。

## MIP

- 唯一默认 MIP：IBM 官方低层 `cplex` Python API，位于 python/math_models/。
- 禁止 Gurobi、gurobipy 和 docplex 回退。
- 当前 Python 无法 import cplex 或 license 不可用时写 NOT_RUN，不能写 PASS。
- CPLEX 变量、约束、目标和 checker 必须使用同一问题语义。
- 显式设置 time limit、threads=1、random seed=当前 round 的 solve_seed；输出 status、incumbent、best bound、gap、runtime 和可重放解，无 incumbent 写 JSON null。

## 种子

- 算例种子：每个算例目录内的 instance_seed.txt，并同步记录在 index.json
- 求解种子：configs/seeds/solve_seeds.txt
- N rounds 必须恰好提供 N 个固定、非重复 solve seeds。
- 同一 round 的比较算法使用同一个 solve seed。
- runner 必须显式接收 solve_seed 和 round；结果必须记录 instance_seed、solve_seed 和 round。
- 禁止用时间、进程号、random_device、shell RANDOM 或隐式全局随机状态生成实验 seed；固定种子清单纳入版本控制。
- txt 保存算例主体；index.json 保存索引与元信息。结果至少包含 instance_id、instance_seed、algorithm、round、solve_seed、objective、runtime、feasible。

## 构建与执行

~~~bash
scripts/build.sh
ctest --test-dir build --output-on-failure
scripts/generate_instances.sh <output> <jobs> <stages> <instance_seed>
scripts/run_single.sh <instance> <algorithm> <solve_seed> <round>
scripts/run_batch.sh <instance_root> configs/seeds/solve_seeds.txt [algorithms...]
scripts/run_all.sh <instance_root> configs/seeds/solve_seeds.txt [algorithms...]
scripts/run_mip.sh <instance> <solve_seed> <round>
scripts/analyze.sh
scripts/format.sh --check
scripts/audit.sh
~~~

CPLEX 使用可 import cplex 的 Python；需要指定解释器时设置 PYTHON=/path/to/python。Bash 统一编排，不配置 Concert C++ 链接。

所有 Bash 入口使用 set -euo pipefail，定位项目根目录、正确引用参数、拒绝缺失/重复/非法种子，并传播子任务非零退出码。Bash 只编排，不实现算法。

## 注册与输出

- 唯一 registry：cpp/include/scheduling/registry.hpp 与 cpp/src/registry.cpp
- runner：solver_run；CPLEX runner：python/math_models/solve_cplex.py
- 所有烟测、调试和临时收敛图放在 outputs/tmp/，不得混入正式结果。
- 正式测试脚本 scripts/.../{test_id}.sh 对应 outputs/formal/{test_id}/；一个结果目录只能对应一个脚本。
- 参数变化后重测，目录名追加可读参数标签，例如 `{test_id}__time-limit-600__population-100`；标签必须写出实际变化。
- 参数与脚本均未变化的重复运行，不覆盖旧结果，依次追加 `_1`、`_2`。
- 正式目录保存脚本路径/版本、有效参数和 seeds；底层 runner 默认写 outputs/tmp/unclassified，正式脚本必须设置 SCHED_OUTPUT_ROOT。
- 最小产物：result.json、solution.json、schedule.csv、trace.csv
- 算法清单由当前问题和文献依据决定；未验证算法不能标 runnable。

## 进度更新

- 使用低频、事件驱动更新：工具任务开始、定位/实现/验证等里程碑、影响结论的新发现、失败/阻塞/授权、最终完成。
- 不逐命令、编译单元、seed、算例或 round 汇报；30 秒内普通事件合并，重复状态不复述。
- 长时间批量实验无新事件时每 2 小时报告一次阶段和运行状态，提前完成或失败立即报告；其他长任务最多约每 60 秒一条心跳。
- 中间更新保持 1–3 行；最终答复必须自包含。

## CPU 收敛曲线

{{CONVERGENCE_PROTOCOL}}

## 质量红线

- 不生成 Concert C++、Gurobi、docplex、EvalCache 或 CPLEX MIP 以外的 Python 核心求解器。
- 不按特殊算例写补丁，不静默异常，不跳过失败测试，不返回伪结果。
- 不保留旧接口 shim、双格式或旧路径 fallback。
- 任何问题模型变化必须同步更新 loader、evaluator、checker、algorithms、CPLEX、serialization、Bash 和 tests。
- 所有输出位于项目 outputs/。

## 验证与交付

- 状态仅使用 complete、runnable_mvp、placeholder、not_applicable、not_verified；未实际验证的算法不得标 runnable。PASS/FAIL/NOT_RUN 必须有实际证据。
- C++ 检查覆盖模型 validate、loader 维度、评价/checker、全部 runnable 注册算法、固定种子重放、不同种子元数据、solution 重评价、结果字段、输出路径和非法输入非零退出。
- Bash 检查覆盖 N rounds/N seeds、缺失/重复/非法 seed、跨算法配对、失败传播、烟测目录和正式目录版本隔离；Python 检查覆盖生成、CPLEX 语法/输入、汇总、统计前置条件和路径。
- 缺陷按“根因分析 → 修复契约与全部调用点 → 回归验证 → 审计 → 记录”处理；缺少 CPLEX 环境不阻止 C++ 独立验证。
- 最终逐项报告规则完整性、C++ 拆分/格式、CMake/C++ build、C++ tests、Bash seed/batch、Python checks、CPLEX import、CPLEX run/license、Project audit 的 PASS/FAIL/NOT_RUN，以及可运行算法、种子清单和未完成适配。

## 持久化

用户澄清、默认假设、问题模型、算法、实验轮数和种子约定写入 configs/ 或 docs/。交付前更新 README.md、IMPLEMENTATION_STATUS.md、PROJECT_AUDIT.md 和 docs/root_cause_fix_log.md。

必须维护 configs/problem_statement.md、configs/problem_fingerprint.json、configs/conventions.md、docs/problem_model.md、docs/algorithm_design.md、docs/experiment_plan.md。问题文档写明实体/资源/参数、解表示、可行性、目标、CPLEX 与 C++ 一致性、直接支持和未适配范围；文献算法记录来源、技术差异、初始化/算子/参数、随机数消费、公平预算与消融。缺少信息时显式保存假设，不把参考模板宣称为通用支持。

<!-- END REQUIRED RESEARCH RULES -->

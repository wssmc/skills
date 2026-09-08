---
name: mip-scheduling-project-generator-skill
description: 生成、改造和审计以 C++17 为核心、IBM CPLEX Python API 为 MIP 求解器的可复现调度与运筹研究工程。适用于把问题描述、问题画像和文献方法落地为问题数据模型、算法、精确模型、每算例一个生成种子、固定求解种子实验、Bash 批处理、Python 分析和论文产物；当前参考实现重点面向流水车间问题族，但不得把通用工程方法限制为 HFSP。
---

# MIP / Scheduling Research Project Generator

## 定位

本 Skill 是通用的调度与运筹研究工程生成方法，不是某一种问题的固定代码生成器。当前参考模板主要覆盖流水车间相关问题（FPSP/FSP/PFSP/HFSP 等），其他问题应根据输入重新定义问题模型、解表示、评价器、可行性检查、算法与 MIP。

推荐上游流程：

~~~text
problem-decomposition-skill
  -> literature-matrix-review-skill-v2.1
  -> mip-scheduling-project-generator-skill
~~~

输入不完整时，先输出缺失信息与明确的默认假设；不要用某个流水车间模板冒充通用支持。

## 强制架构

- **C++17 是核心**：问题数据模型、解表示、构造/解码、目标计算、可行性检查、启发式/元启发式、算法注册和结果序列化都在 cpp/。
- **Python 3 默认是辅助**：负责算例生成、结果汇总、统计检验、绘图和报告；不得实现第二套启发式、decoder、checker、objective 或 registry。
- **CPLEX MIP 是唯一求解例外**：精确模型使用 IBM 官方低层 `cplex` Python API，放在 python/math_models/。不使用 Concert C++、Gurobi、gurobipy 或 docplex。缺少 Python API/license 时标记 NOT_RUN。
- **不使用 EvalCache**：候选解由 C++ 评价入口直接计算。不得生成 EvalCache、eval_cache.* 或隐藏的跨运行缓存。
- **Bash 统一编排**：构建、单次运行、多轮批量实验、分析和审计由 scripts/*.sh 组织；脚本只传参、校验种子并传播非零退出码，不复制算法逻辑。
- **AGENTS.md 是项目级系统提示词**：生成、修改、运行和审计前读取；架构或实验约定变化后同步更新。

详细规范按任务读取：

- 项目与问题模型：modules/structure.md
- 算法、评价与 CPLEX：modules/algorithms.md
- Bash、种子与批量实验：modules/scripts.md
- CPU 收敛曲线与实验目录：modules/convergence.md
- 测试、状态和交付：modules/quality.md

## 什么是“问题领域模型”

“领域模型”在本 Skill 中改称**问题数据模型（problem model）**。它是 C++ 对研究问题的结构化表达，不是算法本身，也不是数据库模型。

它至少描述：

- 输入实体与资源，例如 Job、Operation、Machine、Stage、Vehicle 或 Worker；
- 参数，例如加工时间、路线、资格、容量、释放时间、交期和成本；
- 候选解的表示，例如排列、指派、路径或时间决策；
- 可行解和结果记录，例如 Schedule、Objective、Violation、SolveResult；
- 数据维度、取值范围和问题特定不变量的 validate()。

不要创建一个试图容纳所有问题的“万能大类”。先根据问题描述确定最小、明确、可验证的数据结构；流水车间参考模型只能作为适配示例。

## 随机种子契约

所有随机过程都必须可重放：

1. 算例生成必须显式接收 instance_seed，并写入算例目录的元数据。
2. 求解必须显式接收 solve_seed 和 round，不得使用时间、进程号或全局随机状态作为隐式种子。
3. N 轮实验必须提供恰好 N 个固定求解种子。10 rounds 就必须有 10 个 seeds。
4. 同一算例、同一轮次的不同算法使用同一个 solve_seed，形成配对比较。
5. 结果至少记录 instance_id、instance_seed、algorithm、round、solve_seed、objective、runtime 和 feasible。
6. 每个算例目录只保存自己的 instance_seed；固定求解种子清单建议使用 configs/seeds/solve_seeds.txt，并纳入版本控制。

## 问题分析与适配

生成代码前提取：

~~~text
问题类型与问题族
决策对象和资源
顺序、冲突和容量规则
参数与数据来源
目标与约束
候选解表示
随机性来源
精确模型和算法需求
缺失信息与默认假设
~~~

当前参考模板直接演示流水车间类问题。面对其他问题时，必须同步改变：

- 问题数据模型和数据格式；
- 解表示、构造/解码和评价器；
- 可行性检查；
- Python CPLEX 变量、约束和目标；
- 算法算子及注册；
- 回归测试、Bash 参数和输出字段。

任何一项未验证时，状态保持 not_verified 或 placeholder。

## C++ 求解规则

- 每个算法使用统一、显式的 solve(problem, config) 接口。
- SolveConfig 必须携带 solve_seed、round、时限和算法参数。
- 每次调用创建局部 std::mt19937_64，状态不能跨任务共享。
- 所有候选解经过同一个 C++ 评价入口，不设置通用缓存。
- 算法必须直接保存可重放的 best solution，禁止从最终 schedule 反推。
- 注册表是唯一算法名称来源；只注册实际实现，验证前不能标 runnable。
- 算法集合由问题与文献依据决定，不强制所有项目都生成 SA/MA/IG/GA/TS。

## CPLEX MIP 规则

- 使用 IBM 官方低层 `cplex` Python API；不使用 Concert C++ 或 docplex。
- MIP 的变量、约束和目标必须与 C++ 问题模型及 checker 使用同一组问题语义；Python 只承担模型适配，不建立第二套启发式框架。
- 显式设置 time limit、threads=1 和 CPLEX random seed；random seed 来自当前 round 的 solve_seed。
- CPLEX 状态、best bound、gap、runtime 和 incumbent 必须显式输出；无 incumbent 时使用 JSON null。
- `run_mip.sh` 检查当前 Python 是否可以 `import cplex`，然后调用 python/math_models/solve_cplex.py。
- Python API 或 license 缺失时报告 NOT_RUN，不得回退到其他求解器。

## Bash 执行规则

生成项目至少提供：

~~~text
scripts/build.sh
scripts/generate_instances.sh
scripts/run_single.sh
scripts/run_batch.sh
scripts/run_all.sh
scripts/run_mip.sh
scripts/analyze.sh
scripts/audit.sh
~~~

所有脚本使用 set -euo pipefail，解析项目根目录，引用参数，拒绝缺失或重复种子。批量输出按 instance/algorithm/round_seed 隔离，单次失败必须使批任务返回非零状态。烟测统一写入 outputs/tmp/；正式测试脚本与 outputs/formal/ 下的结果目录一一对应，参数变化写入目录标签，配置未变的重复运行追加 `_1`、`_2`，不得覆盖。

## 任务进度

生成的 AGENTS.md 使用低频、事件驱动更新：只在开始工具任务、完成里程碑、发现影响结论的信息、失败/阻塞/授权和最终完成时汇报。常规命令、seed、算例和 round 不逐项汇报；30 秒内普通事件合并。无新事件的批量实验每 2 小时报告一次，提前结束或失败立即报告；其他长任务最多约每 60 秒一条心跳。中间更新 1–3 行，最终答复自包含。

## CPU 收敛曲线

所有算法使用同一协议：正式进程 CPU budget 包含初始化；记录 `T_init,E_init,C_init`；初始化后维护唯一且不可重置的全局精英，只记录 `INIT`、严格改善的 `IMPROVE` 和经末值核验的 `END`。一次完整运行产生一条原始事件曲线，每个 seed 独立离线采样 100 个归一化时间点，前 50 点覆盖 `[0,0.2]`、后 50 点覆盖 `(0.2,1]`，前向保持且不插值。绘图使用右连续阶梯线并强制校验点数、单调性和首末值；临时收敛产物写 outputs/tmp/convergence/。完整公式和论文解释边界写入生成项目的 docs/convergence_protocol.md。

## 输出与文档

C++ 建议输出：

~~~text
result.json
solution.json
schedule.csv
trace.csv
~~~

目录分层：

~~~text
outputs/tmp/...                                           # 烟测、调试、待审阅曲线
outputs/formal/{test_id}[__changed-params][_N]/
  {instance}/{algorithm}/round_{round}_seed_{solve_seed}/
~~~

实际字段根据问题调整，但必须足以重放最优解和核对可行性。所有产物写入项目内 outputs/；Python CPLEX 适配器写精确求解结果，分析代码只读取结果并生成汇总、统计和图表。

最小文档：

~~~text
AGENTS.md
configs/problem_statement.md
configs/problem_fingerprint.json
configs/conventions.md
configs/seeds/solve_seeds.txt
docs/problem_model.md
docs/algorithm_design.md
docs/experiment_plan.md
docs/root_cause_fix_log.md
IMPLEMENTATION_STATUS.md
PROJECT_AUDIT.md
README.md
~~~

## 质量红线

- 不按算例名、特定 ID 或某次失败写局部补丁。
- 不静默吞异常，不跳过失败测试，不返回伪结果。
- 不保留旧接口 shim、双格式或旧路径 fallback；接口变更一次性迁移。
- 不生成 Concert C++、Gurobi、gurobipy、docplex 或 EvalCache。
- 不把 Python 分析代码当作核心求解实现。
- 不声称未构建、未运行或无 license 的模块已经 PASS。
- 缺陷按“根因分析 -> 修复契约和全部调用点 -> 回归测试 -> 审计 -> 记录”处理。

## 交付门禁

最终交付必须报告真实状态：

~~~text
CMake/C++ build: PASS/FAIL/NOT_RUN
C++ tests: PASS/FAIL/NOT_RUN
Bash batch seed validation: PASS/FAIL/NOT_RUN
Python auxiliary / CPLEX syntax checks: PASS/FAIL/NOT_RUN
CPLEX Python API/import/run: PASS/FAIL/NOT_RUN
Project audit: PASS/FAIL/NOT_RUN
Remaining problem-specific work: <list or none>
~~~

# AGENTS.md - 项目级系统提示词

> 生成、修改、运行或审计前先读取本文件及当前目录适用的 AGENTS.md。架构和实验约定变化后同步更新。

## 项目与问题模型

- 项目目的：{project_purpose}
- 问题类型：{problem_type}
- 当前 C++ 问题数据模型：{problem_model_types}
- 直接支持范围：{supported_scope}
- 尚需适配：{adapter_required_scope}

问题数据模型只表达当前研究需要的实体、资源、参数、候选解和结果，不建立容纳所有调度问题的万能类。

## 语言边界

- C++17：问题数据模型、解表示、评价、checker、启发式算法、registry 和结果。
- Python 3：算例生成、结果汇总、统计、绘图和报告；CPLEX MIP 是唯一求解例外。
- Bash：构建、生成数据、单次运行、固定种子批量实验、分析和审计。
- Python 不得实现 CPLEX MIP 以外的第二套 solver、decoder、checker、objective 或 registry。
- 项目不使用 EvalCache 或跨任务隐藏缓存。

## MIP

- 唯一默认 MIP：IBM 官方低层 `cplex` Python API，位于 python/math_models/。
- 禁止 Gurobi、gurobipy 和 docplex 回退。
- 当前 Python 无法 import cplex 或 license 不可用时写 NOT_RUN，不能写 PASS。
- CPLEX 变量、约束、目标和 checker 必须使用同一问题语义。

## 种子

- 算例种子：每个算例目录内的 instance_seed.txt，并同步记录在 index.json
- 求解种子：configs/seeds/solve_seeds.txt
- N rounds 必须恰好提供 N 个固定、非重复 solve seeds。
- 同一 round 的比较算法使用同一个 solve seed。
- runner 必须显式接收 solve_seed 和 round；结果必须记录 instance_seed、solve_seed 和 round。

## 构建与执行

~~~bash
scripts/build.sh
ctest --test-dir build --output-on-failure
scripts/generate_instances.sh <output> <jobs> <stages> <instance_seed>
scripts/run_single.sh <instance> <algorithm> <solve_seed> <round>
scripts/run_batch.sh <instance_root> configs/seeds/solve_seeds.txt [algorithms...]
scripts/run_all.sh <instance_root> configs/seeds/solve_seeds.txt [algorithms...]
scripts/run_mip.sh <instance> <solve_seed> <round>
~~~

CPLEX 使用可 import cplex 的 Python；需要指定解释器时设置 PYTHON=/path/to/python。Bash 统一编排，不配置 Concert C++ 链接。

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

- 所有算法遵循 docs/convergence_protocol.md；不得因算法、阶段或表示空间改变定义或移动初始化边界。
- 正式进程 CPU budget 包含初始化。记录 T_init、E_init、C_init；横轴从初始化结束开始，T_search=max(T_lim-T_init,0)，x=t_search/T_search。
- 初始化结束写 INIT；全局精英严格改善时才写 IMPROVE；多阶段算法共享一个不可重置的全局精英；结束写 END 并核验最终精英、返回 Cmax 和完整可行解一致。
- 原始事件字段固定为 event、cpu_search_s、cpu_total_s、evaluations、best_cmax、source；先写内存，结束后一次落盘。
- 一次完整运行生成一条曲线。对每个 seed 独立离线采样 100 点：前 50 点覆盖 [0,0.2]，后 50 点覆盖 (0.2,1]；取截止前最后精英并前向保持，不插值。
- 曲线用右连续阶梯图、Normalized time [0,1] 和统一纵轴；强制检查 100 点、单调不增、首点=C_init、末点=返回 Cmax。
- 新日志、采样表和图片先写 outputs/tmp/convergence/ 审阅，确认后才复制到对应正式测试目录；论文结论以正式多 seed 统计为准，单条曲线只作 representative profile。

## 质量红线

- 不生成 Concert C++、Gurobi、docplex、EvalCache 或 CPLEX MIP 以外的 Python 核心求解器。
- 不按特殊算例写补丁，不静默异常，不跳过失败测试，不返回伪结果。
- 不保留旧接口 shim、双格式或旧路径 fallback。
- 任何问题模型变化必须同步更新 loader、evaluator、checker、algorithms、CPLEX、serialization、Bash 和 tests。
- 所有输出位于项目 outputs/。

## 持久化

用户澄清、默认假设、问题模型、算法、实验轮数和种子约定写入 configs/ 或 docs/。交付前更新 README.md、IMPLEMENTATION_STATUS.md、PROJECT_AUDIT.md 和 docs/root_cause_fix_log.md。

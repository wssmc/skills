# 模块：质量保障与交付

## 1. 实现状态

允许状态：complete、runnable_mvp、placeholder、not_applicable、not_verified。未实际构建或运行的功能不能写 PASS。

CPLEX Python API 或 license 不可用时，CPLEX import/run 必须为 NOT_RUN；这不阻止 C++ 启发式核心完成独立测试。

## 2. 必须测试的契约

C++ 测试至少覆盖：

1. 问题数据模型 validate()；
2. loader 与数据维度；
3. 候选解评价和 checker；
4. registry 中所有 runnable 算法；
5. 固定 solve_seed 的可重复运行；
6. 不同 solve_seed 的结果元数据正确；
7. solution 重放后 objective 与 feasibility 一致；
8. round、instance_seed、solve_seed 正确写入结果；
9. 输出只能进入 outputs/；
10. 非法输入返回非零状态而不是未捕获异常。

Bash 测试至少覆盖：

- N rounds 与 N seeds 一致；
- 重复、缺失、非法 seed 被拒绝；
- 同一 round 跨算法使用相同 seed；
- 子任务失败能够传递到 run_batch.sh 和 run_all.sh；
- 脚本中不存在现场随机生成实验 seed 的逻辑。
- smoke 产物只能位于 outputs/tmp/；
- 正式结果目录能反查唯一测试脚本，改参标签与重复运行编号符合规则且不覆盖。

Python 测试覆盖算例生成、CPLEX 模型脚本语法与输入契约、汇总字段、统计前置条件和路径安全。没有 CPLEX 环境时只把 import/run 记为 NOT_RUN。

## 3. 禁止项审计

先对照生成源执行 scripts/render_agents.py <项目根目录> --check；项目侧 check_project_contracts.py 逐节比对 AGENTS 正文与规则基线，缺节或缺条款即 FAIL。人工审阅项目新增规则有无冲突，不能只检查标题或关键词。检查算法主流程分别位于独立 .cpp，审阅共享模块职责，并用 scripts/format.sh --check 检查源码格式；formatter 缺失为 NOT_RUN。

项目审计必须扫描并拒绝：

- Gurobi、gurobipy、docplex；
- EvalCache、eval_cache；
- CPLEX MIP 以外的 Python solver、decoder、checker、objective 或 registry；
- 静默异常、跳过失败测试和伪结果；
- 旧接口 shim、双格式和旧路径 fallback；
- 输出到项目外；
- smoke 写入正式目录、正式脚本共享或覆盖结果目录；
- 隐式时间种子、进程号种子、shell RANDOM。

允许在迁移记录中提到已删除技术，但生成代码和当前规则不能依赖它们。

## 4. 文档

必须维护 AGENTS.md、docs/problem_model.md、docs/algorithm_design.md、docs/experiment_plan.md、docs/root_cause_fix_log.md、configs/conventions.md、每算例的 instance_seed.txt、固定 solve seed 文件、IMPLEMENTATION_STATUS.md 和 PROJECT_AUDIT.md。

问题数据模型文档需要回答：

- 实体、资源和参数是什么；
- 候选解如何表示；
- 什么构成可行解；
- 目标如何计算；
- C++ evaluator/checker 与 CPLEX 如何保持一致；
- 当前模板直接支持什么，哪些仍需适配。

## 5. 缺陷处理

按以下顺序处理：

~~~text
定位根因
  -> 修改问题模型或核心逻辑
  -> 一次性更新全部调用点
  -> 增加回归测试
  -> 运行 C++、Bash、Python 和审计
  -> 更新 root_cause_fix_log
~~~

不为某个实例写特殊分支，不静默吞异常，不保留兼容层。

## 6. 交付摘要

最终摘要只能报告实际证据：

~~~text
CMake/C++ build: PASS/FAIL/NOT_RUN
C++ tests: PASS/FAIL/NOT_RUN
Bash seed/batch tests: PASS/FAIL/NOT_RUN
Python checks: PASS/FAIL/NOT_RUN
CPLEX Python API import: PASS/FAIL/NOT_RUN
CPLEX run/license: PASS/FAIL/NOT_RUN
Project audit: PASS/FAIL/NOT_RUN
Runnable algorithms: <names>
Seeds: <per-instance seed metadata; solve seed count and values/file>
Remaining adaptations: <list or none>
~~~

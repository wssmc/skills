# 模块：C++ 算法、评价与 CPLEX

## 1. 统一接口

每个算法实现统一的 C++ 接口：

~~~cpp
SolveResult solve(const ProblemInstance&, const SolveConfig&);
~~~

SolveConfig 至少包含 time_limit_seconds、solve_seed、round 和算法参数。每次运行使用局部 std::mt19937_64(solve_seed)，不得共享 RNG 状态。

## 2. 算法注册

registry 是唯一算法名称来源。只注册真实实现；placeholder 或未验证算法不能被批处理脚本调用。

算法集合由问题结构和文献依据决定。流水车间参考可包含 random_search、sa_basic、ig_basic、ts_basic、ga_basic、ma_basic，但这不是所有项目的强制清单。

## 3. 解表示与评价

- CandidateSolution 必须完整表达算法决策。
- evaluator 是目标与可行性检查的唯一入口。
- 每次评价直接执行，不生成 EvalCache 或 eval_cache 文件。
- best solution 由算法直接保存并序列化，不能从 schedule 反推。
- checker 与 evaluator 使用同一数据语义；结果写出前再次校核。

若性能不足，应优化数据结构、增量评价或算法本身，并为增量评价增加等价性测试；不得用隐式跨任务缓存改变实验语义。

## 4. 初始化和算子

初始化、邻域、交叉、变异、修复等组件应按候选解类型拆分并可复用。单解与种群初始化必须类型明确，不能通过复制同一对象制造伪种群。

文献算法适配必须记录：

- 原方法来源与实际技术差异；
- 解表示、初始化、算子和参数；
- 随机数消费位置；
- 与 baseline 的公平预算；
- 消融设计；
- 验证状态。

## 5. CPLEX Python API MIP

MIP 默认使用 IBM 官方低层 `cplex` Python API。这是 Python 可以参与求解的唯一例外；不使用 Concert C++ 或 docplex。

要求：

1. 变量、约束和目标来自当前问题数据模型。
2. checker 与 MIP 的可行性语义一致。
3. 使用显式 time limit、threads=1 和 CPLEX random seed；seed 来源于当前 round 的 solve_seed。
4. 输出 CPLEX status、incumbent、best bound、gap、runtime 和可重放解。
5. 无可行 incumbent 时目标与解字段写 null，不写伪大数。
6. 当前 Python 无法 import cplex 或 license 不可用时标 NOT_RUN。
7. 不生成 Concert C++、Gurobi、gurobipy 或 docplex 回退路径。

当前流水车间参考 MIP 可使用开始时间、机器指派、工序排序与 makespan 变量。其他问题必须重新定义模型，不能只改类名。

## 6. 复现实验

- 同一 instance、round 下所有算法使用同一个 solve_seed。
- 算法结果必须写入 instance_seed、solve_seed 和 round。
- 确定性算法也要记录 solve_seed，便于保持统一实验表结构。
- 重放测试使用 solution.json 重新评价并比较 objective 与 feasibility。

收敛日志必须使用进程 CPU budget 和统一初始化边界。初始化后只维护一个跨阶段全局精英，记录 `INIT`、严格改善的 `IMPROVE` 和经末值核验的 `END`；每个 seed 的单次完整运行再离线采样，具体见 modules/convergence.md。

## 7. 变更门禁

任何问题模型或候选解格式变化，都必须一次性更新 loader、evaluator、checker、algorithms、CPLEX、serialization、Bash 参数和 tests。不保留旧接口 shim 或双格式分支。

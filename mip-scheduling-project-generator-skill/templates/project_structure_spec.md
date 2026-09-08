# 项目结构规范

权威目录树见 code_templates/project_tree.txt，详细职责见 modules/structure.md。

必须满足：

- cpp/include/scheduling/ 下存放问题数据模型、评价、启发式算法和 registry。
- cpp/apps/solver_run.cpp 是统一求解入口。
- python/ 包含 tools、math_models、analysis、statistics 和 visualization；只有 math_models 可实现 CPLEX MIP。
- scripts/ 提供 Bash build/generate/single/batch/all/analyze/audit。
- 每个算例目录保存自己的 instance_seed.txt；configs/seeds/ 保存 solve seeds。
- outputs/ 是唯一结果根目录。

禁止：

- CPLEX MIP 以外的 Python solver、decoder、checker、objective 或 registry；
- Concert C++ 集成；
- Gurobi、gurobipy、docplex；
- EvalCache 或 eval_cache；
- 隐式时间种子；
- 在非流水车间问题中照搬 FlowShopInstance。

# 完整项目生成提示词模板

你是一名精通运筹优化、MIP、Gurobi、Python 工程化、基础混合流水车间调度（HFSP）、元启发式算法与论文实验设计的研究型代码助手。

请根据我提供的【问题描述】，生成一套完整可运行的 Python 项目。

## 强制要求

1. 主体数据必须使用 txt 保存，index.json 串联 txt 文件
2. 本模板直接支持基础 HFSP（每个作业依次经过全部阶段，每阶段并行机）；超出该范围的特征必须先实现并验证领域模型、编码、解码、可行性检查和 MIP 适配器
3. **MIP 默认使用 Gurobi**（`gurobipy`），不使用 CPLEX/docplex
4. 数据层: `data/generate.py` 生成算例，`data/loader.py` 统一 `load_instance(dir) -> Instance` 接口
5. 算例命名: demo 用 `demo_0x_n_m`，正式算例用 `inst_xxx_n_m_yy`
6. 算例生成必须显式接受并记录 `master_seed` 与每个算例的 `instance_seed`；实验运行种子另存于 `data/batch_seeds/`
7. `src/metaheuristics/` 组织算法（不用 `algorithms/`），含 initial/encoding/decoding/neighborhood/baselines/sa/ma/ig/ga/ts
8. `src/math_models/` 存放 Gurobi MIP 建模（不用 `solvers/`）
9. 评估逻辑（feasibility_checker, metrics, eval_cache, result_reproducer）放在 `decoding/` 下
10. 默认实现 SA, MA, IG, GA, TS 五个基础元启发式（basic 版本）
11. 算法命名: basic → basic_study → basic_study_xxx 三级，子算法带父算法前缀
12. 所有可运行算法注册到 `src/metaheuristics/registry.py`，`run_baselines.py` 从注册表读取
13. 三层脚本: `sh_single` → `sh_bench` → `sh_batch`，共享 `run_baselines.py`；sh_bench 默认运行所有已注册可运行算法
14. `configs/` 存放自然语言项目规范文档（不放 JSON）+ `problem_fingerprint.json`
15. 必须有 `AGENTS.md` 项目记忆索引（含占位策略、禁止路径、注册表、输出策略）
16. demo 算例必须能跑通
17. 每次算法运行使用独立 FIFO 缓存，大小限制 500；缓存键包含算例、序列和机器分配，禁止跨算法/跨算例共享
18. 所有结果必须经过 `check_feasibility` 校核
19. **算法返回 `(Schedule, trace, best_seq)`**，txt 输出保存 best_seq（不从 schedule 反推）
20. **算法分支命名带父算法前缀**（如 `sa_basic_study_conditioned`）
21. **生成后立即运行 smoke 测试** `python tests/smoke_test.py`
22. **算法打印遵循规范**（`[algo_name]` 前缀，verbose 分级）
23. **相似解码器输入输出一致**；不同编码类型（seq vs seq_machine）不强制一致
24. **旧版目录不得生成**（`src/algorithms/`、`src/solvers/`、`src/io/` 等），必须扫描并清除
25. **占位模块必须透明**：占位目录必须有 `PLACEHOLDER.md`，占位代码必须 raise NotImplementedError
26. **生成 `IMPLEMENTATION_STATUS.md`**，初始使用 not_verified；真实验证后才可改为 runnable_mvp / complete（另有 placeholder / not_applicable）
27. **先以 NOT_RUN 生成 `PROJECT_AUDIT.md`，再运行 `python scripts/audit_project.py` 写入真实结论**；任何失败必须返回非零状态
28. 对 problem fingerprint 中超出基础 HFSP 的特征，只有实现回归测试后才能标记支持；否则明确报告 `adapter_required`

## 问题描述

```text
在这里粘贴问题描述。
```

## 输出内容

请按以下顺序输出：

1. 问题理解与默认假设
2. `configs/` 项目规范文档（problem_statement.md, constraints_spec.md, algorithm_requirements.md, experiment_plan.md）
3. `configs/problem_fingerprint.json`（问题特征描述）
4. 项目结构（顶层目录树）
5. `data/generate.py` + `data/loader.py`
6. demo 算例数据
7. `src/core/domain.py` 领域模型（Instance, Schedule, Result, Operation, PrecedenceArc）
8. `src/metaheuristics/encoding/` 编码方案
8.5. `src/metaheuristics/decoding/` 解码方案 + feasibility_checker + metrics + eval_cache + result_reproducer
8.6. `tests/smoke_test.py` 冒烟测试（生成后立即运行）
9. `src/metaheuristics/initial/` 初始化方法
10. `src/metaheuristics/neighborhood/` 邻域算子
11. 5 个 basic 算法（SA, MA, IG, GA, TS）+ random_search 基线
12. `src/math_models/gurobi_model.py` + `lower_bound.py`
13. `src/visualization/` 可视化（gantt, convergence）
14. `src/metaheuristics/registry.py` 算法注册表
15. `scripts/run_baselines.py` + sh 脚本（single/bench/batch/analysis）
16. `scripts/mip/run_gurobi_mip.py`
17. `scripts/ablation/quick_test_config.py`
18. `tests/smoke_test.py`（覆盖跨阶段同号机器回归、全部注册算法、best_seq 复现与 JSON 序列化）
19. `AGENTS.md`
20. `IMPLEMENTATION_STATUS.md`（模块状态登记）
21. `PROJECT_AUDIT.md`（自动审计报告）
22. `README.md`
23. 运行命令
24. 审计摘要（测试、占位、可运行算法、旧版目录）

# mip-hfsp-project-generator-skill

本 Skill 用于根据 HFSP/HFFS 问题描述生成可运行、可验证、可扩展、面向论文的研究工程，包括 Gurobi MIP、txt 数据、编码解码、元启发式算法（SA/MA/IG/GA/TS）、三层脚本体系（single/bench/batch）、消融/DOE/统计检验、甘特图与收敛曲线、LaTeX 论文写作。

> **结构权威规范**：`项目通用结构总结.md`，本 Skill 的所有生成物严格遵循该规范。

推荐工作流：

```text
problem-decomposition-skill
→ literature-matrix-review-skill
→ mip-hfsp-project-generator-skill
```

## 推荐输入

来自 `problem-decomposition-skill`：

```text
refined_problem_description.md
problem_fingerprint.json
modeling_elements.md
assumption_log.md
data_requirement.md
handoff_to_mip_skill.md
```

来自 `literature-matrix-review-skill`：

```text
problem_feature_table.md
method_matrix_table.md
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
```

## 关键规则

- **默认求解器**：Gurobi（`gurobipy`），不再使用 CPLEX/docplex
- **数据层**：`data/generate.py` 生成算例，`data/loader.py` 统一 `load_instance(dir) -> Instance` 接口
- **算例命名**：demo 用 `demo_0x_n_m`，正式算例用 `inst_xxx_n_m_yy`
- **种子管理**：测试阶段读取 `data/batch_seeds/` 统一种子文件，与算例生成解耦
- **算法目录**：`src/metaheuristics/`（不用 `algorithms`），含 initial/encoding/decoding/neighborhood/baselines/sa/ma/ig/ga/ts
- **MIP 建模**：`src/math_models/`（Gurobi 实现，不走 solvers/）
- **评估层**：feasibility_checker / metrics / eval_cache / result_reproducer 放在 `decoding/` 下
- **算法命名**：basic → study → branch 三级；分支用独立文件固化开关
- **默认算法**：新问题默认实现 SA, MA, IG, GA, TS 五个基础元启发式
- **三层脚本**：`sh_single` (单×单) → `sh_bench` (单×多) → `sh_batch` (全×多轮)；共享 `run_baselines.py`
- **消融实验**：每次改进必须消融；每规模取第一个算例，固定种子，repeat=3
- **输出四件套**：`result.json` / `schedule.json|csv` / `trace.csv` / `gantt.png`
- **configs/**：存放自然语言项目规范文档（不再放 JSON）
- **AGENTS.md**：项目记忆索引，每次对话优先读取

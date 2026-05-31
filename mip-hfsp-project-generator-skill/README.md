# mip-hfsp-project-generator-skill

本 Skill 用于根据 HFSP/HFFS 问题描述生成可运行的研究工程，包括 CPLEX/docplex MIP、txt 数据、编码解码、baseline、本文算法、实验脚本、评价和甘特图。

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

- HFSP 默认使用 `JobID × Stage` 的 `processing_times.txt`；
- 主体数据保存为 txt；
- `index.json` 只用于串联文件；
- 默认使用 CPLEX/docplex；
- `src/` 必须模块化，区分 core、io、problems、solvers、algorithms、constraints、resources、evaluation、visualization；
- baseline 与 proposed algorithm 分开；
- 运输资源、人力资源、MUPs、setup 等约束以插件化方式扩展。

# literature-matrix-review-skill

本 Skill 用于从高质量问题描述或 `problem_fingerprint.json` 出发，检索相似文献，生成两张核心综述表：

1. 基于问题特征的对比表；
2. 基于方法流程 / 算子的对比矩阵。

推荐工作流：

```text
problem-decomposition-skill
→ literature-matrix-review-skill
→ mip-hfsp-project-generator-skill
```

## 推荐输入

优先接收前置 Skill 的输出：

```text
refined_problem_description.md
problem_fingerprint.json
assumption_log.md
open_questions.md
handoff_to_literature_skill.md
```

## 主要输出

```text
problem_fingerprint.json
search_queries.txt
screening_records.csv
paper_reading_cards.md
problem_feature_table.md
problem_feature_table.csv
method_matrix_table.md
method_matrix_table.csv
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
literature_review_draft.md
references.bib
```

## 下游衔接

输出的 `novelty_gap_summary.md`、`recommended_baselines.md` 和 `method_design_hints.md` 应交给 `mip-hfsp-project-generator-skill`，用于生成 baseline、proposed algorithm、实验脚本和可视化。

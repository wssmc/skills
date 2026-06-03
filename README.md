# Scheduling Research Skill Chain

本仓库包含三个互相衔接的 Skill：

```text
problem-decomposition-skill
→ literature-matrix-review-skill-v2.1
→ mip-hfsp-project-generator-skill
```

## 1. problem-decomposition-skill

把用户的一段初始想法，通过提问和结构化整理，转成高质量问题描述和 `problem_fingerprint.json`。

## 2. literature-matrix-review-skill-v2.1

基于高质量问题描述检索相似文献，输出问题特征表、方法矩阵表、研究缺口、baseline 建议和方法设计提示。

## 3. mip-hfsp-project-generator-skill

基于问题描述和文献矩阵，生成 HFSP 研究工程，包括 CPLEX/docplex MIP、txt 数据、编码解码、baseline、本文算法、实验和可视化。

## 推荐使用方式

先运行问题拆解，再做文献矩阵，最后生成 MIP/算法项目。不要直接从模糊描述跳到代码生成。

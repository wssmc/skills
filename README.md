# Scheduling Research Skill Chain

本仓库包含三个互相衔接的 Skill：

```text
problem-decomposition-skill
→ literature-matrix-review-skill-v2.1
→ mip-scheduling-project-generator-skill
```

## 1. problem-decomposition-skill

把用户的一段初始想法，通过提问和结构化整理，转成高质量问题描述和 `problem_fingerprint.json`。

## 2. literature-matrix-review-skill-v2.1

基于高质量问题描述检索相似文献，输出问题特征表、方法矩阵表、研究缺口、baseline 建议和方法设计提示。

## 3. mip-scheduling-project-generator-skill

基于问题描述和文献矩阵，生成通用调度与运筹研究工程：C++17 实现问题模型与启发式算法，IBM `cplex` Python API 实现 MIP，Python 还负责算例和分析，Bash 负责固定种子批量实验。当前参考实现主要面向流水车间问题族。

## 推荐使用方式

先运行问题拆解，再做文献矩阵，最后生成 MIP/算法项目。不要直接从模糊描述跳到代码生成。

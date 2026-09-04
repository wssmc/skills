# problem-decomposition-skill

本 Skill 用于把用户的一段初始问题描述，通过提问、澄清、结构化抽取和合理假设，转化为高质量的问题描述。

它是调度优化研究链路的第一步：

```text
problem-decomposition-skill
→ literature-matrix-review-skill
→ mip-hfsp-project-generator-skill
```

适用场景：

- 用户只有一段模糊的研究想法；
- 用户需要把业务问题转成可检索的学术问题；
- 用户需要把问题转成可建模、可实现、可实验的描述；
- 用户后续要做文献矩阵、MIP、启发式算法、甘特图、论文实验。

核心输出：

- `refined_problem_description.md`：高质量问题描述；
- `problem_fingerprint.json`：结构化问题画像；
- `modeling_elements.md`：集合、参数、变量、目标、约束；
- `assumption_log.md`：合理假设记录；
- `open_questions.md`：仍需用户确认的问题；
- `data_requirement.md`：数据字段和文件建议；
- `handoff_to_literature_skill.md`：给文献检索 Skill 的交接文件；
- `handoff_to_mip_skill.md`：给建模实现 Skill 的交接文件。

# Changelog

## v1.0.0

- Initial release.
- 定义问题拆解流程：原始描述 → 关键词抽取 → 问题类型判断 → 完整度评分 → 多轮提问 → 结构化输出。
- 支持三种提问轮次：核心建模问题、数据与实现问题、论文表达问题。
- 定义 0–5 分信息完整度评分标准。
- 输出 8 个结构化文件：`refined_problem_description.md`、`problem_fingerprint.json`、`modeling_elements.md`、`assumption_log.md`、`open_questions.md`、`data_requirement.md`、`handoff_to_literature_skill.md`、`handoff_to_mip_skill.md`。
- 提供 `checklists/`、`templates/`、`examples/`、`schemas/` 四类辅助资源。
- 衔接下游 `literature-matrix-review-skill` 和 `mip-scheduling-project-generator-skill`。

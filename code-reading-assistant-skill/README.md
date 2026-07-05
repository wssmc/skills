# code-reading-assistant-skill

本 Skill 用于帮助用户理解陌生代码库，即使用户的问题模糊、无法准确表达、只知道"大概哪里不懂"。通过建立临时阅读地图、推测用户意图、追踪结构/调用链/数据流，并给出下一步阅读建议，将模糊问题转化为清晰问题或结论。

灵感来自 Understand Anything 的"知识图谱 + 语义搜索 + guided tour + 上下文问答"思路，但不需要搭建完整 dashboard 或图数据库。

适用场景：

- 不知道从哪里读项目；
- 不知道如何向 AI 提问；
- 想理解文件/函数/模块职责；
- 想追踪一个功能的入口、调用链、数据流；
- 想评估某个 diff 或修改的影响面；
- 给新人做 onboarding 导览。

核心输出：

- 临时阅读地图（模块、关键实体、关系、不确定点）；
- 分层代码解释（L1 一句话 → L5 风险建议）；
- 调用链 / 数据流追踪；
- 模糊问题改写建议；
- 下一步阅读路线。

## 推荐使用方式

### 方式 1：作为 ChatGPT / Claude / Codex 自定义指令

复制 `SKILL.md` 的内容，放入 custom instruction / project instruction / agent instruction。

### 方式 2：作为项目级阅读助手

把这个目录放进项目的 `.ai/skills/code-reading-assistant-skill/` 或类似目录中，在需要阅读代码时提示 AI：

```text
启用 code-reading-assistant-skill。请先建立临时阅读地图，再解释代码。
```

### 方式 3：作为 Claude Code / AI Coding CLI 的辅助规则

将 `SKILL.md` 放到对应工具的 skill/rules/instructions 目录中。不同工具目录名可能不同，按你的工具文档放置即可。

## 文件说明

- `SKILL.md`: 主技能说明。
- `manifest.json`: 技能元信息。
- `examples/`: 示例提示词。
- `CHANGELOG.md`: 版本变更记录。

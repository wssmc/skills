# AGENTS.md 生成入口

唯一规则模板为 [code_templates/AGENTS.md.tpl](../code_templates/AGENTS.md.tpl)，完整收敛细则来自 [convergence_protocol.md.tpl](../code_templates/docs/convergence_protocol.md.tpl)。本文件仅导航，不是可复制的摘要模板。

读取完整模板后，执行本 skill 的 `scripts/render_agents.py <项目根目录>`，生成包含全部条款的 AGENTS.md 和 configs/required_agent_rules.json。填写管理块外的项目字段。既有项目先 `--check`，明确合并差异并保留用户补充，不直接覆盖。

交付前执行 `scripts/render_agents.py <项目根目录> --check`、项目的 `scripts/format.sh --check` 和 `scripts/audit.sh`；缺失规则、单文件多算法或压缩代码均不得交付为 PASS。

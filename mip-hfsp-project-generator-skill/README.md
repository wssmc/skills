# mip-hfsp-project-generator-skill

本 Skill 生成“C++17 核心 + Python 辅助”的基础 HFSP/HFFS 研究工程：C++ 负责领域模型、编码/解码、可行性检查、EvalCache、SA/MA/IG/GA/TS、注册表和 Gurobi C++ MIP；Python 只负责 txt 算例生成、结果分析、统计、绘图和报告。

> 结构权威规范：`modules/structure.md`。生成项目根目录的 `AGENTS.md` 是项目级系统提示词，生成、修改和审计前必须先读取。

内置模板只保证基础 HFSP。FJSP、JSP、重入、机器相关工时及额外资源约束必须先扩展 C++ 领域模型、解码、校验、MIP 和测试。

推荐工作流：

```text
problem-decomposition-skill
→ literature-matrix-review-skill-v2.1
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

来自 `literature-matrix-review-skill-v2.1`：

```text
problem_feature_table.md
method_matrix_table.md
novelty_gap_summary.md
recommended_baselines.md
method_design_hints.md
```

## 关键规则

- **核心语言**：C++17；使用 CMake 构建，`cpp/` 是唯一求解实现
- **辅助语言**：Python 3；只放 `python/tools/`、`python/analysis/`、`python/statistics/`、`python/visualization/`
- **MIP**：默认 Gurobi C++ API；没有 Gurobi C++ 环境时必须标 `NOT_RUN`，不能用 `gurobipy` 冒充
- **数据**：主体数据用 txt，`index.json` 只做索引；Python 生成，C++ `instance_loader` 读取
- **算法**：SA、MA、IG、GA、TS 和基线都在 C++ 注册表中；Python 不建立第二套 registry
- **评估**：decoder、checker、metrics、EvalCache 都在 C++；每个任务独立 FIFO 500 缓存
- **产物**：C++ 写 `result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`；Python 读取后生成汇总与图表
- **AGENTS.md**：项目级系统提示词，记录语言边界、命令、注册、输出和质量红线，不是普通 README
- **适配门禁**：扩展问题必须同步更新 C++ `Instance`、编码、解码、checker、MIP 和回归测试

## Skill 自检

```bash
python mip-hfsp-project-generator-skill/scripts/validate_skill.py
```

自检会物化 C++ 模板、运行 CMake/CTest smoke，并检查 Python 辅助分析模板；不会把仓库内旧 Python 求解模板物化成新项目。

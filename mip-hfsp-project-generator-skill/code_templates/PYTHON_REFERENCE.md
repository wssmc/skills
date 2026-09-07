# Python 模板参考说明

`core/`、`data/`、`math_models/`、`metaheuristics/`、`scripts/`、`tests/` 和 `visualization/` 下的旧 Python 模板仅作为仓库维护参考，不属于新项目的默认物化集合。

新项目必须使用：

- `cpp/`：主体求解、领域模型、解码、checker、目标、缓存、算法和 registry；
- `python/`：算例生成、结果分析、统计和可视化。

不要把这些参考模板复制回新项目，也不要让 Python 与 C++ 同时实现同一个 solver/decoder/checker。架构规则以根目录 `SKILL.md`、`modules/structure.md` 和生成项目 `AGENTS.md` 为准。

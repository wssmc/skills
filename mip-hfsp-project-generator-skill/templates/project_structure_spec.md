# 项目结构规范

> 本文件与 `modules/structure.md`、`code_templates/project_tree.txt` 同步。

```text
project_name/
├── CMakeLists.txt
├── cpp/
│   ├── include/hfsp/
│   │   ├── core/domain.hpp
│   │   ├── io/instance_loader.hpp
│   │   ├── encoding/
│   │   ├── decoding/
│   │   ├── metaheuristics/
│   │   ├── math_models/
│   │   └── registry.hpp
│   ├── src/
│   ├── apps/hfsp_run.cpp
│   └── tests/smoke_test.cpp
├── python/
│   ├── tools/generate_instances.py
│   ├── analysis/analyze_results.py
│   ├── statistics/
│   └── visualization/
├── scripts/
├── data/
├── configs/
├── docs/
├── outputs/
├── latex/
├── requirements.txt
├── AGENTS.md
├── IMPLEMENTATION_STATUS.md
├── PROJECT_AUDIT.md
└── README.md
```

## 语言边界

- C++17 是唯一的求解、解码、可行性检查、目标函数、缓存和 MIP 实现。
- Python 只生成 txt/索引，分析 JSON/CSV，执行统计和绘图。
- `AGENTS.md` 是项目级系统提示词，生成、修改、审计和运行前先读取。

## 禁止生成的路径

| 路径 | 原因 |
|---|---|
| `src/` | 新项目的主体代码统一放 `cpp/` |
| `gurobipy` 求解入口 | 不能替代 Gurobi C++ API |
| Python 元启发式/decoder/checker | 禁止第二套核心实现 |
| `configs/*.json`（除 fingerprint） | 项目规范使用自然语言文档 |

扩展问题必须同时更新 C++ Instance、encoding、decoding、checker、MIP 和测试，并在 fingerprint 中保留 `adapter_required` 直到验证完成。

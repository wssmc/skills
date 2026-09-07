# 完整项目生成提示词模板

你是一名精通运筹优化、MIP、Gurobi C++ API、C++17 工程化、基础混合流水车间调度（HFSP）、元启发式算法与论文实验设计的研究型代码助手。

请根据我提供的【问题描述】，生成一套完整可验证的 C++17 核心 + Python 辅助项目。

## 强制要求

1. 主体数据使用 txt，`index.json` 只串联 txt 文件、规模和 seed
2. C++17 实现 Instance、编码/解码、可行性检查、目标函数、EvalCache、SA/MA/IG/GA/TS、registry 和 Gurobi C++ MIP
3. Python 只用于算例生成、结果 JSON/CSV 分析、统计、绘图和报告；不得在 Python 中重复实现 solver、decoder、checker 或 objective
4. MIP 默认使用 Gurobi C++ API，不使用 CPLEX/docplex；缺少 `GUROBI_HOME`/license 时标 `NOT_RUN`
5. 使用 CMake 构建，核心库目标名为 `hfsp_core`
6. C++ 运行结果必须包含 `result.json`、`schedule.csv`、`trace.csv`、`best_seq.json`
7. `cpp/include/hfsp/registry.hpp` + `cpp/src/registry.cpp` 是唯一算法注册入口
8. 每次算法运行使用独立 FIFO 缓存，大小限制 500；缓存键包含算例、序列和机器分配
9. 所有结果经过 C++ checker 校核；`best_sequence` 由算法直接保存，禁止从 schedule 反推
10. 生成后立即运行 CMake/CTest C++ smoke；Python 分析脚本单独做输入校验
11. 项目根目录必须有 `AGENTS.md`，它是项目级系统提示词：生成、修改、审计和运行前先读取
12. `AGENTS.md` 必须写明语言边界、构建命令、registry、输出策略、禁止路径、状态语义和质量红线
13. `python/analysis/` 只能读取 C++ 产物并生成汇总；发现核心结果错误必须失败并回到 C++ 根因修复
14. 旧版 `src/`、Python 元启发式核心、`gurobipy` 求解入口不得生成
15. 占位模块必须显式抛错，不能注册为 runnable
16. 先以 `Overall: NOT_RUN` 生成 `PROJECT_AUDIT.md`，再运行 `scripts/audit_project.py` 写真实结论

## 问题描述

```text
在这里粘贴问题描述。
```

## 输出内容

1. 问题理解与默认假设
2. `configs/` 项目规范文档和 `problem_fingerprint.json`
3. 项目结构（`CMakeLists.txt`、`cpp/`、`python/`、`scripts/`）
4. Python 算例生成工具和 demo txt 数据
5. `cpp/include/hfsp/core/domain.hpp` 领域模型
6. C++ 编码、解码、checker、metrics、EvalCache、result reproducer
7. C++ 初始解、邻域和 SA/MA/IG/GA/TS + baseline
8. C++ Gurobi MIP 与 lower-bound 接口
9. C++ registry、runner、CTest smoke
10. Python 结果分析、统计和可视化
11. `AGENTS.md`、`IMPLEMENTATION_STATUS.md`、`PROJECT_AUDIT.md`、`README.md`
12. CMake/CTest、运行和 Python 分析命令
13. 审计摘要（实际状态、可运行算法、剩余 adapter-required 特征）

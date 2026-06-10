---
name: scheduling-paper-reproduction
description: 当用户要求复现调度/优化/RL 论文代码时使用。先读取算法流程重构工件，再按“官方代码/数据优先、公开 benchmark 其次、实验节数据生成最后”的顺序完成忠实复现。参数以实验部分为准；此阶段禁止做目标问题适配或算法改进。
---

# 调度论文忠实复现

你的任务是复现论文**实验中实际运行的版本**，而不是写一个相似算法。

此阶段只做 faithful reproduction，不做用户目标问题适配，不做算法改进。

## 必要输入

优先读取 Step 0 的工件：

- `algorithm_flow_summary.md`
- `loop_structure_table.md`
- `reconstructed_pseudocode.md`
- `component_glossary.md`
- `novelty_claim_map.md`
- `evidence_table.md`
- `assumption_registry.yaml`

如果这些文件不存在，先调用 `algorithm-flow-reconstruction`。

## 数据来源优先级

严格按以下顺序选择数据来源：

1. 论文官方代码或官方数据。
2. 论文指定的公开 benchmark。
3. 根据实验章节实现 `data_generator.py`。
4. 如果仍缺失，写入 `assumption_registry.yaml`。

不得凭常识随意生成数据并声称复现了原文实验。

## 参数规则

所有复现实验参数以**实验部分**为第一来源。

优先级：

1. 实验部分的参数设置表。
2. 参数敏感性 / 预实验 / Taguchi / DOE。
3. 消融实验配置。
4. 伪代码。
5. 方法正文。
6. 常见默认值，仅在论文未给出时使用，且必须登记为假设。

方法部分用于理解算法机制，实验部分用于确定实际运行参数和实验协议。

如果方法部分与实验部分冲突，为复现论文结果，以实验部分为准，并在 `reproduction_report.md` 中记录冲突。

## 必须产出的工件

1. `problem_profile.md`
2. `algorithm_matrix.md`
3. `parameter_registry.yaml`
4. `experiment_protocol.yaml`
5. `repo_plan.md`
6. `evidence_implementation_verification_matrix.md`
7. `reproduction_report.md`
8. 完整可运行代码仓库：`src/`, `tests/`, `docs/`

## Gate A：问题画像

提取并写入 `problem_profile.md`：

- shop environment
- machine environment
- job / operation / batch / lot structure
- precedence constraints
- objective function
- solution representation
- decoder / schedule generation scheme
- benchmark source
- feasibility strategy

## Gate B：算法矩阵

将算法拆成组件，写入 `algorithm_matrix.md`：

- initialization
- candidate generation
- destroy / repair
- neighborhood operators
- local search
- acceptance criterion
- adaptive control
- best update
- stopping condition
- experiment protocol

每个组件都要对应论文证据和目标代码文件。

## Gate C：参数与实验协议

生成：

- `parameter_registry.yaml`：算法参数。
- `experiment_protocol.yaml`：数据集、运行次数、time limit、统计指标、硬件、语言、seed 等。

所有核心参数必须可追溯。

## Gate D：仓库规划

先写 `repo_plan.md`，后写代码。

推荐代码结构：

```text
src/
├── core/
│   ├── problem.py
│   ├── solution.py
│   ├── decoder.py
│   ├── objective.py
│   └── constraints.py
├── data/
│   ├── data_reader.py
│   ├── data_generator.py
│   └── benchmark_converter.py
├── algorithm/
│   ├── initialization.py
│   ├── operators.py
│   ├── local_search.py
│   ├── acceptance.py
│   └── main_algorithm.py
└── experiments/
    ├── run_single.py
    ├── run_batch.py
    └── collect_results.py
```

## Gate E：实现顺序

严格按以下顺序实现：

1. `problem.py`
2. `solution.py`
3. `decoder.py`
4. `objective.py`
5. `constraints.py`
6. `data_reader.py` / `data_generator.py`
7. `initialization.py`
8. `operators.py`
9. `local_search.py`
10. `acceptance.py`
11. `main_algorithm.py`
12. experiment runner

不得跳过 decoder / objective / constraints 直接写主算法。

## Gate F：最小执行验证

至少完成：

- 数据读取或生成 smoke test。
- 小实例运行。
- decoder 生成 schedule。
- objective 独立复算。
- 主算法可启动并返回 best solution。
- 运行脚本可复用。

这不是最终验证；最终验证交给 Step 2。

## 消融开关规则

如果论文有消融实验，涉及的组件必须设计为可配置开关，例如：

- `use_local_search`
- `use_adaptive_destroy`
- `acceptance_type`
- `operator_selection_mode`
- `use_repair`

消融项必须映射到代码组件和配置项。

## 随机性规则

所有随机行为必须统一从显式 `rng` 或 `seed` 管理：

- initialization
- operator selection
- destroy / repair random choices
- acceptance probability
- GA mutation / crossover
- RL action sampling
- data generation

禁止隐藏全局随机状态。

## 禁止行为

禁止：

- 在 baseline 阶段加入用户目标问题适配。
- 改写论文目标函数。
- 猜测参数而不登记。
- 将论文未说明的实现细节伪装成原文内容。
- 在 smoke test 失败时声称复现完成。
- 将 adaptation 代码混入 faithful reproduction 代码。

## 完成标准

只有满足以下条件，才可 handoff 给 `superpowers-verification`：

- 代码可运行。
- 参数可追溯。
- 数据来源已说明。
- decoder / objective / constraints 已实现。
- 小实例 smoke test 通过。
- `evidence_implementation_verification_matrix.md` 已建立。
- `reproduction_report.md` 已写明限制和未指定项。

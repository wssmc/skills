---
name: algorithm-flow-reconstruction
description: 在用户要求复现、实现、迁移或理解论文算法之前使用。适用于调度/优化/RL/元启发式论文的文字叙述、伪代码、流程图、参数表和消融实验解析。先重建算法循环结构、组件调用顺序、论文声称的新内容与证据位置，再输出人可读伪代码；在此 skill 完成前禁止开始代码实现。
---

# 算法流程重构

你的唯一目标是：在开始任何代码实现前，把论文算法重构成**可编码、可核验、可追溯**的流程骨架。

此 skill 不写生产代码。

## 必须产出的文件

按顺序产出：

1. `algorithm_flow_summary.md`
2. `loop_structure_table.md`
3. `reconstructed_pseudocode.md`
4. `component_glossary.md`
5. `novelty_claim_map.md`
6. `evidence_table.md`
7. `assumption_registry.yaml`

没有完成这些文件，禁止进入代码实现。

## 信息来源优先级

必须交叉读取：

- Introduction / Contributions
- Related Work 中的研究缺口
- Problem Description
- Mathematical Model，如果有
- Method / Proposed Algorithm
- Algorithm block / pseudocode
- Flowchart / figures
- Parameter setting
- Ablation study
- Experiment protocol
- Appendix / Supplementary material

## Gate A：候选创新点抽取

先从引言、贡献、相关工作和消融实验中抽取论文“声称的新内容”，写入 `novelty_claim_map.md`。

贡献部分只作为**候选创新点线索**，不能直接作为实现依据。每个创新点必须回到方法章节、伪代码、流程图、公式、参数表或消融实验中核验。

每个候选创新点必须分类：

- 问题创新
- 编码创新
- 解码创新
- 初始化创新
- 邻域创新
- 搜索框架创新
- 接受准则创新
- 参数自适应创新
- 实验创新

## Gate B：循环结构还原

从方法章节、伪代码、流程图、参数表和实验协议中识别：

- 外层循环
- 中层循环
- 局部搜索循环
- 温度循环
- population / generation 循环
- RL 的 episode / step / update / minibatch 循环
- 每层循环调用的组件
- 每层循环的终止条件
- best/current/candidate 的更新时间点

输出到 `loop_structure_table.md`。

如果某个循环只由流程图或文字隐含，必须标记为 `inferred`，并在 `evidence_table.md` 中说明推断来源。

## Gate C：重构人可读伪代码

在 `reconstructed_pseudocode.md` 中写出**人一眼能看懂**的伪代码。

要求：

- 先讲清楚循环层级，再讲细节。
- 标准组件可以直接写 `Initialize / Decode / Evaluate / Swap / Insert / LocalSearch`。
- 论文新组件必须用一句话解释关键思想。
- 不要让低层实现细节淹没主流程。
- 必须明确：初始化、候选解生成、局部改进、接受准则、best 更新、终止条件。

## Gate D：组件词汇表

在 `component_glossary.md` 中列出每个组件：

- 名称
- 类型
- 作用
- 标准组件 / 论文特有组件
- 是否需要高细节解释
- 在循环中的位置
- 论文证据位置

规则：

- 标准组件只需一句话说明。
- 论文新组件需要说明其关键思想、输入、输出、作用位置和搜索行为影响。
- 如果组件影响循环、接受、邻域选择、参数更新或目标值更新，标记为 `high-detail`。

## Gate E：证据与假设

在 `evidence_table.md` 中为每个关键结论记录：

- 结论 / 细节
- 来源类型：正文 / 伪代码 / 流程图 / 表格 / 消融 / 附录
- PDF 页码
- 章节、段落、图号、算法号或表号
- 原文证据摘要
- 置信度
- 备注

如果细节缺失，禁止私下补全。必须写入 `assumption_registry.yaml`。

## 调度论文专属检查

如果论文是智能算法求解车间调度，必须识别：

- shop environment：PFSP / HFSP / FJSP / JSSP / batch scheduling 等
- machine environment：identical / unrelated / eligibility / dedicated 等
- job / operation / batch / lot 结构
- precedence constraints
- missing operations
- objective function
- solution representation
- decoder / schedule generation scheme
- feasibility-preserving / repair / penalty / reject 策略

## RL 调度论文专属检查

如果论文是 PPO / DQN / GNN-RL / imitation learning，必须识别：

- MDP state
- action space
- action mask
- reward
- transition / environment update
- policy network
- training loop
- inference loop
- episode termination
- train/test scale generalization

## 禁止行为

禁止：

- 直接开始写代码。
- 只看引言贡献就断定实现组件。
- 把问题创新误判为算法组件创新。
- 省略页码、段落、图号、算法号或表号。
- 在终止条件、接受准则、内层循环顺序不清时自行猜测。
- 把消融缩写留到后续再解释。

## 完成标准

只有当以下条件全部满足时，才允许 handoff 给 `scheduling-paper-reproduction`：

- 循环层级已明确。
- 伪代码可读且可实现。
- 新组件已解释清楚。
- 每个关键结论都有论文证据或假设登记。
- 消融项已经映射到组件。
- `assumption_registry.yaml` 没有空项。

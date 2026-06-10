# paper-repro-agent-skills

一组面向**智能算法求解车间调度论文复现**的 Agent Skills。它把“读论文 → 复现代码 → 测试核验 → 迁移适配”拆成四个边界清晰的阶段：

1. `0_algorithm-flow-reconstruction-skill`：先理解算法结构、循环层级、组件调用和论文创新点，不写代码。
2. `1_scheduling-paper-reproduction-skill`：忠实复现论文实验中实际运行的版本，参数以实验部分为准。
3. `2_superpowers-verification-skill`：用 TDD / Superpowers 思想写测试，核验代码是否正确、可行、与原文一致。
4. `3_domain-adaptation-skill`：在 verified baseline 基础上适配到其它调度问题，严格区分 inherited / adapted / new。

推荐放置位置：

```text
<your-project>/.agents/skills/
├── 0_algorithm-flow-reconstruction-skill/
├── 1_scheduling-paper-reproduction-skill/
├── 2_superpowers-verification-skill/
└── 3_domain-adaptation-skill/
```

推荐使用顺序：

```text
Step 0：算法流程重构
Step 1：忠实复现论文
Step 2：Superpowers / TDD 核验
Step 3：目标问题适配
```

## 核心原则

- 不先理解循环结构，不写代码。
- 不先确定实验参数，不跑复现实验。
- 不先通过一致性测试，不声称 faithful reproduction。
- 不先验证 baseline，不进入 adaptation。
- 所有假设必须写入 `assumption_registry.yaml`。
- 所有关键组件都要进入 Evidence → Implementation → Verification 三联表。

## v0.1 范围

本版本优先提供执行协议、模板和最小脚本，不绑定任何单一论文或数据集。建议先用一篇简单 PFSP / IG / SA / GA 论文试跑 Step 0 和 Step 1，再逐步启用 Step 2 与 Step 3。

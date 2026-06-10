# Example Request

```text
请使用 0_algorithm-flow-reconstruction-skill 先阅读这篇 PFSP / HFSP 调度论文，不要写代码。
输出 algorithm_flow_summary.md、loop_structure_table.md、reconstructed_pseudocode.md、component_glossary.md、novelty_claim_map.md、evidence_table.md、assumption_registry.yaml。
特别注意：贡献部分和消融实验中声称的新组件，需要回到方法章节和伪代码核验；参数以实验部分为准。
```

```text
基于 Step 0 的输出，使用 1_scheduling-paper-reproduction-skill 忠实复现论文实验中实际运行的版本。
如果有官方代码或数据，优先拉取；否则使用论文指定 benchmark；如果论文只给了生成规则，则写 data_generator.py。
禁止做我的目标问题适配。
```

```text
使用 2_superpowers-verification-skill 为 baseline 写 unit / feasibility / paper consistency / regression 测试。
重点核验 decoder、objective、acceptance、operator set、参数和停止条件是否与论文一致。
```

```text
在 verified baseline 通过后，使用 3_domain-adaptation-skill 适配到我的目标问题环境。
我的环境已经有 instance_reader、decoder、objective、feasibility_checker。
请只适配算法主体，并输出 operator_mapping.md、adaptation_change_log.md、adaptation_risk_report.md。
```

# 实验计划

## 1. 对比实验 (batch)
- **算法**: {列出参与对比的算法}
- **算例**: small + large 全量
- **轮数**: 7 轮
- **指标**: ARPD（平均相对百分比偏差）、最优解数量、运行时间
- **时间公式**: `time = N_jobs * M_stages * 0.1`（批量）
- **执行方式**: 默认顺序执行；若项目另行实现并行，必须记录进程隔离、缓存隔离和失败传播验证

## 2. 消融实验 (ablation)
- **测试算例**: 每规模第一个算例
- **种子**: 固定 (1, 2, 3)
- **重复**: repeat=3
- **时间公式**: `time = N_jobs * M_stages * 0.05`
- **配置文件**: `scripts/ablation/quick_test_config.py`

## 3. 参数校核 (DOE)
- **默认实现**: `sa_basic` 的 `initial_temperature_multiplier × cooling_rate` 全因子网格
- **重复**: 每个组合使用 `quick_test_config.py` 中的 3 个 seed
- **扩展门禁**: 其他算法或其他因子必须先在 `run_doe.py` 增加显式参数适配器和验证；当前模板不声明正交设计或响应面能力
- **输出**: `doe_results.csv` + `doe_metadata.json`

## 4. 统计检验 (statistics)
- **Friedman 检验**: 多算法整体差异显著性
- **Wilcoxon 配对符号秩检验**: 同一批算例上的两两算法对比
- **多重比较校正**: Holm
- **输出**: Friedman JSON、Wilcoxon CSV、Holm 校正 CSV；当前模板不生成 CD diagram

## 5. MIP 基准
- **算例**: small 规模
- **时限**: 3600 秒
- **输出**: LB + 最优可行解
- **用途**: 计算启发式算法的 Gap
- **校核**: 结果必须经过 `check_feasibility`

## 6. 算例规模定义

| 规模 | 作业数 | 阶段数 | 算例数 |
|------|--------|--------|--------|
| demo | {N} | {M} | 1 |
| small | {N1, N2, N3} | {M} | {count} |
| large | {N4, N5, N6} | {M} | {count} |

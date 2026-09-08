# 实验计划

## 对比实验

- 算法：{algorithms}
- 算例：{instances}
- rounds：{N}
- solve seeds：configs/seeds/solve_seeds.txt 中恰好 N 个固定、非重复值
- 配对规则：同一 instance/round 的算法使用同一个 solve_seed
- 时间预算：{rule}
- 指标：{objective/gap/runtime/其他}
- 执行：scripts/run_batch.sh
- 正式脚本 ID 与结果目录：{test_id} -> outputs/formal/{test_id}[__changed-params][_N]/
- smoke/试画：outputs/tmp/

## 算例生成

- instance seeds：每个算例独立指定并保存在该算例目录
- 每个算例保存 instance_seed.txt 和 index.json
- 生成参数：{sizes_and_distributions}

## CPLEX 基准

- 算例：{scope}
- 时限：{seconds}
- 输出：status、incumbent、best bound、gap、runtime
- 无法 import cplex 或缺少 license：NOT_RUN

## 消融与统计

- 消融组件：{...}
- 统计方法：{Friedman/Wilcoxon/Holm/其他}
- Python 汇总 C++ 与 CPLEX 已生成结果，不重算或修正目标

## 收敛曲线

- CPU budget（含初始化）：{rule}
- 初始化边界与 T_init/E_init/C_init：{rule}
- 原始事件：INIT、严格改善 IMPROVE、END
- 每 seed 独立离线采样 100 点并用右连续阶梯图；细则见 docs/convergence_protocol.md

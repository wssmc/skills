# Refined Problem Description

## 1. Problem Background

本研究关注 `<problem_context>` 中的 `<problem_type>` 调度问题。

## 2. System Description

系统包含 `<num_jobs>` 个工件、`<num_stages>` 个阶段，每个阶段包含若干台并行机器。所有工件按照相同阶段顺序依次加工。

## 3. Decisions

需要决定：

1. 每个工件在每个阶段选择哪台机器加工；
2. 每个阶段内工件的加工顺序；
3. 每个操作的开始时间和完工时间；
4. 若存在运输、人力或共享窗口，则还需决定相关资源的分配与时间占用。

## 4. Objective

目标为 `<objective>`，例如最小化 total weighted earliness and tardiness，或其与 makespan 的加权组合。

## 5. Constraints

模型至少包含：

- 阶段顺序约束；
- 机器容量约束；
- 工件释放时间约束；
- 交期或交期窗口约束；
- 优先工件约束；
- 共享窗口约束；
- 机器不可用期约束；
- 可选的 setup、transport、worker 约束。

## 6. Data Format

主体数据使用 txt 保存，JSON 仅作为索引或配置文件。

## 7. Expected Outputs

后续需要生成文献矩阵、MIP 模型、编码解码、baseline、本文算法、实验脚本与甘特图。

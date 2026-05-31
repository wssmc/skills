# 问题描述模板

请按以下模板补充你的调度问题。若暂时不确定，可以填写“不确定”，Skill 会给出默认假设。

## 1. 问题类型

- [ ] HFSP 混合流水车间
- [ ] FJSP 柔性作业车间
- [ ] JSP 作业车间
- [ ] 并行机调度
- [ ] 资源约束调度
- [ ] 其他：____

## 2. 问题背景

我要解决的问题是：

```text
在这里描述业务背景。
```

## 3. 调度对象

- Job 数量：
- Stage / Operation 数量：
- Machine 数量：
- 每个 Stage 的机器数量：

## 4. 工时数据

对于 HFSP，请提供类似格式：

```text
JobID	Stage_0	Stage_1	Stage_2
0	1.27	1.10	1.70
1	0.73	0.58	1.05
```

含义：Job j 在 Stage s 的加工时间。

## 5. 约束条件

请确认：

- 每个 Job 是否必须按 Stage 顺序执行：
- 同一机器同一时刻是否只能加工一个 Job：
- 是否允许等待：
- 是否允许抢占：
- 是否有 release time：
- 是否有 due date：
- 是否有 setup time：
- 是否有 transport time：
- 是否有人力资源：
- 是否有机器维护时间：
- 是否有批处理或容量约束：

## 6. 目标函数

目标是：

- [ ] 最小化 makespan
- [ ] 最小化总延期
- [ ] 最小化加权延期
- [ ] 最小化总成本
- [ ] 多目标加权组合
- [ ] 其他：____

若是加权目标，请给出权重：

```text
objective = alpha * makespan + beta * total_tardiness + ...
```

## 7. 数据规模

- demo_data：
- data_small：
- data_large：

## 8. 算法需求

需要生成：

- [ ] CPLEX MIP
- [ ] 编码 / 解码
- [ ] baseline
- [ ] 本文算法框架
- [ ] 消融实验
- [ ] 参数敏感性实验
- [ ] 甘特图
- [ ] 收敛曲线
- [ ] 统计检验

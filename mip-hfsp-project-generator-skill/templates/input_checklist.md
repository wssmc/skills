# 输入信息检查清单

## 必需信息

| 项目 | 是否提供 | 说明 |
|---|---|---|
| 问题类型 |  | HFSP / FJSP / JSP / Parallel Machine / General MIP |
| Job 数量 |  | |
| Stage / Operation 数量 |  | |
| 加工时间 |  | HFSP 推荐 JobID × Stage 表 |
| 机器 / 资源信息 |  | HFSP 推荐 stage_machines.txt |
| 顺序约束 |  | Job 内 Stage 顺序 |
| 机器冲突约束 |  | 同机不重叠 |
| 目标函数 |  | makespan / tardiness / cost / weighted |

## 推荐信息

| 项目 | 是否提供 | 默认假设 |
|---|---|---|
| release time |  | 默认全部为 0 |
| due date |  | 若缺失则只优化 makespan |
| setup time |  | 默认 0 |
| transport time |  | 默认 0 |
| worker resource |  | 默认不考虑 |
| machine maintenance |  | 默认不考虑 |
| 是否允许等待 |  | 默认允许 |
| 是否允许抢占 |  | 默认不允许 |
| Gurobi 参数 |  | 默认 time_limit=3600(正式)/60(测试), MIPGap=0.001 |
| 数据规模 |  | demo/small/large 三级 |
| 对比算法 |  | 默认 SA, MA, IG, GA, TS |

## 不足时的提示语

当前问题描述还缺少以下信息：

1. ...
2. ...

你可以按下面格式补充：

```text
问题类型：
Job 数量：
Stage 数量：
每个 Stage 的机器数量：
加工时间表：
目标函数：
特殊约束：
数据规模：
希望对比的算法：
```

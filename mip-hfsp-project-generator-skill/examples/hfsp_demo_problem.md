# HFSP demo problem

有 10 个 Job，5 个 Stage。每个 Job 必须依次经过 Stage_0 到 Stage_4。
每个 Stage 内有若干台并行机，同一机器同一时刻只能加工一个 Job。
允许等待，不允许抢占。
目标函数默认最小化 makespan；若存在 due date，可扩展为 makespan + total tardiness。

工时数据使用 `processing_times.txt` 的 JobID × Stage 表。

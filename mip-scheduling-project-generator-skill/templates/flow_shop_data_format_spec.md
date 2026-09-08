# 流水车间参考数据格式

> 这是当前 FlowShop 参考适配的数据格式，不是通用调度问题的强制格式。

每个算例目录至少包含：

~~~text
processing_times.txt
stage_machines.txt
instance_seed.txt
index.json
~~~

processing_times.txt 使用 JobID × Stage 的制表符表格。stage_machines.txt 记录每阶段机器数量。instance_seed.txt 只包含一个非负整数。index.json 记录 problem_family、instance_id、规模、instance_seed 和文件清单。

若问题含机器相关工时、可选路线、缺失工序、重入、人员、运输、容量或其他资源，必须定义新的 txt 表和 C++ loader，并同步 evaluator、checker、CPLEX 与 tests。

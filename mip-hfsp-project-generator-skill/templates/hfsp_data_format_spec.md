# HFSP txt 数据格式规范

## 1. 推荐目录

```text
data/
├── generate.py             # 数据生成入口
├── loader.py               # 数据读取（load_instance）
├── demo/                   # 展示用算例
│   └── demo_01_10_5/       # 命名: demo_0x_n_m
│       ├── processing_times.txt
│       ├── stage_machines.txt
│       ├── due_dates.txt
│       ├── release_times.txt
│       ├── index.json
│       └── *.png / *.pdf   # 可视化图（demo 专属）
├── small/                  # 小规模基准算例
│   └── inst_001_10_5_01/   # 命名: inst_xxx_n_m_yy
├── large/                  # 大规模基准算例
└── batch_seeds/            # 统一种子文件
    ├── small/
    │   ├── seed_table.json
    │   └── round{r}.json
    └── large/
        ├── seed_table.json
        └── round{r}.json
```

## 2. processing_times.txt

格式：

```text
JobID	Stage_0	Stage_1	Stage_2	Stage_3	Stage_4
0	1.27	1.10	1.70	1.52	0.55
1	0.73	0.58	1.05	1.03	0.52
```

含义：

```text
p[j][s] = Job j 在 Stage s 的加工时间
```

## 3. stage_machines.txt

简单格式：

```text
StageID	MachineCount
Stage_0	2
Stage_1	3
Stage_2	2
Stage_3	2
Stage_4	1
```

详细格式：

```text
StageID	MachineID	Capacity
Stage_0	M0_0	1
Stage_0	M0_1	1
Stage_1	M1_0	1
Stage_1	M1_1	1
Stage_1	M1_2	1
```

## 4. due_dates.txt

```text
JobID	DueDate	Weight
0	8.0	1.0
1	7.5	1.0
2	9.0	1.5
```

## 5. release_times.txt

```text
JobID	ReleaseTime
0	0.0
1	0.0
2	1.0
```

## 6. transport_times.txt（可选）

```text
FromStage	ToStage	TransportTime
Stage_0	Stage_1	0.2
Stage_1	Stage_2	0.3
```

## 7. worker_requirements.txt（可选）

```text
StageID	WorkerType	RequiredWorkers
Stage_0	worker_A	1
Stage_1	worker_B	2
```

## 8. index.json

```json
{
  "problem_type": "HFSP",
  "data_format": "txt",
  "instance_name": "demo_01_10_5",
  "instance_seed": 42,
  "files": {
    "processing_times.txt": "processing_times.txt",
    "stage_machines.txt": "stage_machines.txt",
    "due_dates.txt": "due_dates.txt",
    "release_times.txt": "release_times.txt"
  },
  "objective": {
    "primary": "makespan"
  }
}
```

> `instance_seed` 只用于复现实例内容。`data/batch_seeds/` 中的 seed 只用于算法随机过程，两者不得混用。

## 9. 算法运行种子文件

```text
data/batch_seeds/{scale}/seed_table.json   # 种子主表（算例名 → seed）
data/batch_seeds/{scale}/round{r}.json     # 每轮种子映射
```

种子源：`random.Random(20260616 + sum(ord(c) for c in scale))`

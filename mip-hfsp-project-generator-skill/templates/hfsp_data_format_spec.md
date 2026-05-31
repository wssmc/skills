# HFSP txt 数据格式规范

## 1. 推荐目录

```text
data/demo_data/
├── processing_times.txt
├── stage_machines.txt
├── due_dates.txt
├── release_times.txt
├── setup_times.txt
├── transport_times.txt
├── worker_requirements.txt
└── index.json
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

## 6. transport_times.txt，可选

```text
FromStage	ToStage	TransportTime
Stage_0	Stage_1	0.2
Stage_1	Stage_2	0.3
```

## 7. worker_requirements.txt，可选

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
  "files": {
    "processing_times": "processing_times.txt",
    "stage_machines": "stage_machines.txt",
    "due_dates": "due_dates.txt",
    "release_times": "release_times.txt"
  },
  "objective": {
    "primary": "makespan",
    "secondary": "total_tardiness",
    "alpha": 1.0,
    "beta": 0.0
  }
}
```

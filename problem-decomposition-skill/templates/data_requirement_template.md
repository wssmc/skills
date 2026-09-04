# Data Requirement

## Required for HFSP

```text
processing_times.txt
stage_machines.txt
index.json
```

## Optional

```text
release_times.txt
due_windows.txt
priority_jobs.txt
shared_windows.txt
machine_unavailability.txt
setup_times.txt
transport_times.txt
worker_requirements.txt
```

## processing_times.txt

```text
JobID	Stage_0	Stage_1	Stage_2
0	1.27	1.10	1.70
1	0.73	0.58	1.05
```

## index.json

JSON 只负责串联 txt 文件和保存配置，不保存主体加工数据。

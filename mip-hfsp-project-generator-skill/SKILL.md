# MIP / HFSP Scheduling Project Generator Skill

## 1. Skill 定位

本 Skill 用于根据用户提供的调度、排产、资源分配或组合优化问题描述，生成一套可运行、可验证、可扩展的 Python 研究工程。

重点支持：

- HFSP：Hybrid Flow Shop Scheduling Problem，混合流水车间调度；
- FJSP / JSP / Parallel Machine Scheduling 的扩展；
- MIP 建模；
- CPLEX / docplex 求解；
- txt 主体数据 + index.json 串联；
- demo_data、data_small、data_large 生成；
- 编码、解码、baseline、本文算法接口；
- MIP 与启发式结果对比；
- 甘特图、收敛图、统计表；
- 后续扩展运输资源、人力资源、换线时间、时间窗、维护窗口等约束。

本 Skill 不应只输出单个脚本，而应输出结构化项目工程。

---

## 2. 触发场景

当用户提出以下任一需求时，应使用本 Skill：

- 根据问题描述生成 MIP 模型代码；
- 根据问题描述生成调度 / 排产 / 资源分配 Python 项目；
- 需要 demo_data 验证；
- 需要 data_small / data_large 实验数据；
- 需要编码、解码、启发式算法接口；
- 需要 baseline 和本文算法结构；
- 需要与 MIP 结果对比；
- 需要甘特图或实验可视化；
- 明确提到 HFSP、FJSP、JSP、并行机、车间调度、工序调度、资源约束调度。

---

## 3. 总体执行原则

必须遵守以下原则：

1. 代码优先，解释为辅。
2. 不只给伪代码。
3. demo_data 必须能够跑通。
4. 主体数据优先保存为 txt。
5. json 只用于索引、配置或结构化结果。
6. MIP 默认使用 CPLEX / docplex。
7. 项目必须模块化，不能把所有代码堆在 src 根目录。
8. MIP、decoder、baseline、proposed 算法必须共用同一个 Instance 数据对象。
9. 所有算法输出必须统一为 Schedule / Result 格式。
10. 所有结果必须经过 feasibility check 和 metrics evaluation。
11. 运输资源、人力资源、换线时间等新增条件必须通过 constraints/ 和 resources/ 扩展，不应重写主框架。
12. 如果问题描述不完整，应先给出“缺失信息清单”和“默认假设”，但不因为非关键缺失停止生成。
13. 如果关键建模信息缺失，应先输出补充问题模板，让用户补充。

---

## 4. 问题类型识别

生成项目之前，必须先识别 problem_type：

- HFSP：混合流水车间，每个 Job 按固定 Stage 顺序加工，每个 Stage 有一组并行机；
- FJSP：柔性作业车间，每道 Operation 可选机器，Job 内有工序顺序；
- JSP：经典作业车间，每道工序有指定机器；
- Parallel Machine Scheduling：并行机调度；
- Resource-Constrained Scheduling：资源约束项目调度；
- General MIP：无法归类时使用通用 MIP 框架。

如果识别为 HFSP，则默认采用 HFSP 数据模板：

```text
processing_times.txt
stage_machines.txt
due_dates.txt
release_times.txt
index.json
```

不要默认强制生成 jobs.txt、machines.txt、operations.txt。它们只作为通用问题或 FJSP/JSP 的可选文件。

---

## 5. 用户需要提供什么

用户至少应提供以下信息：

### 5.1 必需信息

1. 要安排的对象是什么：
   - Job、Order、Task、Operation、Vehicle、Resource 等。
2. 安排到哪里：
   - Machine、Stage、Worker、Transporter、Line、Station 等。
3. 顺序规则：
   - Job 内是否按 Stage / Operation 顺序执行。
4. 冲突规则：
   - 同一机器同一时间是否只能加工一个任务。
5. 加工时间：
   - 加工时间由 Job 决定、Stage 决定、Machine 决定，还是三者共同决定。
6. 优化目标：
   - makespan、total tardiness、total cost、flow time、weighted objective 等。

### 5.2 推荐补充信息

1. 是否有 release time；
2. 是否有 due date；
3. 是否允许等待；
4. 是否允许抢占；
5. 是否允许机器选择；
6. 每个 Stage 有几台机器；
7. 是否有 setup time；
8. 是否有 transport time；
9. 是否有人力资源约束；
10. 是否有机器维护窗口；
11. 是否有批处理或容量约束；
12. 数据规模；
13. 目标函数权重；
14. 希望对比哪些 baseline；
15. 本文算法的初步想法。

---

## 6. 问题描述成熟度判断

### 6.1 最低可建模描述

如果用户能说清以下 5 点，就可以开始生成项目：

```text
1. 要安排什么；
2. 安排到哪些机器 / 资源；
3. 每个任务需要多长时间；
4. 哪些任务不能同时发生或必须按顺序发生；
5. 优化什么目标。
```

### 6.2 HFSP 最低描述

对于 HFSP，最低描述应包括：

```text
1. 有多少个 Job；
2. 有多少个 Stage；
3. 每个 Job 在每个 Stage 的加工时间；
4. 每个 Stage 有多少台并行机；
5. Job 是否必须按 Stage_0 → Stage_1 → ... 顺序执行；
6. 目标函数，例如最小化 makespan 或 total tardiness。
```

### 6.3 不完整时的处理

如果缺失关键信息，应输出如下提示：

```text
当前问题描述还缺少以下关键信息：
1. ...
2. ...

你可以按下面模板补充：
...
```

如果只缺少非关键细节，应继续生成，并明确默认假设：

```text
默认假设：
1. 不允许抢占；
2. 允许等待；
3. 每台机器同一时间最多处理一个 Job；
4. 每个 Job 必须按 Stage 顺序加工；
5. 目标函数默认最小化 makespan。
```

---

## 7. HFSP 数据格式规范

HFSP 的加工时间数据默认使用 JobID × Stage 表格：

```text
JobID	Stage_0	Stage_1	Stage_2	Stage_3	Stage_4
0	1.27	1.10	1.70	1.52	0.55
1	0.73	0.58	1.05	1.03	0.52
2	0.77	0.10	1.00	1.22	0.70
```

含义：

```text
p[j][s] = Job j 在 Stage s 的加工时间
```

推荐 HFSP 数据目录：

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

其中：

- `processing_times.txt`：主体工时数据；
- `stage_machines.txt`：每个 Stage 的并行机数量或机器列表；
- `due_dates.txt`：每个 Job 的交期；
- `release_times.txt`：每个 Job 的释放时间；
- `setup_times.txt`：可选，换线 / 设置时间；
- `transport_times.txt`：可选，阶段间运输时间；
- `worker_requirements.txt`：可选，人力需求；
- `index.json`：索引文件，负责串联上述 txt。

---

## 8. json 使用规则

json 文件只允许用于以下场景：

1. `index.json`：说明 txt 文件路径、字段含义和问题类型；
2. `config.json`：保存实验参数；
3. `solver_config.json`：保存 CPLEX 参数；
4. `result.json`：保存结构化结果；
5. `manifest.json`：保存项目元信息。

主体数据不应直接堆入 json，除非用户明确要求。

---

## 9. 推荐项目结构

生成项目时优先使用以下结构：

```text
project/
├── README.md
├── requirements.txt
├── configs/
│   ├── solver_cplex.json
│   ├── experiment_demo.json
│   ├── experiment_small.json
│   └── experiment_large.json
├── data/
│   ├── demo_data/
│   ├── data_small/
│   └── data_large/
├── src/
│   ├── core/
│   ├── io/
│   ├── problems/
│   ├── solvers/
│   ├── algorithms/
│   ├── constraints/
│   ├── resources/
│   ├── evaluation/
│   ├── visualization/
│   └── utils/
├── scripts/
├── tests/
└── outputs/
```

### 9.1 src/core

用于定义通用对象：

```text
Instance
Operation
Schedule
Solution
Objective
Constraint
Result
```

### 9.2 src/io

用于 txt、json index、结果表格的读写：

```text
txt_loader.py
json_index_loader.py
data_validator.py
result_writer.py
```

### 9.3 src/problems

按问题类型组织专用逻辑：

```text
problems/hfsp/
problems/fjsp/
problems/jsp/
```

### 9.4 src/solvers

MIP 和其他精确求解器放在这里：

```text
solvers/mip/cplex_hfsp_model.py
solvers/mip/variable_manager.py
solvers/mip/constraint_builder.py
solvers/mip/objective_builder.py
solvers/mip/solution_extractor.py
```

### 9.5 src/algorithms

算法必须分层：

```text
algorithms/encoding/
algorithms/decoding/
algorithms/baselines/
algorithms/proposed/
algorithms/common/
```

### 9.6 src/constraints 和 src/resources

新增运输资源、人力资源、维护窗口、换线时间时，通过这里扩展。

---

## 10. 默认求解器规则

MIP 默认使用 CPLEX。

推荐 Python 接口：

```text
docplex.mp.model.Model
```

依赖建议：

```text
docplex
pandas
numpy
matplotlib
pytest
```

README 中必须说明：

```text
docplex 是 Python 建模接口。若要调用本地 CPLEX 求解，需要安装 IBM ILOG CPLEX Optimization Studio 或配置可用的 CPLEX Runtime。
```

不要默认使用 PuLP/CBC，除非用户明确要求开源求解器。

---

## 11. HFSP MIP 建模默认方案

对于基础 HFSP，默认变量包括：

```text
S[j, s]        Job j 在 Stage s 的开始时间
C[j, s]        Job j 在 Stage s 的完工时间
x[j, s, m]     Job j 在 Stage s 是否分配给该 Stage 的机器 m
y[i, j, s, m]  在 Stage s 的机器 m 上，Job i 是否排在 Job j 前
Cmax           最大完工时间
T[j]           Job j 的延期
```

默认约束包括：

1. 每个 Job 每个 Stage 必须选择一台机器；
2. 完工时间定义；
3. Stage 顺序约束；
4. 同一 Stage 同一机器上的非重叠约束；
5. release time；
6. due date 和 tardiness；
7. makespan 定义；
8. 可选 setup time；
9. 可选 transport time；
10. 可选 worker / transport resource capacity。

目标函数默认：

```text
minimize Cmax
```

若有 due date，则可扩展为：

```text
minimize alpha * Cmax + beta * sum(T[j])
```

---

## 12. 编码与解码默认方案

HFSP 默认编码：

```text
job_sequence + machine_assignment
```

其中：

```text
job_sequence:
  一个 Job 排列或多阶段排序列表，用于决定解码优先级。

machine_assignment:
  (job_id, stage_id) -> machine_id
```

解码器必须输出统一格式：

```text
Schedule
├── operations
│   ├── job_id
│   ├── stage_id
│   ├── machine_id
│   ├── start
│   ├── end
│   └── processing_time
├── objective
└── metrics
```

解码必须满足：

1. Stage precedence；
2. machine no-overlap；
3. release time；
4. transport time；
5. optional resource capacity；
6. optional worker constraint。

---

## 13. baseline 与 proposed 算法

baseline 必须单独放入：

```text
src/algorithms/baselines/
```

可包括：

```text
SPT
LPT
NEH
Random Search
Basic GA
Local Search
```

本文算法必须放入：

```text
src/algorithms/proposed/
```

可包括：

```text
main_algorithm.py
initializer.py
neighborhood.py
local_search.py
mutation.py
crossover.py
selection.py
adaptive_strategy.py
ablation_variants.py
```

公共算子放入：

```text
src/algorithms/common/
```

---

## 14. 评价与对比

所有方法必须统一输出 Result，并由 `evaluation/` 计算指标：

```text
makespan
total_tardiness
average_flow_time
machine_utilization
constraint_violations
objective_value
runtime
gap_to_mip
```

对比表格式：

```text
method	status	objective	makespan	total_tardiness	runtime	gap
MIP	Optimal	...	...	...	...	0.00%
NEH	Feasible	...	...	...	...	...
Proposed	Feasible	...	...	...	...	...
```

---

## 15. 可视化

默认生成：

```text
gantt_mip.png
gantt_decode.png
gantt_compare.png
convergence_curve.png
summary_table.csv
```

甘特图要求：

1. 横轴为时间；
2. 纵轴为 Stage / Machine；
3. 不同 Job 使用不同颜色；
4. 标注 JobID 和 StageID；
5. 显示 makespan；
6. 可选显示 due date；
7. 支持保存 PNG 和 PDF。

---

## 16. 测试要求

必须提供 tests/ 目录，至少包括：

```text
test_hfsp_loader.py
test_hfsp_decoder.py
test_cplex_hfsp_model.py
test_feasibility_checker.py
test_gantt.py
```

测试重点：

1. 数据是否能正确读取；
2. demo_data 是否可行；
3. decoder 是否满足 Stage precedence；
4. decoder 是否满足 machine no-overlap；
5. MIP 解是否能提取成 Schedule；
6. evaluator 是否能重新计算 objective；
7. gantt 是否能正常输出图像文件。

---

## 17. 输出顺序

当用户要求“生成完整项目”时，建议按以下顺序输出：

1. 问题理解与假设；
2. 数据格式设计；
3. 项目结构；
4. demo_data；
5. CPLEX MIP 模型；
6. data loader；
7. data generator；
8. encoding / decoding；
9. evaluation；
10. visualization；
11. baseline；
12. proposed algorithm skeleton；
13. scripts；
14. tests；
15. README；
16. 运行命令；
17. 后续扩展说明。

---

## 18. 不应做的事

1. 不要把所有代码写在一个 `mip_model.py` 中。
2. 不要强制 HFSP 使用 `jobs.txt / machines.txt / operations.txt`。
3. 不要让 MIP、decoder、baseline 各自读取不同格式的数据。
4. 不要把 baseline 和 proposed 混在一个目录。
5. 不要只输出数学模型而不输出代码。
6. 不要只输出代码而没有 demo_data。
7. 不要默认使用 PuLP/CBC。
8. 不要忽略 CPLEX 安装说明。
9. 不要让新增运输 / 人力资源需要推翻整个代码结构。

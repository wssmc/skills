# 模块：Bash、固定种子与批量执行

## 1. 唯一执行链

~~~text
scripts/generate_instances.sh
  -> Python 生成 txt + instance_seed 元数据
scripts/build.sh
  -> CMake 构建 C++17
scripts/run_batch.sh
  -> C++ runner + 固定 solve seeds
scripts/run_mip.sh
  -> IBM cplex Python API runner
scripts/analyze.sh
  -> Python 汇总、统计、绘图
scripts/audit.sh
  -> 项目结构、种子、语法、构建与状态审计
~~~

scripts/run_all.sh 串联完整流程。Bash 只负责参数、循环、目录和失败传播。

## 2. 脚本要求

每个 Bash 脚本：

- 使用 set -euo pipefail；
- 根据 BASH_SOURCE 解析项目根目录；
- 对路径和参数使用引号；
- 不使用静默失败或无条件继续；
- 不在循环中重新实现算法或目标函数；
- 将 stdout/stderr 写入对应实验目录或明确日志；
- 预计超过一小时的任务记录后台 PID、日志和重启命令。

## 3. 单次运行

run_single.sh 必须显式接收：

~~~text
INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND
~~~

缺少任何参数都失败。C++ runner 不提供基于当前时间的默认 seed。

输出目录：

~~~text
outputs/formal/{test_id}[__changed-params][_N]/{instance}/{algorithm}/round_{round}_seed_{solve_seed}/
~~~

## 4. 批量运行

run_batch.sh 至少接收算例根目录、求解种子文件和算法集合。种子文件一行一个整数，空行和 # 注释可忽略。

- 实际 rounds 等于有效 seed 数量。
- 用户指定 rounds 时，必须与 seed 数量相等。
- seed 不能为空、不能重复、不能越界。
- 第 k 个 round 使用第 k 个 seed。
- 同一 round 的所有实例和算法使用相同 seed。
- 算法名 cplex_mip_python 由 run_batch.sh 路由到 run_mip.sh；其他名称路由到 C++ runner。
- 单个任务失败时，批处理立即返回非零状态。
- 只在完整结果通过基本校验时允许断点续跑。

10 rounds 的示例种子文件必须包含 10 个固定值，而不是在脚本中现场随机生成。

## 5. 算例生成

generate_instances.sh 调用 Python 工具。每个算例必须传入显式 instance_seed，并在算例目录写入：

~~~text
instance_seed.txt
index.json
~~~

批量生成时由调用者为每个算例显式提供一个 seed，并把该 seed 保存在对应算例目录；不使用 random_device、时间戳或 shell RANDOM。

## 6. CPLEX

build.sh 只构建无商业依赖的 C++ 核心。run_mip.sh 显式接收 INSTANCE_DIR、SOLVE_SEED 和 ROUND，先检查选定 Python 能否 import cplex，再调用 python/math_models/solve_cplex.py。缺少 Python API 或 license 时返回 NOT_RUN 语义，不能回退到其他求解器。

可通过 PYTHON=/path/to/python 选择已经配置 IBM CPLEX Python API 的解释器。Windows、Linux 和 WSL 都由 Bash 负责编排，不再配置或链接 Concert C++ SDK。

## 7. 分析

analyze.sh 只读取 C++ 与 CPLEX 已写出的结果。Python 不得重新计算或修正目标；发现缺失种子、重复 round、非法 JSON、不可行结果或路径穿越时返回非零状态。

## 8. audit.sh 的职责

audit.sh 是生成项目的一键体检入口，本身只调用 scripts/audit_project.py。它用于：

- 检查必需文件和禁止路径；
- 检查 EvalCache、Gurobi、Concert C++ 等禁用实现是否混入；
- 编译检查 Python 文件并检查 Bash 语法；
- 核对固定 solve seeds 是否存在、合法且不重复；
- 核对 data/ 下每个算例的 instance_seed.txt 与 index.json 是否一致；
- 构建 C++ 并运行 CTest；
- 检查当前 Python 能否 import cplex；未安装时记录 NOT_RUN；
- 把结果写入 PROJECT_AUDIT.md，并在真正失败时返回非零状态。

它不是求解脚本，不修改算法结果，也不安装 CPLEX。run_all.sh 在实验与分析之后调用它，用来防止“文件看起来齐全但实际不可构建或种子不可追溯”的交付。

## 9. 临时与正式结果

- 所有 smoke、调试和待审阅收敛产物放 outputs/tmp/。
- 正式脚本的文件名是 test_id，并对应 outputs/formal/{test_id}/。
- 改参数后设置 RESULT_VARIANT，例如 `RESULT_VARIANT=time-limit-600__population-100`；目录必须显示实际变化。
- 参数与脚本均未改变时，分配器自动选择 `_1`、`_2` 等新目录；禁止覆盖旧结果。
- run_single、run_batch、run_all 和 run_mip 通过 scripts/lib/allocate_result_root.sh 分配目录；底层 runner 默认回退到 outputs/tmp/unclassified/。

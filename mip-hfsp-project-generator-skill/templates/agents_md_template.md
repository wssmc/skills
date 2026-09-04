# AGENTS.md - 项目记忆索引

> 每次对话优先读取本文件。新增约定时同步更新，删除过时条目。

## 脚本约定

| 关键词 | 脚本 | 用途 |
|--------|------|------|
| batch | scripts/sh_batch_instances_algorithms.sh | 总批量测试（7 轮） |
| single | scripts/sh_single_instance.sh | 单算例测试 |
| bench | scripts/sh_bench_instance.sh | 单算例多算法比较 |
| analysis | scripts/sh_analysis.sh | 通用结果分析 |
| mip | scripts/mip/run_gurobi_mip.py | Gurobi MIP 精确求解 |

### 规则
1. 使用前必须将算法注册到 `scripts/run_baselines.py`
2. 禁止随意生成脚本，优先复用上述脚本
3. 所有 bash 脚本的传参要在脚本中包含默认参数，并且有注释
4. 所有实验输出仅限项目内 `outputs/` 目录

## 算法注册
注册入口：`scripts/run_baselines.py`
注册步骤：
1. `ALGO_XXX` 常量
2. `ALGO_INFO` 元数据 `AlgoInfo(name, short_name, full_name, zh_name, comment)`
3. `ALGO_DEFAULTS` 默认参数
4. `_get_solver()` 映射（elif 分支）
5. `elif algo in (...)` 分支

## 项目结构约定
- **默认求解器**: Gurobi (`gurobipy`)
- **数据层**: `data/generate.py` + `data/loader.py` (`load_instance`)
- **源代码**: `src/metaheuristics/`（不用 `algorithms/`）
- **MIP建模**: `src/math_models/`（不用 `solvers/`）
- **评估层**: `src/metaheuristics/decoding/`（feasibility_checker, metrics, eval_cache, result_reproducer）
- **邻域算子**: `src/metaheuristics/neighborhood/`（集中管理）
- **算法命名**: basic → basic_study → basic_study_xxx 三级，子算法带父算法前缀；分支用独立文件固化开关
- **默认算法**: SA, MA, IG, GA, TS
- **消融实验**: 每次改进必须消融，使用 `scripts/ablation/quick_test_config.py`
- **计算缓存**: 每次算法运行独立创建 FIFO 缓存，大小限制 500；键包含算例、序列和机器分配
- **时间公式**: `time = N_jobs * M_stages * factor`，factor 默认 0.05（单）/ 0.1（批量）
- **批处理**: 默认顺序执行；扩展并行时必须保证进程隔离、失败传播和独立缓存
- **断点续跑**: batch 脚本按单个结果文件是否存在且非空判断

## 维护规则
- 新增约定时同步更新本文件
- 删除过时条目

# AGENTS.md - 项目记忆索引

## 脚本约定

| 关键词 | 脚本 | 用途 |
|--------|------|------|
| batch | scripts/sh_batch_instances_algorithms.sh | 总批量测试 |
| single | scripts/sh_single_instance.sh | 单算例测试 |
| bench | scripts/sh_bench_instance.sh | 单算例多算法比较 |
| analysis | scripts/sh_analysis.sh | 通用结果分析 |
| mip | scripts/mip/run_gurobi_mip.py | Gurobi MIP 精确求解 |

### 规则
1. 使用前必须将算法注册到 scripts/run_baselines.py
2. 禁止随意生成脚本，优先复用上述脚本
3. 所有 bash 脚本的传参要在脚本中包含默认参数，并且有注释
4. 所有实验输出仅限项目内 `outputs/` 目录

## 算法注册
注册入口：scripts/run_baselines.py
注册步骤：
1. ALGO_XXX 常量
2. ALGO_INFO 元数据 (AlgoInfo(name, short_name, full_name, zh_name, comment))
3. ALGO_DEFAULTS 默认参数
4. solver_map 映射
5. elif 分支

## 项目结构
- 默认求解器: Gurobi (gurobipy)
- 数据层: data/generate.py + data/loader.py (load_instance)
- 源代码: src/metaheuristics/ (不用 algorithms/)
- MIP建模: src/math_models/ (不用 solvers/)
- 评估层: src/metaheuristics/decoding/ (feasibility_checker, metrics, eval_cache, result_reproducer)
- 算法命名: basic → basic_study → basic_study_xxx 三级，子算法带父算法前缀
- 默认算法: SA, MA, IG, GA, TS
- 消融实验: 每次改进必须消融，使用 scripts/ablation/quick_test_config.py

## 维护规则
- 新增约定时同步更新本文件
- 删除过时条目

# 算法要求

## 1. MIP 精确求解
- 求解器: Gurobi (`gurobipy`)
- 默认时限: 3600 秒（正式实验），60 秒（测试）
- 输出: LB + 最优可行解 + gap
- 结果必须经过 `check_feasibility` 校核

## 2. 元启发式算法（默认实现 5 个）

| 算法 | 目录 | 说明 |
|------|------|------|
| SA | `src/metaheuristics/sa/` | 模拟退火，基础版 `sa_basic.py` |
| MA | `src/metaheuristics/ma/` | 模因算法，基础版 `ma_basic.py` |
| IG | `src/metaheuristics/ig/` | 迭代贪心，基础版 `ig_basic.py` |
| GA | `src/metaheuristics/ga/` | 遗传算法，基础版 `ga_basic.py` |
| TS | `src/metaheuristics/ts/` | 禁忌搜索，基础版 `ts_basic.py` |

## 3. 算法命名规范
- **basic**: 最小可运行实现
- **study**: 在 basic 基础上完善的研究版本
- **branch**: 基于 study 的改进分支，用独立文件固化开关

## 4. 论文对比算法 (baselines)
- 存放于 `src/metaheuristics/baselines/`
- 每个对比算法一个文件
- 注册到 `run_baselines.py` 统一调度

## 5. 消融实验要求
- 每次组件改进必须消融
- 测试配置: 每规模第一个算例，固定种子，repeat=3
- 使用 `scripts/ablation/quick_test_config.py`
- 撰写消融记录文档（机制+参数+结果+结论+脚本附录+双链）

## 6. 注册要求
所有算法必须注册到 `scripts/run_baselines.py`（5 步注册流程）:
1. ALGO_XXX 常量
2. ALGO_INFO 元数据
3. ALGO_DEFAULTS 默认参数
4. solver_map 映射
5. elif 分支

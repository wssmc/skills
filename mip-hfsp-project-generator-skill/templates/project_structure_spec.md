# 项目结构规范

> 严格遵循 `项目通用结构总结.md` 的结构定义。

## 顶层目录结构

```text
project_name/
├── configs/                    # 自然语言项目规范与要求
│   ├── problem_statement.md    # 问题描述：业务背景、调度对象、目标函数
│   ├── constraints_spec.md     # 约束规范：所有约束的数学描述与自然语言解释
│   ├── algorithm_requirements.md # 算法要求：需要实现哪些算法、各算法的设计要求
│   └── experiment_plan.md      # 实验计划：对比实验设计、算例规模、评价指标
├── data/                       # 数据层：生成、读取、算例
│   ├── generate.py             # 数据生成入口
│   ├── loader.py               # 数据读取（load_instance）
│   ├── demo/                   # 展示用算例（含网络图、可视化）
│   │   └── demo_01_n_m/        # 命名: demo_0x_n_m
│   ├── small/                  # 小规模基准算例
│   │   └── inst_xxx_n_m_yy/    # 命名: inst_xxx_n_m_yy
│   ├── large/                  # 大规模基准算例
│   └── batch_seeds/            # 批量测试确定性种子表
├── docs/                       # 文档（前缀加日期：YYYY-M-Dxxx.md）
├── src/                        # 源代码核心
│   ├── core/                   # 领域模型（Instance, Schedule, Result）
│   ├── math_models/                # MIP / CP 建模（Gurobi 实现）
│   ├── metaheuristics/         # 元启发式算法
│   │   ├── initial/            # 初始化方法
│   │   ├── encoding/           # 编码方案（多套）
│   │   ├── decoding/           # 解码方案 + 增量评估 + 结果校验
│   │   ├── neighborhood/       # 邻域算子
│   │   ├── baselines/          # 论文正式对比算法
│   │   ├── sa/                 # 模拟退火
│   │   ├── ma/                 # 模因算法
│   │   ├── ig/                 # 迭代贪心
│   │   ├── ga/                 # 遗传算法
│   │   └── ts/                 # 禁忌搜索
│   ├── visualization/          # 甘特图、收敛曲线、网络图
│   ├── ExperimentAnalysis/     # 实验结果分析（自行提供，不实现）
│   └── common/                 # 通用工具
├── scripts/                    # 执行脚本
│   ├── run_baselines.py        # 中央调度枢纽（唯一 Python 入口）
│   ├── sh_single_instance.sh   # 单算例 · 单算法
│   ├── sh_bench_instance.sh    # 单算例 · 多算法对比
│   ├── sh_batch_instances_algorithms.sh  # 全量批量 · 多轮
│   ├── sh_analysis.sh          # 通用结果分析
│   ├── mip/                    # Gurobi MIP 独立入口
│   ├── doe/                    # DOE 参数校核实验
│   ├── ablation/               # 消融实验脚本
│   └── statistics/             # 非参数检验
├── tests/                      # 单元测试
├── outputs/                    # 所有实验输出
├── latex/                      # 论文写作
│   ├── els-cas-templates/      # Elsevier CAS 模板
│   └── {project_name}_bundle/  # 当前论文工作目录
├── requirements.txt
├── AGENTS.md                   # 项目记忆索引
└── README.md
```

## 禁止生成的目录

| 路径 | 原因 |
|------|------|
| `src/algorithms/` | 替换为 `src/metaheuristics/` |
| `src/solvers/` | 替换为 `src/math_models/` |
| `src/io/` | 数据读取迁移到 `data/loader.py` |
| `src/problems/` | 问题逻辑合并到 `src/core/` |
| `src/constraints/` | 约束检查在 `decoding/feasibility_checker.py` |
| `src/resources/` | 空壳目录 |
| `src/utils/` | 通用工具移至 `src/common/` |
| `src/evaluation/` | 评估逻辑在 `decoding/` 下 |
| `configs/*.json` | configs/ 改为自然语言文档 |

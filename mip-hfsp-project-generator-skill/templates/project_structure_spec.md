# 项目结构规范

> 本文件与 `modules/structure.md`、`code_templates/project_tree.txt` 同步；不得引用仓库外或已忽略的结构文档。

## 顶层目录结构

```text
project_name/
├── configs/                    # 自然语言项目规范与要求
│   ├── problem_statement.md    # 问题描述：业务背景、调度对象、目标函数
│   ├── constraints_spec.md     # 约束规范：所有约束的数学描述与自然语言解释
│   ├── algorithm_requirements.md # 算法要求：需要实现哪些算法、各算法的设计要求
│   ├── experiment_plan.md      # 实验计划：对比实验设计、算例规模、评价指标
│   ├── conventions.md          # 用户约定与生成决策
│   └── problem_fingerprint.json # 结构化问题特征（configs 中唯一默认 JSON）
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
│   │   ├── base_solver/        # 统一求解器生命周期与评估接口
│   │   ├── initial/            # 初始化方法
│   │   ├── encoding/           # 编码方案（多套）
│   │   ├── decoding/           # 解码、缓存、可行性、指标与结果复现
│   │   ├── neighborhood/       # 邻域算子
│   │   ├── baselines/          # 论文正式对比算法
│   │   ├── sa/                 # 模拟退火
│   │   ├── ma/                 # 模因算法
│   │   ├── ig/                 # 迭代贪心
│   │   ├── ga/                 # 遗传算法
│   │   └── ts/                 # 禁忌搜索
│   └── visualization/          # 甘特图、收敛曲线与比较图
├── scripts/                    # 执行脚本
│   ├── run_baselines.py        # 中央调度枢纽（唯一 Python 入口）
│   ├── audit_project.py        # 运行真实结构、语法、注册表和 smoke 审计
│   ├── sh_single_instance.sh   # 单算例 · 单算法
│   ├── sh_bench_instance.sh    # 单算例 · 多算法对比
│   ├── sh_batch_instances_algorithms.sh  # 全量批量 · 多轮
│   ├── sh_analysis.sh          # 通用结果分析
│   ├── mip/                    # Gurobi MIP 独立入口
│   ├── doe/                    # DOE 参数校核实验
│   ├── ablation/               # 消融实验脚本
│   └── statistics/             # 非参数检验
├── tests/
│   └── smoke_test.py           # 核心链与全部注册算法的回归测试
├── outputs/                    # 所有实验输出
├── latex/                      # 论文写作
│   ├── paper/
│   │   ├── main.tex
│   │   ├── sections/
│   │   │   ├── 01_introduction.tex
│   │   │   ├── 02_related_work.tex
│   │   │   ├── 03_problem_formulation.tex
│   │   │   ├── 04_solution_approaches.tex
│   │   │   ├── 05_computational_experiments.tex
│   │   │   └── 06_conclusion.tex
│   │   ├── figures/
│   │   ├── tables/
│   │   ├── algorithms/
│   │   ├── bib/
│   │   │   └── references.bib
│   │   └── appendices/
│   ├── templates/
│   │   └── els-cas-templates/  # 期刊模板原文件（不混入正文工程）
│   └── README.md
├── requirements.txt
├── AGENTS.md                   # 项目记忆索引
├── IMPLEMENTATION_STATUS.md    # 未验证前不得标 complete
├── PROJECT_AUDIT.md            # 初始 NOT_RUN，由审计脚本覆写真实结果
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
| `src/utils/` | 不生成；工具按领域归入现有模块 |
| `src/evaluation/` | 评估逻辑在 `decoding/` 下 |
| `configs/*.json`（除 `problem_fingerprint.json`） | configs 默认使用自然语言文档 |

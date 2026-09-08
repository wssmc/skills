# 项目交互约定

- Skill：mip-scheduling-project-generator-skill v{{version}}
- 生成日期：{{YYYY-MM-DD}}

## 固定架构

- C++17 核心
- Python 3：算例、CPLEX MIP 和分析
- Bash 统一执行
- IBM 官方低层 `cplex` Python API MIP
- 不使用 EvalCache、Concert C++、Gurobi 或 docplex

## 问题模型

- 问题类型：{...}
- 实体与资源：{...}
- 候选解：{...}
- 约束与目标：{...}
- 当前流水车间参考是否适用：{yes/no_and_changes}

## 种子

- instance seed：每个算例目录保存一个 instance_seed.txt，并写入 index.json
- solve seeds 文件：configs/seeds/solve_seeds.txt
- rounds：{N}
- seed 数量：{N}
- 同轮配对比较：yes

## 用户要求

| 日期 | 要求或决策 | 影响文件 |
|---|---|---|
| {{YYYY-MM-DD}} | {requirement} | {files} |

## 状态

未实际验证的模块保持 not_verified 或 placeholder。

## 输出与收敛

- smoke、调试和临时图：outputs/tmp/
- 正式脚本 `{test_id}.sh`：outputs/formal/{test_id}[__changed-params][_N]/，不得覆盖
- 收敛协议：docs/convergence_protocol.md；使用进程 CPU、唯一全局精英事件、每 seed 独立 100 点离线采样和右连续阶梯图

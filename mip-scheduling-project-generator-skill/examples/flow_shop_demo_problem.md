# Flow-shop reference demo

这是通用 Skill 的流水车间参考适配，不代表 Skill 只支持 HFSP。

- 问题数据模型：FlowShopInstance
- 核心：C++17
- MIP：IBM 官方 `cplex` Python API
- 辅助：Python 算例与分析
- 编排：Bash
- instance_seed：42
- solve seeds：由 configs/seeds/solve_seeds.txt 提供
- 评价缓存：无

示例：

~~~bash
scripts/build.sh
scripts/generate_instances.sh data/demo/demo_01_10_5 10 5 42
scripts/run_single.sh data/demo/demo_01_10_5 sa_basic 104729 1
scripts/run_batch.sh data/demo configs/seeds/solve_seeds.txt
~~~

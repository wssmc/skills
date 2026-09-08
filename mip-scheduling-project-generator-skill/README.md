# mip-scheduling-project-generator-skill

本 Skill 生成可复现的调度与运筹研究工程，而不是只生成 HFSP 项目。

- C++17：问题数据模型、解表示、评价、可行性、启发式算法、registry 和结果
- Python 3：算例生成、结果汇总、统计、绘图和报告；MIP 使用 IBM 官方 `cplex` Python API，作为唯一求解例外
- Bash：构建、生成数据、单次运行、固定种子多轮实验、分析和审计
- 随机性：每个算例保存自己的生成种子；N 轮求解必须提供 N 个固定 seeds
- 评价：不使用 EvalCache，不生成跨运行缓存
- 输出：烟测统一进入 outputs/tmp/；正式结果按测试脚本名进入 outputs/formal/，改参标在目录名，原配置重跑用 `_1`、`_2`
- 收敛：统一使用包含初始化的进程 CPU budget、全局精英事件和 100 点离线阶梯采样

当前参考实现主要面向流水车间问题族。其他调度或运筹问题必须根据问题描述重建问题模型、解表示、checker、算法和 CPLEX 模型，不能直接套用流水车间假设。

项目根目录的 AGENTS.md 是项目级系统提示词。生成、修改、运行和审计前必须先读取。

验证 Skill：

~~~bash
python mip-scheduling-project-generator-skill/scripts/validate_skill.py
~~~

# AGENTS.md - 项目级系统提示词

## 当前问题

- 问题类型：{problem_type}
- 问题数据模型：{problem_model}
- 直接支持：{supported_scope}
- 需适配：{adapter_required_scope}

## 工程边界

- C++17：问题模型、解表示、评价、checker、启发式算法、registry 和结果。
- Python 3：算例生成、CPLEX MIP、分析、统计、绘图和报告。
- Bash：构建、测试、固定种子运行、批处理、分析、审计。
- 不生成 EvalCache、Concert C++、Gurobi、docplex 或 CPLEX MIP 以外的 Python 核心求解器。

## 种子

- instance seed：每个算例目录的 instance_seed.txt，并记录在 index.json
- solve seeds：configs/seeds/solve_seeds.txt
- N rounds 必须有 N 个固定且不重复的 solve seeds。
- 同一 round 跨算法使用相同 seed。
- runner 显式接收 solve_seed 和 round，结果记录两类 seed。

## 执行与输出

- registry：cpp/include/scheduling/registry.hpp
- runner：solver_run
- Bash 入口：scripts/build.sh、generate_instances.sh、run_single.sh、run_batch.sh、run_all.sh、analyze.sh、audit.sh
- 烟测、调试和待审阅收敛产物：outputs/tmp/
- 正式脚本 `{test_id}.sh` 只写 `outputs/formal/{test_id}[__参数变化][_N]/`
- 参数变化必须显示在目录名；配置未变的重复运行依次追加 `_1`、`_2`，不得覆盖
- 正式结果保存脚本版本、有效参数和 seeds

## 进度更新

仅在开始、里程碑、新发现、失败/阻塞/授权和完成时更新；不逐命令、seed、算例或 round 汇报。30 秒内事件合并；批量实验无新事件时每 2 小时一次，其他长任务最多约每 60 秒一次；完成或失败立即报告，中间更新 1–3 行。

## CPU 收敛曲线

- CPU budget 含初始化；记录 T_init、E_init、C_init，以初始化结束作为 Normalized time=0。
- 只记录 INIT、严格全局改善的 IMPROVE 和 END；多阶段算法共用一个不可重置的全局精英，结束时精英必须等于返回 Cmax。
- 每个 seed 的一次完整运行离线采样 100 点：前 50 点覆盖 [0,0.2]，后 50 点覆盖 (0.2,1]；前向保持、不插值，绘制右连续阶梯图。
- 临时曲线放 outputs/tmp/convergence/；正式结论使用正式多 seed 统计，单条曲线只作 representative profile。

## 质量

问题模型变化时同步更新 loader、evaluator、checker、algorithms、CPLEX、serialization、Bash 和 tests。未验证功能保持 not_verified/placeholder，不静默失败，不保留兼容层。

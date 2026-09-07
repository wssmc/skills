# 模块：质量保障

## 1. 实现状态与占位边界

项目根目录必须包含 `IMPLEMENTATION_STATUS.md`，状态仅允许：`complete`、`runnable_mvp`、`placeholder`、`not_applicable`、`not_verified`。初始模板统一为 `not_verified`，未经运行不能预填 PASS。

下列 C++ 核心模块不得被 Python 替代：

```text
cpp/include/hfsp/core/domain.hpp
cpp/include/hfsp/io/instance_loader.hpp
cpp/include/hfsp/decoding/
cpp/include/hfsp/metaheuristics/
cpp/include/hfsp/registry.hpp
cpp/src/
cpp/apps/hfsp_run.cpp
cpp/tests/smoke_test.cpp
```

Python 辅助模块是：

```text
python/tools/
python/analysis/
python/statistics/
python/visualization/
```

可选 MIP、额外算法或统计功能若未实现，必须标 `placeholder`/`not_verified`，并在调用处显式失败；不得静默返回伪结果。

## 2. 文档与约定持久化

自然语言约定不能只留在对话中。最小文档集合：

```text
AGENTS.md
configs/problem_statement.md
configs/constraints_spec.md
configs/algorithm_requirements.md
configs/experiment_plan.md
configs/conventions.md
configs/problem_fingerprint.json
docs/*_problem_description.md
docs/*_modeling_assumptions.md
docs/*_algorithm_design.md
docs/*_experiment_plan.md
docs/root_cause_fix_log.md
```

`AGENTS.md` 是项目级系统提示词：生成、修改和审计前必须读取；它写明语言边界、构建命令、注册入口、输出策略和禁止事项。架构变更必须同步更新它和 `README.md`。

## 3. 必须通过的回归测试

`cpp/tests/smoke_test.cpp` 至少覆盖：

1. demo 加载与 `Instance::validate()`；
2. 编码、解码和目标计算；
3. 跨阶段同号机器不会被合并；
4. checker 验证作业前序、阶段机器不重叠、加工时长和目标一致性；
5. C++ registry 中每个 runnable 算法；
6. 每个算法实际产生 EvalCache miss，且 cache 容量为 500、任务间隔离；
7. `best_sequence` 重放后 objective 一致；
8. 结果 JSON/CSV/trace 写入 `outputs/`。

Python 分析测试只验证输入校验、路径安全、汇总列和统计前置条件，不能重新验证或修改调度目标。

## 4. 自动审计

`PROJECT_AUDIT.md` 初始状态必须为：

```text
Overall: NOT_RUN
```

`scripts/audit_project.py` 至少检查：

- CMake、C++ 核心路径和禁止旧目录；
- C++ 构建与 CTest smoke；
- Python 辅助模板可编译；
- AST 中不存在静默 `except: pass`；
- C++ registry 名称与状态一致；
- 结果产物和 `AGENTS.md` 存在。

任何依赖缺失、Gurobi license 缺失或检查未执行都写 `NOT_RUN`，不能把静态检查当作运行通过。

## 5. 代码质量红线

- C++ 是唯一的求解、解码、可行性和目标实现；Python 不得建立第二套算法。
- 不按算例名、job ID 或阶段数打补丁；不使用裸 `catch`、静默异常或跳过失败测试。
- 不保留旧参数、旧路径、模块 alias 或双格式迁移层；接口变更一次性更新全部调用点。
- 不从 schedule 反推 `best_sequence`，不跨任务共享 EvalCache，不输出 `NaN`/`Infinity`。
- Python 分析失败必须返回非零状态，不得吞掉 C++ 失败或改写核心结果。

缺陷处理顺序：根因分析 → 修复 C++ 设计和全部调用点 → 添加 C++ 回归测试 → 运行 smoke/审计 → 更新 `docs/root_cause_fix_log.md`。

## 6. 交付摘要

最终摘要只能引用实际输出：

```text
Audit summary:
- CMake/C++ build: PASS/FAIL/NOT_RUN
- C++ smoke: PASS/FAIL/NOT_RUN
- Python analysis checks: PASS/FAIL/NOT_RUN
- Project audit: PASS/FAIL/NOT_RUN
- Registered runnable algorithms: <names>
- Cross-stage resource regression: PASS/FAIL
- best_sequence reproduction: PASS/FAIL
- Cache isolation: PASS/FAIL
- Remaining adapter-required features: <list or none>
```

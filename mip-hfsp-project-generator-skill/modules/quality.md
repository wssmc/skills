# 模块：质量保障

## 导航

- §1 实现状态与占位边界
- §2 文档与约定持久化
- §3 必须通过的回归测试
- §4 自动审计
- §5 代码质量红线
- §6 交付摘要

## 1. 实现状态与占位边界

项目根目录必须包含 `IMPLEMENTATION_STATUS.md`，状态仅允许：

| 状态 | 含义 |
|---|---|
| `complete` | 功能与约定全部实现，并有相应验证 |
| `runnable_mvp` | 核心链可运行，边界已明确并有 smoke 覆盖 |
| `placeholder` | 未实现，不得注册为可运行能力 |
| `not_applicable` | 当前项目明确不需要 |
| `not_verified` | 已生成但尚未执行验证 |

初始模板必须使用 `not_verified`，不能在测试前预填 `complete` 或 PASS。

下列核心模块不得占位：

```text
data/generate.py
data/loader.py
src/core/domain.py
src/metaheuristics/encoding/
src/metaheuristics/decoding/
src/metaheuristics/base_solver/
src/metaheuristics/registry.py
scripts/run_baselines.py
scripts/audit_project.py
tests/smoke_test.py
```

DOE、消融或额外算法只有在用户需要时才生成。未实现的可选能力可以不创建；若创建占位目录，必须包含 `PLACEHOLDER.md`，调用入口必须 `raise NotImplementedError`，且不得注册为可运行算法。不得为目录树“完整”创建空壳。

## 2. 文档与约定持久化

自然语言约定不能只留在对话中。最小文档集合：

```text
configs/problem_statement.md
configs/constraints_spec.md
configs/algorithm_requirements.md
configs/experiment_plan.md
configs/conventions.md
configs/problem_fingerprint.json
docs/YYYY-M-D_problem_description.md
docs/YYYY-M-D_modeling_assumptions.md
docs/YYYY-M-D_instance_design.md
docs/YYYY-M-D_algorithm_design.md
docs/YYYY-M-D_experiment_plan.md
docs/root_cause_fix_log.md
```

`problem_fingerprint.json` 是 `configs/` 中唯一默认 JSON。基础模板直接支持 basic HFSP；任何 Job 间显式 precedence、re-entry、可跳阶段、可选工艺路线、序列相关换型、人工/运输资源或多目标特征都必须标记 `adapter_required`，直至领域模型、编码、解码、checker、MIP 和回归测试同时更新。

约定持久化映射：

| 约定 | 文件 |
|---|---|
| 问题边界与用户澄清 | `docs/*_problem_description.md` |
| 建模假设 | `docs/*_modeling_assumptions.md` |
| 算例规模、分布、种子 | `docs/*_instance_design.md` |
| 初始化、缓存、算法参数 | `docs/*_algorithm_design.md` |
| 轮次、时限、指标 | `docs/*_experiment_plan.md` |
| 输出、命名、依赖偏好 | `configs/conventions.md` |

## 3. 必须通过的回归测试

`tests/smoke_test.py` 不是“能 import”测试，至少覆盖：

1. demo 加载与 `Instance.validate()`。
2. 编码生成、解码和指标计算。
3. 跨阶段机器 ID 相同时资源不被错误合并：2 阶段 × 每阶段机器 0 的回归算例 makespan 应为 3，而不是 4。
4. `check_feasibility` 验证覆盖、阶段优先关系、显式 precedence、阶段级机器无重叠、加工时长和目标一致性。
5. 注册表中的 `random_search`、`sa_basic`、`ma_basic`、`ig_basic`、`ga_basic`、`ts_basic` 全部运行。
6. 每个算法实际产生缓存 miss；不能只创建未使用的缓存对象。
7. `best_seq` 可 JSON 序列化，并能复现相同 objective 与可行 schedule。
8. `result.json`、`schedule.json`、`trace.csv` 和甘特图能够写出。

项目安装 `requirements.txt` 后运行：

```bash
python tests/smoke_test.py
```

技能仓库自身的轻量验证允许显式设置 `HFSP_SMOKE_SKIP_VISUALIZATION=1`，仅用于没有 matplotlib 的技能维护环境；生成项目的正式审计不得隐式跳过可视化。

## 4. 自动审计

`PROJECT_AUDIT.md` 模板初始状态必须为：

```text
Overall: NOT_RUN
```

只有 `python scripts/audit_project.py` 可以根据真实检查结果写入 PASS/FAIL。审计至少检查：

- 必需文件和禁止旧目录；
- Python 模板可编译；
- AST 中不存在静默 `except: pass`；
- demo smoke 完整运行；
- 注册表名称、状态与可运行集合一致；
- 失败时写报告并返回非零状态。

审计命令：

```bash
python scripts/audit_project.py
```

审计报告不是测试替代品。任何检查未运行、依赖缺失或产物缺失都不能写成 PASS。

## 5. 代码质量红线

- 不按算例名、job ID、阶段数等特殊值打补丁。
- 不用裸 `except` 或 `except Exception: pass` 掩盖核心失败。
- 不保留旧参数、旧路径、模块 alias 或双格式分支作为迁移层；接口变更时一次性更新调用方。
- 不从 schedule 反推 `best_seq`。
- 不跨算法或跨算例共享 `EvalCache`。
- 不在 JSON 中写 `NaN`/`Infinity`。
- 不把未运行测试的模板文案当作审计证据。
- 不为不存在的模块、脚本、并行机制或统计能力写“已实现”。

遇到缺陷时执行：根因分析 → 修复设计与全部调用点 → 添加最小回归测试 → 运行 smoke 与审计 → 更新 `docs/root_cause_fix_log.md`。

## 6. 交付摘要

最终摘要只能引用实际输出：

```text
Audit summary:
- Skill validator: PASS/FAIL
- Generated-project smoke: PASS/FAIL/NOT_RUN
- Project audit: PASS/FAIL/NOT_RUN
- Registered runnable algorithms: <names>
- Cross-stage resource regression: PASS/FAIL
- best_seq reproduction: PASS/FAIL
- Cache isolation: PASS/FAIL
- Remaining adapter-required features: <list or none>
```

如果因缺少 Gurobi license、matplotlib 或其他依赖而未运行某项，必须写 `NOT_RUN` 并说明原因，不能把静态编译当成运行通过。

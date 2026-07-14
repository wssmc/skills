# 输出质量检查清单

生成项目后必须检查：

## 数据

- [ ] 主体数据保存为 txt
- [ ] index.json 能正确索引 txt（不记录 seed）
- [ ] demo 算例可人工检查（命名 `demo_0x_n_m`）
- [ ] small / large 算例可复现（命名 `inst_xxx_n_m_yy`）
- [ ] `data/generate.py` 不在算例生成时传 seed
- [ ] `data/loader.py` 统一 `load_instance(dir) -> Instance` 接口
- [ ] `data/batch_seeds/` 种子文件存在（seed_table.json + round{r}.json）

## MIP (Gurobi)

- [ ] 默认使用 Gurobi (`gurobipy`)，不使用 CPLEX/docplex
- [ ] 可设置 time_limit（默认 3600s 正式 / 60s 测试）
- [ ] 可设置 MIPGap
- [ ] 输出 LB（下界）和最优可行解
- [ ] 输出 status、objective、LB、gap、runtime
- [ ] 结果经过 `check_feasibility` 校核
- [ ] 输出 result.json + schedule.csv + gantt.png
- [ ] 独立入口 `scripts/mip/run_gurobi_mip.py`，不走 run_baselines.py

## 解码与评估

- [ ] 满足 Stage precedence
- [ ] 满足 machine no-overlap
- [ ] 满足 release time
- [ ] `check_feasibility(instance, schedule) -> violations` 存在
- [ ] `metrics.py` 计算 makespan / total_tardiness / average_flow_time
- [ ] `eval_cache.py` FIFO 队列大小限制 500
- [ ] **所有元启发式算法（SA/MA/IG/GA/TS）都 import 并使用 EvalCache**
- [ ] **EvalCache 上限固定为 500，弹出策略为 FIFO**
- [ ] **算法内部通过 `evaluate(seq)` 函数统一调用缓存**，而非直接 decode+evaluate_schedule
- [ ] **算法适配（如有）：原算法的初始化已按用途提取——单解算法用 `src/metaheuristics/initial/single/`，种群算法用 `src/metaheuristics/initial/population/`**
- [ ] **`initial/single/` 与 `initial/population/` 严格分离**：单解生成器返回 `list[int]`，种群生成器返回 `list[list[int]]`
- [ ] **GA/MA 使用 `generate_xxx_population()` 生成种群**，不循环调用单解生成器
- [ ] **种群生成器保证 pop_size 个体互不相同**（ensure_diversity=True）
- [ ] **`sh_batch_instances_algorithms.sh` 支持 `--unified-init` 和 `--unified-cache` 开关（交互式提示 + 命令行）**
- [ ] **算法接受 `cache` 和 `init_fn` kwargs**，可被 `run_baselines.py` 从外部注入
- [ ] **批量对比默认使用统一初始化 + 统一缓存**，非默认设置在 `configs/conventions.md` 记录
- [ ] **`docs/YYYY-M-D_algorithm_design.md` 明确记录 EvalCache 强制约定 + 算法适配 + 批量一致性约定**
- [ ] `result_reproducer.py` 能从 txt 的 best_seq 复现目标值
- [ ] `incremental_eval.py` 增量评估存在
- [ ] 输出统一 Schedule 格式
- [ ] **相似解码器输入输出一致**；不同编码类型（seq vs seq_machine）不强制一致

## 算法

- [ ] 默认实现 SA, MA, IG, GA, TS 五个 basic 算法
- [ ] 算法签名: `solve_xxx(...) -> (Schedule, trace_list, best_seq)`
- [ ] **best_seq 是算法返回的最优编码序列**，不从 schedule 反推
- [ ] 所有算法注册到 `run_baselines.py`（5 步注册流程）
- [ ] `run_baselines.py` 不设算法内部开关参数
- [ ] 邻域算子集中在 `metaheuristics/neighborhood/`
- [ ] 论文对比算法在 `metaheuristics/baselines/`
- [ ] **算法分支命名带父算法前缀**（如 `sa_basic_study_conditioned`）
- [ ] **算法打印遵循规范**（`[algo_name]` 前缀，verbose 分级）

## 脚本与输出

- [ ] `scripts/run_baselines.py` 中央调度枢纽存在
- [ ] `sh_single_instance.sh` 输出 schedule.json + gantt.png
- [ ] `sh_bench_instance.sh` 多算法对比
- [ ] `sh_batch_instances_algorithms.sh` 7 轮 + 断点续跑
- [ ] `sh_analysis.sh` 通用结果分析
- [ ] `scripts/mip/run_gurobi_mip.py` 独立 MIP 入口
- [ ] `scripts/ablation/quick_test_config.py` 固化小实验配置
- [ ] 所有 bash 脚本含默认参数和注释
- [ ] 输出四件套: result.json / schedule.json|csv / trace.csv / gantt.png
- [ ] **txt 输出保存 best_seq**（算法返回的编码序列）
- [ ] **trace.csv 格式**: iteration, time, objective
- [ ] **消融实验原始结果**存 `outputs/ablation/{algo}/{name}/raw/`
- [ ] 输出仅在 `outputs/` 目录内

## Smoke 测试

- [ ] `tests/smoke_test.py` 存在
- [ ] 生成项目后**立即运行** `python tests/smoke_test.py` 通过
- [ ] 验证链路: 读取 → 编码 → 解码 → 评估 → 可行性 → 算法运行 → 产物写入

## 收敛曲线

- [ ] trace.csv 含 iteration, time, objective 三列
- [ ] convergence.png 支持 PNG（200 DPI）和 PDF
- [ ] 多算法对比时附图例，标注最终目标值

## 论文写作

- [ ] `latex/` 目录含期刊模板和项目工作目录
- [ ] `templates/thirdPartSkills.md` 定义写作 Skill 调用
- [ ] 使用 `literature-matrix-review-skill-v2.1` 生成两类文献矩阵
- [ ] 引言、相关工作、问题描述初稿由写作 Skill 辅助生成

## 代码质量红线（严禁打补丁 + 严禁兼容层）

> 详见 SKILL.md §8。以下项目**任何一项失败都必须重写代码，不得交付**。

### §8.1 严禁打补丁
- [ ] **无特殊值特判**：代码中无 `if inst_name == "..."` / `if job_id == N` 类根因外的硬编码分支
- [ ] **无异常静默**：无 `except Exception: pass` / `except: pass` / `except: return None`
- [ ] **无临时注释关键字**：核心代码（`src/`、`data/`）中无"临时/暂时/绕过/待重构/先这样/TODO 后修"
- [ ] **无被注释掉的失败代码**：不允许 `# xxx = decode(...)  # 有 bug` 加 mock 替代
- [ ] **无 `@pytest.mark.skip("暂时通不过")`**：只允许因缺少外部依赖（如 Gurobi）的 `pytest.importorskip`
- [ ] **异常类型明确**：所有 `except` 都是特定类型（`FileNotFoundError`、`ValueError` 等），非泛型 catch
- [ ] **占位使用 NotImplementedError**：占位函数明确 raise，禁止 `def f(): pass` 或返回伪值

### §8.2 严禁兼容层
- [ ] **无旧接口 shim**：无 `def old_name(*args, **kw): return new_name(*args, **kw)` 模式
- [ ] **无 DeprecationWarning 包装**：无 `warnings.warn("use new_api")` 保留旧接口
- [ ] **无旧参数/新参数并存**：函数签名不含 `old_name=None, new_name=None` 二选一
- [ ] **无双格式支持分支**：无 `if isinstance(seq, list): ... elif isinstance(seq, dict): ...` 支持新旧数据格式
- [ ] **无版本判断分支**：无 `if data.get("version") == "v1": ...` 类多版本共存
- [ ] **无模块级 alias**：无 `OldClass = NewClass` / `from new_mod import X as OldX`
- [ ] **无旧路径 fallback**：无 `if not new_path.exists(): return read(old_path)`
- [ ] **无兼容注释关键字**：无"兼容/legacy/deprecated/保留旧接口/过渡期/两版本共存"

### §8.4 补丁例外（须显式声明 + 文档登记）
- [ ] **补丁例外有明确注释**：`# UPSTREAM BUG:` 类注释必须解释原因并在 `docs/root_cause_fix_log.md` 记录
- [ ] 例外总数受控（建议 < 5 处，每处均需 docs 登记）

## 工程

- [ ] `src/metaheuristics/` 组织算法（不用 `algorithms/`）
- [ ] `src/math_models/` 存放 Gurobi MIP（不用 `solvers/`）
- [ ] 评估逻辑在 `decoding/` 下（不用 `evaluation/`）
- [ ] `configs/` 存放自然语言文档（不放 JSON）
- [ ] `AGENTS.md` 项目记忆索引存在
- [ ] `requirements.txt` 含 gurobipy
- [ ] tests/ 含 smoke_test + test_loader / test_decoder / test_feasibility_checker / test_gurobi_model / test_gantt
- [ ] README 含运行命令和 7 阶段执行步骤
- [ ] 输出目录自动创建
- [ ] `docs/` 文件前缀加日期 `YYYY-M-D`

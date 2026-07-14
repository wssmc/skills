# Project Audit

> Generated: {date}

## Structure Check

| Check | Result | Notes |
|---|---|---|
| Top-level structure | PASS | All required directories present |
| data directory structure | PASS | generate.py, loader.py, demo/, small/, large/, batch_seeds/ |
| src directory structure | PASS | core/, math_models/, metaheuristics/, visualization/, common/ |
| Empty directories | PASS | {count} empty directories |

## Legacy Cleanup Check

| Check | Result | Notes |
|---|---|---|
| Forbidden directories | PASS | none |
| Forbidden imports | PASS | none |
| Forbidden path mentions | PASS | none |

## Placeholder Check

| Check | Result | Notes |
|---|---|---|
| Placeholder modules declared | PASS | {count} placeholders with PLACEHOLDER.md |
| Core modules non-placeholder | PASS | All core modules are runnable |

## Algorithm Registration Check

| Check | Result | Notes |
|---|---|---|
| Runnable algorithms registered | PASS | {count} algorithms in registry |
| Placeholder algorithms not registered | PASS | Placeholder algorithms excluded |
| Algorithm status documented | PASS | ALGORITHM_STATUS populated |
| **EvalCache used in all metaheuristics** | PASS | All 5 basic algorithms + baselines use EvalCache(max_size=500, FIFO) |
| **EvalCache convention documented** | PASS | docs/YYYY-M-D_algorithm_design.md §1 |
| **Adapted algorithms extract init to initial/** | PASS | All adapted algorithms have init in src/metaheuristics/initial/single or /population |
| **initial/single vs initial/population separated** | PASS | Single-solution generators isolated from population generators |
| **Population algorithms use generate_xxx_population()** | PASS | GA/MA use population generators, not loops over single-solution ones |
| **sh_batch supports --unified-init/--unified-cache** | PASS | Interactive prompt + CLI flags implemented |
| **Algorithms accept cache/init_fn kwargs** | PASS | All 5 basic algorithms accept optional cache and init_fn |

## Runtime Check

| Check | Result | Notes |
|---|---|---|
| Demo load | PASS | Instance loaded successfully |
| Demo decode | PASS | feasible={feasible} |
| Feasibility checker | PASS | violations={violations} |
| Smoke test | PASS | All smoke tests passed |
| Pytest | PASS | {passed} passed, {failed} failed |
| Output isolation | PASS | All outputs in outputs/ |

## Code Quality Red-line Check (SKILL.md §8)

> **任何一项 FAIL 都必须重写代码，不得交付**。

### §8.1 No Patching
| Check | Result | Notes |
|---|---|---|
| No special-case patches (硬编码算例名/job_id 特判) | PASS | grep 未发现 `if.*inst_name.*==` / `if.*job_id.*==\d` 硬编码模式 |
| No silent exception swallowing | PASS | 无 `except Exception: pass` / `except: pass` / `except: return None` |
| No "临时/暂时/绕过/待重构" 注释 in src/ or data/ | PASS | 核心模块干净 |
| No `@pytest.mark.skip("...")` (除 importorskip 外) | PASS | 无被临时跳过的测试 |
| All exceptions are specific types | PASS | 无泛型 catch |
| Placeholder functions raise NotImplementedError | PASS | 无 `def f(): pass` 或返回伪值 |

### §8.2 No Backward-Compat Layer
| Check | Result | Notes |
|---|---|---|
| No old-name shims (`def old(): return new()`) | PASS | 无 shim 转发 |
| No `DeprecationWarning` / `warnings.warn` wrapping old APIs | PASS | 无旧接口废弃包装 |
| No dual parameter names (`old=None, new=None` picks one) | PASS | 参数签名单一 |
| No dual-format branches (`isinstance(x, list) elif dict`) | PASS | 单一数据格式 |
| No version guards (`if data['version'] == 'v1'`) | PASS | 单一版本 |
| No module aliases (`OldClass = NewClass`) | PASS | 无重命名保留 |
| No fallback paths (`if not new.exists(): return read(old)`) | PASS | 单一路径 |
| No "兼容/legacy/deprecated/过渡期" comments | PASS | 无兼容层痕迹 |

### §8.4 Exception Registry
| Check | Result | Notes |
|---|---|---|
| All `# UPSTREAM BUG:` comments documented in docs/root_cause_fix_log.md | PASS | 例外说明均可追溯 |
| Exception count within limit | PASS | {count} 处 (建议 < 5) |

## Convention Persistence Check

| Check | Result | Notes |
|---|---|---|
| `configs/conventions.md` | PASS | User interaction conventions recorded |
| `configs/problem_statement.md` | PASS | Problem statement recorded |
| `configs/constraints_spec.md` | PASS | Constraints recorded |
| `configs/algorithm_requirements.md` | PASS | Algorithm requirements recorded |
| `configs/experiment_plan.md` | PASS | Experiment plan recorded |
| `configs/problem_fingerprint.json` | PASS | Problem fingerprint generated |
| `docs/YYYY-M-D_problem_description.md` | PASS | Problem description with clarifications |
| `docs/YYYY-M-D_modeling_assumptions.md` | PASS | Modeling decisions recorded |
| `docs/YYYY-M-D_instance_design.md` | PASS | Instance design rationale recorded |
| `docs/YYYY-M-D_algorithm_design.md` | PASS | Algorithm design conventions recorded |
| `docs/YYYY-M-D_experiment_plan.md` | PASS | Experiment plan rationale recorded |
| All dialog conventions persisted | PASS | No conventions left in context only |

## Summary

- Legacy directories: 0
- Empty directories: {empty_count}
- Placeholder modules: {placeholder_count}
- Runnable MVP algorithms: {mvp_count}
- Complete algorithms: {complete_count}
- Registered runnable algorithms: {registered_count}
- Tests: {passed} passed, {failed} failed
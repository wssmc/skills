# AGENTS.md - 项目记忆索引

## 项目目的
{project_purpose}

## 问题类型
{problem_type}

## 核心假设
{core_assumptions}

## 实例设计
{instance_design}

## 资源映射
{resource_mapping}

## 脚本约定

| 关键词 | 脚本 | 用途 |
|--------|------|------|
| batch | scripts/sh_batch_instances_algorithms.sh | 总批量测试 |
| single | scripts/sh_single_instance.sh | 单算例测试 |
| bench | scripts/sh_bench_instance.sh | 单算例多算法比较 |
| analysis | scripts/sh_analysis.sh | 通用结果分析 |
| mip | scripts/mip/run_gurobi_mip.py | Gurobi MIP 精确求解 |

### 规则
1. 使用前必须将算法注册到 `src/metaheuristics/registry.py`
2. 禁止随意生成脚本，优先复用上述脚本
3. 所有 bash 脚本的传参要在脚本中包含默认参数，并且有注释
4. 所有实验输出仅限项目内 `outputs/` 目录

## 算法注册表
注册入口：`src/metaheuristics/registry.py`
- `ALGORITHM_REGISTRY`：算法名称 → solver 函数映射
- `ALGORITHM_STATUS`：算法状态（complete / runnable_mvp / placeholder / not_applicable）
- 占位算法不注册，若注册则运行时必须报错

## 占位策略
- 占位模块必须有 `PLACEHOLDER.md`
- 占位代码必须 `raise NotImplementedError`
- 占位模块默认不注册到算法注册表

## 禁止的旧版路径
以下路径不得出现在项目中：
```
src/algorithms/  src/solvers/  src/io/  src/evaluation/
src/problems/  src/constraints/  src/resources/  src/utils/
```

## 项目结构约定
- **默认求解器**: Gurobi (`gurobipy`)
- **数据层**: `data/generate.py` + `data/loader.py` (`load_instance`)
- **源代码**: `src/metaheuristics/`（不用 `algorithms/`）
- **MIP建模**: `src/math_models/`（不用 `solvers/`）
- **评估层**: `src/metaheuristics/decoding/`（feasibility_checker, metrics, eval_cache, result_reproducer）
- **邻域算子**: `src/metaheuristics/neighborhood/`（集中管理，含问题特性邻域）
- **算法命名**: basic → basic_study → basic_study_xxx 三级；子算法带父算法前缀
- **默认算法**: SA, MA, IG, GA, TS + 问题特性启发式
- **消融实验**: 每次改进必须消融，使用 `scripts/ablation/quick_test_config.py`
- **计算缓存**: FIFO 队列，大小限制 500
- **时间公式**: `time = N_jobs * M_stages * factor`，factor 默认 0.05（单）/ 0.1（批量）
- **并行**: `ProcessPoolExecutor`，大规模 W=2，小规模 W=4
- **断点续跑**: batch 脚本检测 `round{r}/` 目录非空则跳过

## 代码质量红线（严禁打补丁 + 严禁兼容层）

### §8.1 严禁打补丁
- 遇到 bug 必须分析根因并修复设计/逻辑本身
- 禁止用法：特殊值特判、`except: pass`、`pytest.skip`、注释掉失败代码、临时 workaround
- 禁止注释关键字：临时/暂时/绕过/待重构/先这样/TODO 后修

### §8.2 严禁兼容层
- **接口/格式变更必须一次性迁移全部调用点**，禁止保留旧接口
- 禁止用法：
  - 旧名 shim：`def old(): return new()`
  - `DeprecationWarning` 包装
  - 旧参数/新参数并存
  - 双格式/版本判断分支
  - 模块 alias（`OldClass = NewClass`）
  - 旧路径 fallback
- 禁止注释关键字：兼容/legacy/deprecated/保留旧接口/过渡期/两版本共存

### 遇到问题时的流程
5-Why 根因分析 → 修复根因 → 同步调用方（若接口变了，全项目一次性替换）→ 添加回归测试 → 记录到 `docs/root_cause_fix_log.md`

### 允许的例外
- 上游库 bug：`# UPSTREAM BUG: <link>`
- 数值稳定性护栏（< 1e-6）
- 明确不支持：`raise NotImplementedError(...)`
- **不再允许 "backward-compat" 例外**

详见 SKILL.md §8

## 输出策略
- 所有实验输出在 `outputs/` 内
- 生成 zip 前必须运行 `PROJECT_AUDIT.md` 审计
- 交付时必须给出审计摘要（测试、占位、可运行算法、旧版目录）

## 算法适配与批量一致性
- **算法适配 — 初始化按用途分类**：
  - 单解生成器 → `src/metaheuristics/initial/single/`（返回 `list[int]`，供 SA/IG/TS 用）
  - 种群生成器 → `src/metaheuristics/initial/population/`（返回 `list[list[int]]`，供 GA/MA 用）
  - **严禁混用**：单解生成器直接用于种群会导致个体相同，种群丧失多样性
- **批量对比默认统一**：`sh_batch_instances_algorithms.sh` 默认 `--unified-init y --unified-cache y`
- 交互式提示：脚本启动时询问是否使用统一初始化和统一缓存
- 命令行开关：`--unified-init [y|n] --unified-cache [y|n] --init-method-single NAME --init-method-pop NAME`
- 非默认设置需在 `configs/conventions.md` 记录理由

## 约定持久化
- **所有对话中产生的自然语言约定必须写入项目文件**，不得停留在对话上下文
- 用户澄清与建模决策：`docs/YYYY-M-D_*.md`
- 用户交互约定（求解器偏好、输出格式、命名调整等）：`configs/conventions.md`
- 问题特征结构化：`configs/problem_fingerprint.json` + `configs/problem_statement.md`
- 每次新约定 → 立即写入；生成结束前 → 汇总检查
- 详见 `modules/quality.md` §3

## 维护规则
- 新增约定时同步更新本文件
- 删除过时条目
- 更新 `IMPLEMENTATION_STATUS.md` 记录模块状态变更

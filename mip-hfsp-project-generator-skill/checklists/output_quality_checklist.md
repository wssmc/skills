# 输出质量检查清单

## 架构边界

- [ ] `cpp/` 是唯一的 solver、decoder、checker、objective、EvalCache 和 registry 实现
- [ ] `python/` 只包含算例生成、结果分析、统计和可视化
- [ ] Python 没有第二套算法或 makespan 计算
- [ ] 根目录 `AGENTS.md` 已先读取，并写明语言边界、CMake 命令、输出和质量红线

## 数据与 MIP

- [ ] 主体数据为 txt，`index.json` 只做索引并记录 instance seed
- [ ] Python 生成数据，C++ loader 读取同一格式
- [ ] MIP 使用 Gurobi C++ API；缺少环境时标 `NOT_RUN`
- [ ] 结果包含 status、objective、LB、gap、runtime（不可用值为 JSON null）

## C++ 解码、评估与算法

- [ ] Instance、Schedule、Result、Operation 在 `cpp/include/hfsp/core/` 定义
- [ ] Stage precedence、machine no-overlap、加工时长和目标由 C++ checker 校核
- [ ] 资源键包含 `(stage_id, machine_id)`
- [ ] 每个算法通过独立 `EvalCache(500)`，FIFO，键含实例/序列/机器分配
- [ ] SA/MA/IG/GA/TS 与 baseline 通过 C++ registry 注册，状态与注册键一致
- [ ] `best_sequence` 由 solver 直接保存，能够重放同一 objective
- [ ] 单解初始化与种群初始化在 C++ 类型和组件上严格分离
- [ ] 论文算法适配记录来源、差异、初始化、邻域、参数和消融

## 构建、测试与输出

- [ ] `cmake -S . -B build` 配置成功
- [ ] `cmake --build build` 编译成功
- [ ] `ctest --test-dir build --output-on-failure` 通过
- [ ] `scripts/audit_project.py` 真实运行并更新 `PROJECT_AUDIT.md`
- [ ] 输出四件套：`result.json` / `schedule.csv` / `trace.csv` / `best_seq.json`
- [ ] 所有输出仅在 `outputs/`，路径穿越被拒绝
- [ ] Python 分析脚本能读取结果并对缺失/非法输入返回非零状态

## 文档与红线

- [ ] `IMPLEMENTATION_STATUS.md` 初始为 `not_verified`，未运行项不写 PASS
- [ ] `PROJECT_AUDIT.md` 初始为 `Overall: NOT_RUN`
- [ ] 用户约定持久化到 `AGENTS.md`、`configs/conventions.md` 或 `docs/`
- [ ] 无特殊值补丁、静默异常、跳过失败测试、旧接口 shim、旧路径 fallback 或双格式迁移层
- [ ] 未实现功能显式抛错，不返回伪结果
- [ ] `README.md` 包含 CMake、C++ runner 和 Python 分析命令

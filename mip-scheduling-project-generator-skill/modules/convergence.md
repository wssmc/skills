# 模块：CPU 收敛曲线与实验目录

生成项目时把完整协议写入 `docs/convergence_protocol.md`，并在项目 `AGENTS.md` 保留不可违背的摘要。

## 目录契约

- 烟测、调试、临时表和待审阅图片统一进入 `outputs/tmp/`。
- 正式测试脚本的稳定 ID 是脚本文件名；`scripts/.../{test_id}.sh` 对应 `outputs/formal/{test_id}/`。
- 参数改变的重测在目录名追加排序后的 `key-value` 标签；配置未变则从 `_1`、`_2` 递增。任何情况都不得覆盖旧结果。
- 正式目录必须记录脚本路径/版本、有效参数、实例与求解 seeds。底层 runner 未由正式脚本指定目录时只能写 `outputs/tmp/unclassified/`。

## 收敛契约

- 使用包含初始化的进程 CPU budget；固定初始化边界并记录 `T_init,E_init,C_init`。
- 初始化后只有一个跨阶段全局精英事件流：`INIT`、严格改善的 `IMPROVE`、`END`。
- 原始字段固定为 `event,cpu_search_s,cpu_total_s,evaluations,best_cmax,source`，内存采集后一次落盘。
- 每个 seed 的一次完整运行离线采样 100 个归一化时间点：50 点覆盖 `[0,0.2]`，50 点覆盖 `(0.2,1]`；使用前向保持，不插值。
- 用右连续阶梯图，检查点数、单调性和首末值；临时审阅位于 `outputs/tmp/convergence/`，正式结论依赖多 seed 统计。

具体公式和论文解释边界见生成模板 `code_templates/docs/convergence_protocol.md.tpl`。

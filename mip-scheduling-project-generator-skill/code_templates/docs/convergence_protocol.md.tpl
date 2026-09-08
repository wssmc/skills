# CPU 截止收敛曲线协议

## 1. 预算与初始化

- 单次运行使用项目正式进程 CPU budget，且预算包含初始化；Nest-Lot 项目未另行规定时可用 `T_lim=factor*J*M` 秒，其他问题不得套用该公式。
- 同一运行只使用一个进程 CPU 计时器。初始化边界必须在算法设计中预先定义，只包含明确的构造、多启动或种群建立，不得临时纳入主循环、局部搜索或搜索阶段。
- 原始元数据记录 `T_init`、`E_init`、`C_init`。令 `T_search=max(T_lim-T_init,0)`，初始化结束为 `t_search=0`，归一化横轴为 `x=t_search/T_search`。若 `T_search=0`，输出 `C_init` 水平线并标记 `initialization_exhausted_budget`。

## 2. 全局精英事件

- 每个算法只有一个权威全局精英；阶段、重启、温度或表示空间变化均不得重置。来源标签可审计，但完整可行解统一参与同一目标语义下的比较。
- 初始化结束写 `INIT`；仅当全局 `best_cmax` 严格下降时立即写 `IMPROVE`。当前解、劣解、局部/部分解和辅助解码不写入。
- 固定字段：`event,cpu_search_s,cpu_total_s,evaluations,best_cmax,source`。事件先存内存，运行结束后一次落盘。
- 结束写 `END`，并强制检查最后精英目标、算法返回 Cmax 和对应完整可行解一致；不一致即失败，不得由采样脚本修补。

## 3. 离线采样

- 一次完整运行只产生一条曲线；禁止为每个采样点重新运行。原始事件只读，不修改、不补造目标值、不插值。
- 每个 seed 独立采样后再跨 seed 汇总。默认 100 点：
  - `k=0,...,49`：`x_k=0.2*k/49`；
  - `r=0,...,49`：`x_(50+r)=0.2+0.8*(r+1)/50`。
- 每个 `x` 取 `x*T_search` 之前最后一个全局精英并前向保持。同一 CPU 时间戳的事件按 evaluations 排序并取该时刻最小值。
- 多 seed 在相同采样点计算均值、中位数或区间；不得先混合事件或选择有利 seed。

## 4. 绘图、校验和结论

- 使用右连续阶梯图，例如 `step(...,where="post")`；横轴 `Normalized time`、范围 `[0,1]`，纵轴统一使用 `Objective value` 或 `Makespan`，同面板内共享尺度。
- 每条曲线必须恰好 100 点、前 20% 恰好 50 点、目标单调不增、首点等于 `C_init`、末点等于返回 Cmax。
- 新事件、采样表和图片先写 `outputs/tmp/convergence/`；检查完成后才复制到与正式脚本对应的 `outputs/formal/...`。
- 论文总体结论以正式多 seed 的 ARPD、排名和配对检验为准；单条曲线只称为 illustrative/representative profile，不据此声称总体或所有面板最优。

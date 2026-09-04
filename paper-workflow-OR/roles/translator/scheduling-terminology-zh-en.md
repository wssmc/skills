# Chinese–English Scheduling Terminology Glossary

> Source date: 2026-06-29
>
> This glossary is derived from the user-supplied scheduling terminology reference. It is intended for Chinese↔English translation, drafting, polishing, and terminology-consistency review in scheduling and operations-research manuscripts. The tables preserve the recommended Chinese term, English term, and common abbreviation/symbol. Project-specific terminology supplied by the user takes priority over this general glossary.

## Usage Rules

1. On first occurrence in Chinese academic writing, prefer `Chinese term (English term, abbreviation)` when useful; later use the established abbreviation consistently.
2. Keep problem names, algorithm names, and objective/metric names distinct. For example, HFSP is a problem class, SA/IG/GA are algorithms, and Cmax/TWT are objectives or metrics.
3. Do not conflate encoding, decoding, schedule, and objective value. An encoding represents search decisions; a decoder constructs a feasible schedule; the schedule is evaluated for constraints and objectives.
4. In manufacturing scheduling, translate `routing` as 工艺路线 or 加工路线 rather than the networking sense of “routing”.
5. Translate `release date/time` as 释放时间 / 可开工时间 / 到达时间, not 发布日期.
6. Distinguish `due date` (交期, tardiness may be allowed) from `deadline` (截止期, usually hard or strongly penalized).
7. Translate `makespan` as 最大完工时间 or 总工期; for an objective, “minimize the makespan” corresponds to 最小化最大完工时间.
8. Translate `setup time` according to the application: 准备时间, 换模时间, or 换型时间.
9. Translate `eligibility` as 机器资格 / 机器可加工性 in machine-eligibility settings.
10. Keep NEST and LOT uppercase as domain object names when they are defined as such in the manuscript.

## 1. Basic Objects, Time Variables, and Common Symbols

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 工件 / 作业 | job | job, J_j |
| 工序 / 操作 | operation | operation, O_{ij} |
| 任务 | task | task |
| 机器 | machine | M_i |
| 阶段 | stage | stage, k |
| 工位 / 工作中心 | work center | WC |
| 资源 | resource | resource |
| 订单 | order | order |
| 批次 | batch / lot | batch, lot |
| 调度方案 | schedule | S |
| 序列 | sequence | π |
| 排列 | permutation | perm |
| 派工 | dispatching | dispatch |
| 排序 / 定序 | sequencing | sequencing |
| 机器分配 | machine assignment / allocation | MA |
| 工艺路线 | routing / route | route |
| 加工时间 | processing time | p_j, p_{ij}, p_{jk} |
| 准备时间 / 换模时间 | setup time / changeover time | s_{ij}, setup |
| 序列相关换模时间 | sequence-dependent setup time | SDST, s_{ij} |
| 开始时间 | start time | S_j, s_{ij} |
| 完工时间 | completion time | C_j |
| 释放时间 / 可开工时间 | release date / release time | r_j |
| 交期 | due date | d_j |
| 截止期 | deadline | \bar d_j |
| 迟期 / 延迟时间 | tardiness | T_j=max(C_j-d_j,0) |
| 提前量 | earliness | E_j=max(d_j-C_j,0) |
| 偏差 | deviation |  |
| 滞后量 / 迟交量 | lateness | L_j=C_j-d_j |
| 流经时间 / 流动时间 | flow time | F_j=C_j-r_j |
| 等待时间 | waiting time | W_j |
| 空闲时间 | idle time | idle |
| 最大完工时间 / 总工期 | makespan | C_max |
| 甘特图 | Gantt chart | Gantt |
| 可行调度 | feasible schedule | feasible |
| 不可行解 | infeasible solution | infeasible |
| 活动调度 | active schedule | active |
| 半活动调度 | semi-active schedule | semi-active |
| 非延迟调度 | non-delay schedule | non-delay |
| 左移 / 紧排 | left shift | left-shift |
| 关键路径 | critical path | CP |
| 关键块 | critical block | CB |
| 瓶颈机器 / 瓶颈阶段 | bottleneck machine / stage | bottleneck |
| 在制品 | work-in-process | WIP |
| 加工族 / 工件族 | job family | family |
| 兼容性 | compatibility | compat. |
| 批容量 | batch capacity | b, cap |
| 工件尺寸需求 | capacity requirement / size | a_j, size |

## 2. Scheduling Problem Classes and Shop Environments

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 三字段表示法 | three-field notation | α\|β\|γ |
| 单机调度 | single-machine scheduling | 1\|β\|γ |
| 并行机调度 | parallel machine scheduling | P/Q/R |
| 相同并行机 | identical parallel machines | P_m |
| 均匀并行机 | uniform parallel machines | Q_m |
| 不相关并行机 | unrelated parallel machines | R_m |
| 流水车间调度 | flow shop scheduling problem | FSP, F_m |
| 置换流水车间 | permutation flow shop scheduling problem | PFSP |
| 非置换流水车间 | non-permutation flow shop | NPFSP |
| 混合流水车间 | hybrid flow shop | HFS, HFSP |
| 柔性流水车间 | flexible flow shop | FFS, FFSP |
| 作业车间调度 | job shop scheduling problem | JSP, JSSP |
| 柔性作业车间 | flexible job shop scheduling problem | FJSP, FJSSP |
| 开放车间调度 | open shop scheduling problem | OSP |
| 分布式车间调度 | distributed shop scheduling | DFSP/DFJSP/DHFSP |
| 双资源约束调度 | dual-resource constrained scheduling | DRC |
| 人机协同调度 | human-machine collaborative scheduling | HMC |
| 可重入调度 | re-entrant scheduling | re-entry, rcrc |
| 缺失操作调度 | scheduling with missing operations | MO, missing operation |
| 工序跳过 | operation skipping / stage skipping | skip |
| 阻塞流水车间 | blocking flow shop | blocking |
| 无等待流水车间 | no-wait flow shop | no-wait |
| 无空闲流水车间 | no-idle flow shop | no-idle |
| 批处理机调度 | batch processing machine scheduling | BPM |
| 串行批调度 | serial-batch scheduling | serial batching |
| 并行批调度 | parallel-batch scheduling | parallel batching |
| 装配调度 | assembly scheduling | assembly |
| 两阶段调度 | two-stage scheduling | two-stage |
| 交叉转运调度 | cross-docking scheduling | cross-docking |
| 动态调度 | dynamic scheduling | dynamic |
| 重调度 | rescheduling | rescheduling |
| 反应式调度 | reactive scheduling | reactive |
| 滚动时域调度 | rolling-horizon scheduling | RH |
| 鲁棒调度 | robust scheduling | robust |
| 随机调度 | stochastic scheduling | stochastic |
| 在线调度 | online scheduling | online |
| 离线调度 | offline scheduling | offline |
| 多目标调度 | multi-objective scheduling | MOSP |
| 绿色调度 | green scheduling | green |

## 3. Constraints, Operational Factors, and Realistic Extensions

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 前序约束 | precedence constraint | prec |
| 工艺顺序约束 | technological precedence | tech. prec. |
| 跨订单前序约束 | inter-job precedence | inter-job prec. |
| 有向无环图 | directed acyclic graph | DAG |
| 拓扑排序 | topological ordering | topo order |
| 拓扑修复 | topological repair | topo repair |
| 机器容量约束 | machine capacity constraint | capacity |
| 资源容量约束 | resource capacity constraint | resource cap. |
| 机器资格约束 | machine eligibility constraint | eligibility |
| 专用机约束 | dedicated machine constraint | dedicated |
| 受限机器集合 | eligible machine set | E_{ij} |
| 人员技能矩阵 | skill matrix | skill matrix |
| 设备日历 | machine calendar | calendar |
| 机器不可用期 | machine unavailability | unavailable |
| 预防性维护 | preventive maintenance | PM |
| 机器故障 | machine breakdown | breakdown |
| 搬运时间 | transportation time | transport |
| 搬运资源 | transportation resource | AGV/crane/operator |
| 缓冲区容量 | buffer capacity | buffer |
| 有限缓冲 | finite buffer | finite buffer |
| 无缓冲 | no buffer | no-buffer |
| 抢占 | preemption | pmtn |
| 非抢占 | non-preemption | non-pmtn |
| 批量约束 | batching constraint | batching |
| 不兼容工件族 | incompatible job families | incompatible families |
| 族相关换模 | family-dependent setup | family setup |
| 材质约束 | material constraint | material |
| 厚度约束 | thickness constraint | thickness |
| 模具约束 | tooling constraint | tooling |
| 能源约束 | energy constraint | energy |
| 交期窗口 | due window | DW |
| 时间窗 | time window | TW |
| 插单 | rush order insertion / new job arrival | insertion |
| 冻结区间 | frozen horizon | frozen |
| 已开工操作固定 | operation fixing | fixing |
| 方案稳定性 | schedule stability | stability |
| 右移修复 | right-shift repair | right shift |
| 局部重调度 | partial rescheduling | partial |
| 全局重调度 | complete rescheduling | complete |

## 4. Objectives and Performance Metrics

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 最大完工时间 | makespan | C_max |
| 总完工时间 | total completion time | ΣC_j |
| 加权总完工时间 | total weighted completion time | Σw_jC_j |
| 平均流经时间 | mean flow time | mean F_j |
| 总迟期 | total tardiness | ΣT_j |
| 加权总迟期 | total weighted tardiness | TWT, Σw_jT_j |
| 最大迟期 | maximum tardiness | T_max |
| 最大滞后 | maximum lateness | L_max |
| 总提前/迟期 | total earliness and tardiness | Σ(E_j+T_j) |
| 加权提前/迟期 | weighted earliness/tardiness | WET |
| 准时交付率 | on-time delivery rate | OTD |
| 吞吐量 | throughput | throughput |
| 机器利用率 | machine utilization | utilization |
| 负载均衡 | workload balance | balance |
| 总空闲时间 | total idle time | idle |
| 总换模时间 | total setup time | setup |
| 总搬运时间 | total transportation time | transport |
| 总能耗 | total energy consumption | TEC |
| 峰值功率 | peak power | peak |
| 碳排放 | carbon emission | CO2 |
| 成本 | cost | cost |
| 服务水平 | service level | service level |
| 多目标帕累托最优 | Pareto optimality | Pareto |
| 非支配解 | non-dominated solution | NDS |
| 帕累托前沿 | Pareto front | PF |
| 加权和法 | weighted-sum method | WS |
| ε-约束法 | epsilon-constraint method | ε-constraint |
| 超体积 | hypervolume | HV |
| 反世代距离 | inverted generational distance | IGD |
| 间距指标 | spacing metric | spacing |

## 5. Mathematical Modeling and Exact Methods

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 精确方法 | exact method / exact algorithm | exact |
| 数学规划 | mathematical programming | MP |
| 线性规划 | linear programming | LP |
| 整数规划 | integer programming | IP |
| 混合整数规划 | mixed-integer programming | MIP |
| 混合整数线性规划 | mixed-integer linear programming | MILP |
| 混合整数非线性规划 | mixed-integer nonlinear programming | MINLP |
| 约束规划 | constraint programming | CP |
| CP-SAT | CP-SAT solver | CP-SAT |
| 区间变量 | interval variable | interval |
| 不重叠约束 | no-overlap constraint | NoOverlap |
| 累积资源约束 | cumulative constraint | Cumulative |
| 析取图模型 | disjunctive graph model | DG |
| 大 M 约束 | big-M constraint | Big-M |
| 位置变量模型 | position-based formulation | position-based |
| 时间索引模型 | time-indexed formulation | time-indexed |
| 事件点模型 | event-based formulation | event-based |
| 前后关系变量 | precedence variable | x_{ij} |
| 机器选择变量 | assignment variable | y_{ijm} |
| 目标值变量 | objective variable | z |
| 分支定界 | branch and bound | B&B |
| 分支割平面 | branch and cut | B&C |
| 割平面 | cutting plane / cut | cut |
| 列生成 | column generation | CG |
| 分支定价 | branch and price | B&P |
| Benders 分解 | Benders decomposition | BD |
| 拉格朗日松弛 | Lagrangian relaxation | LR |
| 动态规划 | dynamic programming | DP |
| 分支规则 | branching rule | branching |
| 节点选择 | node selection | node selection |
| 剪枝 | pruning | prune |
| 松弛问题 | relaxation | relaxation |
| 下界 | lower bound | LB |
| 上界 | upper bound | UB |
| 当前最优解 | incumbent | incumbent |
| 最优性差距 | optimality gap | gap |
| 可行性泵 | feasibility pump | FP |
| 热启动 | warm start | warm start |
| 对称破除 | symmetry breaking | symmetry breaking |
| 有效不等式 | valid inequality | valid cut |
| 商业求解器 | commercial solver | CPLEX/Gurobi/Xpress |
| 开源求解器 | open-source solver | CBC/SCIP/OR-Tools |

## 6. Constructive Heuristics and Dispatching Rules

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 启发式方法 | heuristic method | heuristic |
| 构造启发式 | constructive heuristic | constructive |
| 贪婪算法 | greedy algorithm | greedy |
| 派工规则 | dispatching rule | DR |
| 优先规则 | priority rule | PR |
| 列表调度 | list scheduling | list scheduling |
| 最短加工时间 | shortest processing time | SPT |
| 最长加工时间 | longest processing time | LPT |
| 最早交期 | earliest due date | EDD |
| 最小松弛时间 | minimum slack time | MST |
| 加权最短加工时间 | weighted shortest processing time | WSPT |
| 关键比率 | critical ratio | CR |
| 先到先服务 | first come first served | FCFS/FIFO |
| 后到先服务 | last come first served | LCFS/LIFO |
| 随机派工 | random dispatching | RANDOM |
| ATC 规则 | apparent tardiness cost | ATC |
| ATCS 规则 | apparent tardiness cost with setups | ATCS |
| BATCS 规则 | batch apparent tardiness cost with setups | BATCS |
| NEH 启发式 | Nawaz-Enscore-Ham heuristic | NEH |
| CDS 算法 | Campbell-Dudek-Smith algorithm | CDS |
| Palmer 斜率指数法 | Palmer slope index | Palmer |
| 插入启发式 | insertion heuristic | insertion |
| 局部改进 | local improvement | local improve |
| 多起点启发式 | multi-start heuristic | multi-start |
| 束搜索 | beam search | BS |
| 滚动优化 | rolling optimization | rolling |
| 分解启发式 | decomposition heuristic | decomposition |
| 修复启发式 | repair heuristic | repair |
| 惩罚函数 | penalty function | penalty |

## 7. Local Search, Neighborhoods, and Acceptance Criteria

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 局部搜索 | local search | LS |
| 邻域 | neighborhood | N(S) |
| 移动 / 操作 | move / operator | move |
| 交换邻域 | swap neighborhood | swap |
| 相邻交换 | adjacent swap | adj-swap |
| 插入邻域 | insertion neighborhood | insert |
| 逆序邻域 | inversion / 2-opt | invert |
| 块移动 | block move | block |
| 重定位 | relocation | relocate |
| 破坏-修复 | destroy and repair | D&R |
| 破坏-重构 | ruin and recreate | R&R |
| 扰动 | perturbation | perturb |
| 首个改进 | first improvement | FI |
| 最优改进 | best improvement | BI |
| 最陡下降 | steepest descent | SD |
| 局部最优 | local optimum | local opt. |
| 全局最优 | global optimum | global opt. |
| 变邻域下降 | variable neighborhood descent | VND |
| 变邻域搜索 | variable neighborhood search | VNS |
| 引导局部搜索 | guided local search | GLS |
| 接受准则 | acceptance criterion | accept rule |
| Metropolis 准则 | Metropolis criterion | exp(-Δ/T) |
| 禁忌表 | tabu list | tabu list |
| 禁忌搜索 | tabu search | TS |
| 特赦准则 | aspiration criterion | aspiration |
| 重启 | restart | restart |
| 再升温 | reheating | reheating |
| 冷却 | cooling | cooling |
| 探索 | exploration | exploration |
| 开采 / 利用 | exploitation | exploitation |
| 候选池 | candidate pool | pool |
| 精英解 | elite solution | elite |
| 解档案 | archive | archive |
| 缓存评价 | cached evaluation | cache |
| 增量评价 | incremental evaluation | incremental |

## 8. Metaheuristics and Intelligent Optimization Algorithms

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 元启发式 | metaheuristic | MH |
| 模拟退火 | simulated annealing | SA |
| 禁忌搜索 | tabu search | TS |
| 遗传算法 | genetic algorithm | GA |
| 进化算法 | evolutionary algorithm | EA |
| 差分进化 | differential evolution | DE |
| 模因算法 | memetic algorithm | MA |
| 迭代贪婪算法 | iterated greedy | IG |
| 迭代局部搜索 | iterated local search | ILS |
| 变邻域搜索 | variable neighborhood search | VNS |
| 自适应大邻域搜索 | adaptive large neighborhood search | ALNS |
| 蚁群优化 | ant colony optimization | ACO |
| 粒子群优化 | particle swarm optimization | PSO |
| 人工蜂群算法 | artificial bee colony | ABC |
| 离散人工蜂群 | discrete artificial bee colony | DABC |
| 灰狼优化 | grey wolf optimizer | GWO |
| 蛙跳算法 | shuffled frog leaping algorithm | SFLA |
| 布谷鸟搜索 | cuckoo search | CS |
| 鲸鱼优化 | whale optimization algorithm | WOA |
| 灯蛾扑火优化 | moth-flame optimization | MFO |
| 散点搜索 | scatter search | SS |
| GRASP | greedy randomized adaptive search procedure | GRASP |
| 多目标进化算法 | multi-objective evolutionary algorithm | MOEA |
| NSGA-II | non-dominated sorting genetic algorithm II | NSGA-II |
| MOEA/D | multi-objective EA based on decomposition | MOEA/D |
| SPEA2 | strength Pareto evolutionary algorithm 2 | SPEA2 |
| 混合算法 | hybrid algorithm | hybrid |
| 数学启发式 | matheuristic | matheuristic |
| 求解器辅助启发式 | solver-assisted heuristic | solver-assisted |
| 解码启发式 | decoding heuristic | decoder rule |

## 9. Hyper-Heuristics, Automatic Configuration, and Automated Algorithm Design

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 超启发式 | hyper-heuristic | HH |
| 低层启发式 | low-level heuristic | LLH |
| 启发式选择 | heuristic selection | selection HH |
| 启发式生成 | heuristic generation | generation HH |
| 选择机制 | selection mechanism | SM |
| 移动接受机制 | move acceptance | MA |
| 选择式超启发式 | selection hyper-heuristic | SHH |
| 生成式超启发式 | generation hyper-heuristic | GHH |
| 在线学习 | online learning | online |
| 离线学习 | offline learning | offline |
| 自适应算子选择 | adaptive operator selection | AOS |
| 自适应参数控制 | adaptive parameter control | APC |
| 参数调优 | parameter tuning | tuning |
| 参数控制 | parameter control | control |
| 算法选择 | algorithm selection | AS |
| 算法配置 | algorithm configuration | AC |
| 自动算法设计 | automated algorithm design | AAD / AD |
| 自动机器学习 | automated machine learning | AutoML |
| F-Race | F-Race | F-Race |
| irace | iterated racing | irace |
| SMAC | sequential model-based algorithm configuration | SMAC |
| ParamILS | parameter iterative local search | ParamILS |
| 运行时特征 | runtime features | runtime feat. |
| 实例特征 | instance features | inst. feat. |
| 适应度景观 | fitness landscape | landscape |
| 探索-利用权衡 | exploration-exploitation trade-off | E/E |

## 10. Machine-Learning-Assisted Scheduling

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 机器学习辅助调度 | machine-learning-assisted scheduling | ML-assisted |
| 监督学习 | supervised learning | SL |
| 无监督学习 | unsupervised learning | UL |
| 半监督学习 | semi-supervised learning | SSL |
| 回归 | regression | reg. |
| 分类 | classification | cls. |
| 排名学习 | learning to rank | LTR |
| 特征工程 | feature engineering | FE |
| 目标值预测 | objective value prediction | OVP |
| 参数预测 | parameter prediction | param pred. |
| 方法选择 | method selection | method selection |
| 规则选择 | dispatching rule selection | rule selection |
| 性能预测 | performance prediction | perf. pred. |
| 代理模型 | surrogate model | surrogate |
| 学习增强优化 | learning-augmented optimization | LAO |
| 神经组合优化 | neural combinatorial optimization | NCO |
| 图表示 | graph representation | graph repr. |
| 图神经网络 | graph neural network | GNN |
| 注意力机制 | attention mechanism | attention |
| 编码器-解码器 | encoder-decoder | Enc-Dec |
| 指针网络 | pointer network | Ptr-Net |
| Transformer | transformer | Transformer |
| 模仿学习 | imitation learning | IL |
| 行为克隆 | behavior cloning | BC |
| 迁移学习 | transfer learning | transfer |
| 课程学习 | curriculum learning | curriculum |
| 泛化 | generalization | gen. |
| 分布外泛化 | out-of-distribution generalization | OOD |
| 消融学习模型 | ablated learning model | ablation |
| 数据管线 | data pipeline | pipeline |
| 标签 | label | label |
| 训练集 | training set | train |
| 验证集 | validation set | valid |
| 测试集 | test set | test |

## 11. Reinforcement Learning and Deep Reinforcement Learning for Scheduling

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 强化学习 | reinforcement learning | RL |
| 深度强化学习 | deep reinforcement learning | DRL |
| 马尔可夫决策过程 | Markov decision process | MDP |
| 智能体 | agent | agent |
| 环境 | environment | env |
| 状态 | state | s_t |
| 动作 | action | a_t |
| 动作空间 | action space | A |
| 动作掩码 | action mask | mask |
| 奖励 | reward | r_t |
| 奖励塑形 | reward shaping | shaping |
| 终端奖励 | terminal reward | terminal |
| 稀疏奖励 | sparse reward | sparse |
| 策略 | policy | π(a\|s) |
| 价值函数 | value function | V(s), Q(s,a) |
| Q 学习 | Q-learning | QL |
| 深度 Q 网络 | deep Q-network | DQN |
| 策略梯度 | policy gradient | PG |
| REINFORCE | REINFORCE | REINFORCE |
| Actor-Critic | actor-critic | AC |
| 近端策略优化 | proximal policy optimization | PPO |
| A2C/A3C | advantage actor-critic | A2C/A3C |
| 软演员评论家 | soft actor-critic | SAC |
| 优势函数 | advantage function | A(s,a) |
| 熵正则 | entropy regularization | entropy |
| 轨迹 | trajectory | τ |
| 回合 | episode | episode |
| rollout | rollout | rollout |
| 折扣因子 | discount factor | γ |
| 派工规则作为动作 | dispatching-rule action | DR-action |
| 工序选择动作 | operation-selection action | op-action |
| 机器选择动作 | machine-selection action | machine-action |
| 联合动作 | joint action | joint |
| 分层强化学习 | hierarchical RL | HRL |
| 多智能体强化学习 | multi-agent RL | MARL |
| 图策略网络 | graph policy network | GPN |
| 离散事件仿真 | discrete event simulation | DES |
| 仿真优化 | simulation optimization | sim-opt |

## 12. LLM, Agent, and LLM4AD Terminology

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 大语言模型 | large language model | LLM |
| LLM 辅助算法设计 | LLM for algorithm design | LLM4AD |
| 自动算法设计 | algorithm design automation | AD/AAD |
| LLM 作为优化器 | LLM as optimizer | optimizer |
| LLM 作为预测器 | LLM as predictor | predictor |
| LLM 作为抽取器 | LLM as extractor | extractor |
| LLM 作为设计器 | LLM as designer | designer |
| 元优化器 | meta-optimizer | meta-optimizer |
| 提示词 | prompt | prompt |
| 系统提示词 | system prompt | system |
| 反思提示词 | reflection prompt | reflection |
| 进化提示词 | evolution prompt | evolution |
| 自我反思 | self-reflection | self-reflection |
| 反思进化 | reflective evolution | RE |
| Agent 循环 | agent loop | loop |
| 工具调用 | tool use | tool use |
| 检索增强生成 | retrieval-augmented generation | RAG |
| 记忆 | memory | memory |
| 精英档案 | elite archive | elite archive |
| 候选算法 | candidate algorithm | candidate |
| 算子变异 | operator mutation | mutation |
| 代码生成 | code generation | code gen. |
| 沙盒评估 | sandbox evaluation | sandbox |
| 单元测试 | unit test | test |
| 事实核验 | verification | verify |
| 幻觉 | hallucination | hallucination |
| 可复现性 | reproducibility | reproducibility |
| 审计日志 | audit log | log |
| 安全评估 | safe evaluation | safe eval |
| 人在回路 | human-in-the-loop | HITL |

## 13. Encoding, Decoding, and Scheduling Implementation Terms

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 编码 | encoding | encoding |
| 解码 | decoding | decoding |
| 解码器 | decoder | decoder |
| 基因型 | genotype | genotype |
| 表型 | phenotype | phenotype |
| 染色体 | chromosome | chrom. |
| 个体 | individual | individual |
| 种群 | population | pop |
| 工件序列编码 | job-sequence encoding | JSE |
| 工序编码 | operation-based encoding | OBE |
| 机器编码 | machine-assignment encoding | MAE |
| 双串编码 | two-vector encoding | TVE |
| 三层编码 | three-layer encoding | TLE |
| 优先级编码 | priority-rule encoding | priority |
| 随机键编码 | random-key encoding | RK |
| 直接编码 | direct encoding | direct |
| 间接编码 | indirect encoding | indirect |
| 可行性检查器 | feasibility checker | checker |
| 目标评价器 | objective evaluator | evaluator |
| 调度构造器 | schedule builder | builder |
| 最早开始解码 | earliest-start decoding | ESD |
| 贪婪机器选择 | greedy machine selection | greedy MA |
| 规则驱动机器选择 | rule-driven assignment | rule-driven |
| 解码器驱动机器选择 | decoder-driven assignment | decoder-driven |
| 编码修复 | encoding repair | repair |
| 约束惩罚 | constraint penalty | penalty |
| 重复解剪枝 | duplicate pruning | duplicate |
| 哈希键 | hash key | hash |
| 评价预算 | evaluation budget | eval budget |
| 时间上限 | time limit | time limit |
| 迭代次数 | iterations | iter |
| 收敛曲线 | convergence curve | convergence |

## 14. Sheet-Metal Processing, Nesting, and NEST–LOT Terminology

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 板材加工 | sheet metal processing | sheet metal |
| 排料 / 套料 | nesting | nesting |
| 切割库存问题 | cutting stock problem | CSP |
| 二维装箱 | two-dimensional bin packing | 2D-BPP |
| 排样 / 排料图 | cutting layout / nesting pattern | pattern |
| 板材 | sheet metal / sheet | sheet |
| 展开件 / 毛坯 | unfolded blank / blank | blank |
| 零件 | part | part |
| 物料清单 | bill of materials | BOM |
| 冲压 | punching / stamping | punching/stamping |
| 激光切割 | laser cutting | laser |
| 折弯 | bending / air bending | bending |
| 焊接 | welding | welding |
| 喷涂 / 涂装 | painting / coating | painting |
| 装配 | assembling / assembly | assembly |
| 捡料 / 分拣 | picking / sorting | picking |
| 排料图订单 | nesting-pattern order | NEST |
| 后续合批批次 | downstream lot / lot batch | LOT |
| NEST→LOT 前序 | NEST-to-LOT precedence | NEST→LOT |
| 订单关系图 | order-relation graph | ORG/DAG |
| 批次释放时间 | lot release time | r_lot |
| 汇聚关系 | convergence / assembly-like relation | convergence |
| 分裂关系 | splitting relation | split |
| 多对多关系 | many-to-many relation | M:N |
| 合批 | lot merging / batching | merge |
| 拆批 | lot splitting | split lot |
| 材料利用率 | material utilization | utilization |
| 废料 | scrap / waste | scrap |
| 共边切割 | common cut | common cut |
| 切割路径 | cutting path | path |
| 换刀 / 换模 | tool change / die change | tool change |
| 工具布局 | tooling layout | layout |
| 排料-调度集成 | integrated nesting and scheduling | INSP |
| 分层决策 | hierarchical decision | hierarchy |
| 双层规划 | bilevel programming | bilevel |
| 协同优化 | collaborative optimization | collaborative |

## 15. Experiments, Benchmarks, and Statistical Testing

| Chinese term | English term | Common abbreviation / symbol |
|---|---|---|
| 算例 | instance | inst. |
| 算例生成器 | instance generator | generator |
| 基准集 | benchmark set | benchmark |
| 小规模算例 | small-scale instance | small |
| 大规模算例 | large-scale instance | large |
| 训练集 | training set | train |
| 验证集 | validation set | valid |
| 测试集 | test set | test |
| 基础算法 | baseline algorithm | baseline |
| 最优值 | optimal value | OPT |
| 最好已知解 | best-known solution | BKS |
| 下界 | lower bound | LB |
| 相对偏差 | relative percentage deviation | RPD |
| 平均相对偏差 | average relative percentage deviation | ARPD |
| 最优性差距 | optimality gap | gap |
| 平均值 | mean | mean |
| 中位数 | median | median |
| 标准差 | standard deviation | std |
| 最好值 | best | best |
| 最差值 | worst | worst |
| 运行时间 | computational time | CPU time / time |
| 固定随机种子 | fixed random seed | seed |
| 独立重复运行 | independent runs | runs |
| 统计显著性检验 | statistical significance test | test |
| Wilcoxon 符号秩检验 | Wilcoxon signed-rank test | Wilcoxon |
| Friedman 检验 | Friedman test | Friedman |
| Holm 校正 | Holm correction | Holm |
| p 值 | p-value | p |
| 置信区间 | confidence interval | CI |
| 箱线图 | boxplot | boxplot |
| 消融实验 | ablation study | ablation |
| 参数敏感性分析 | parameter sensitivity analysis | sensitivity |
| 组件分析 | component analysis | component |
| 收敛分析 | convergence analysis | convergence |
| 复杂度分析 | complexity analysis | complexity |
| 可复现包 | reproducibility package | artifact |

## 16. Common Abbreviation Quick Reference

| Abbreviation | English full name | Recommended Chinese |
|---|---|---|
| FSP | Flow Shop Scheduling Problem | 流水车间调度问题 |
| PFSP | Permutation Flow Shop Scheduling Problem | 置换流水车间调度问题 |
| NPFSP | Non-Permutation Flow Shop Scheduling Problem | 非置换流水车间调度问题 |
| HFSP / HFS | Hybrid Flow Shop Scheduling Problem | 混合流水车间调度问题 |
| FFSP / FFS | Flexible Flow Shop Scheduling Problem | 柔性流水车间调度问题 |
| JSP / JSSP | Job Shop Scheduling Problem | 作业车间调度问题 |
| FJSP / FJSSP | Flexible Job Shop Scheduling Problem | 柔性作业车间调度问题 |
| OSP | Open Shop Scheduling Problem | 开放车间调度问题 |
| DFJSP | Distributed Flexible Job Shop Scheduling Problem | 分布式柔性作业车间调度问题 |
| DHFSP | Distributed Hybrid Flow Shop Scheduling Problem | 分布式混合流水车间调度问题 |
| HFSMO / HFSP-MO | Hybrid Flow Shop with Missing Operations | 带缺失操作的混合流水车间 |
| RHFS | Re-entrant Hybrid Flow Shop | 可重入混合流水车间 |
| DRC-FJSP | Dual-Resource-Constrained Flexible Job Shop Scheduling Problem | 双资源约束柔性作业车间调度问题 |
| MILP | Mixed-Integer Linear Programming | 混合整数线性规划 |
| MIP | Mixed-Integer Programming | 混合整数规划 |
| CP | Constraint Programming | 约束规划 |
| CP-SAT | Constraint Programming-SAT Solver | CP-SAT 求解器 |
| B&B | Branch and Bound | 分支定界 |
| B&C | Branch and Cut | 分支割平面 |
| LB / UB | Lower Bound / Upper Bound | 下界 / 上界 |
| OPT | Optimal Value | 最优值 |
| BKS | Best-Known Solution | 最好已知解 |
| Cmax | Makespan | 最大完工时间 |
| TT | Total Tardiness | 总迟期 |
| TWT | Total Weighted Tardiness | 加权总迟期 |
| TEC | Total Energy Consumption | 总能耗 |
| GA | Genetic Algorithm | 遗传算法 |
| SA | Simulated Annealing | 模拟退火 |
| TS | Tabu Search | 禁忌搜索 |
| IG | Iterated Greedy | 迭代贪婪 |
| ILS | Iterated Local Search | 迭代局部搜索 |
| VNS | Variable Neighborhood Search | 变邻域搜索 |
| VND | Variable Neighborhood Descent | 变邻域下降 |
| ALNS | Adaptive Large Neighborhood Search | 自适应大邻域搜索 |
| ACO | Ant Colony Optimization | 蚁群优化 |
| PSO | Particle Swarm Optimization | 粒子群优化 |
| ABC | Artificial Bee Colony | 人工蜂群算法 |
| DABC | Discrete Artificial Bee Colony | 离散人工蜂群算法 |
| GWO | Grey Wolf Optimizer | 灰狼优化算法 |
| MA | Memetic Algorithm | 模因算法 |
| MOEA | Multi-Objective Evolutionary Algorithm | 多目标进化算法 |
| NSGA-II | Non-dominated Sorting Genetic Algorithm II | 非支配排序遗传算法 II |
| MOEA/D | Multi-Objective Evolutionary Algorithm Based on Decomposition | 基于分解的多目标进化算法 |
| HH | Hyper-Heuristic | 超启发式 |
| LLH | Low-Level Heuristic | 低层启发式 |
| AOS | Adaptive Operator Selection | 自适应算子选择 |
| ML | Machine Learning | 机器学习 |
| RL | Reinforcement Learning | 强化学习 |
| DRL | Deep Reinforcement Learning | 深度强化学习 |
| GNN | Graph Neural Network | 图神经网络 |
| NCO | Neural Combinatorial Optimization | 神经组合优化 |
| MDP | Markov Decision Process | 马尔可夫决策过程 |
| DQN | Deep Q-Network | 深度 Q 网络 |
| PPO | Proximal Policy Optimization | 近端策略优化 |
| LLM | Large Language Model | 大语言模型 |
| LLM4AD | Large Language Model for Algorithm Design | 大语言模型辅助算法设计 |
| RAG | Retrieval-Augmented Generation | 检索增强生成 |
| DES | Discrete Event Simulation | 离散事件仿真 |
| BOM | Bill of Materials | 物料清单 |
| NEST | Nesting-pattern order | 排料图订单 |
| LOT | Lot batch / downstream lot | 后续合批批次 |
| SDST | Sequence-Dependent Setup Time | 序列相关换模时间 |
| AGV | Automated Guided Vehicle | 自动导引车 |
| ARPD | Average Relative Percentage Deviation | 平均相对百分偏差 |
| RPD | Relative Percentage Deviation | 相对百分偏差 |
| HV | Hypervolume | 超体积 |
| IGD | Inverted Generational Distance | 反世代距离 |

## Common Distinctions

- **job / order / part / lot**: `job` is the modeled scheduling entity; `order` is a business order; `part` is a physical component; `lot` is a production/batching unit. The manuscript should define the mapping explicitly.
- **operation / stage**: an operation is a specific processing activity; a stage is a position in a flow-shop routing and may contain parallel machines.
- **routing / sequence**: routing defines which machines/stages a job must visit; sequence defines processing order among jobs/operations.
- **due date / deadline**: due date usually allows tardiness; deadline is usually hard or strongly penalized.
- **lateness / tardiness**: lateness may be negative; tardiness is the positive part only.
- **machine eligibility / missing operation**: eligibility specifies which machines may process an existing operation; missing operation means the job does not require that stage/operation.
- **encoding / schedule**: encoding is the algorithmic representation; a schedule contains resource assignments and timing decisions.
- **objective / metric**: an objective is optimized by the solver; a metric is reported for evaluation. They may overlap but should not be conflated.

## Maintenance Rule

Use this as the general translator glossary. Add project-specific terms to `templates/terminology-glossary.md` or a user-provided glossary, and let project-specific terms override this file when needed.
# HFSP-TWET Problem Input Example

本文研究混合流水车间调度问题。每个工件需要依次经过多个阶段，每个阶段包含一台或多台并行机器。同一机器同一时间只能加工一个工件。每个工件具有交期窗口，部分工件为优先级工件，多个工件可能共享交期窗口，并且部分机器存在不可用时间段 MUPs。目标是最小化总加权提前与延期惩罚 TWET。计划设计 two-phase iterated greedy algorithm，并与 IG、ILS、GA、SA 等方法进行比较。

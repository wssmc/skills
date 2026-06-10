# Scheduling Feasibility Checks

- No two operations overlap on the same machine.
- Each operation starts after all predecessors finish.
- Missing operations are not scheduled.
- Each operation uses an eligible machine.
- Batch / lot / family constraints are satisfied.
- Release dates, due dates, setup, transport, blocking or no-wait constraints are checked if present.
- Objective is independently recomputed from the schedule.

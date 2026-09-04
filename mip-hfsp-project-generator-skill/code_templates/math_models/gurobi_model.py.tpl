"""Gurobi MIP 建模 — src/math_models/gurobi_model.py

基础 HFSP 的 Gurobi MIP 模型。
求解后必须调用 check_feasibility(instance, schedule) 验证约束满足。

输出:
  - result.json (含 status, objective, LB, gap, runtime, violations)
  - schedule.csv
  - gantt.png
"""
from __future__ import annotations

import time
from typing import Any

try:
    import gurobipy as gp
    from gurobipy import GRB
except ImportError:
    gp = None
    GRB = None

import sys
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent.parent.parent))
from core.domain import Instance, Schedule, Operation, Result


def build_and_solve(
    instance: Instance,
    time_limit: float = 3600.0,
    mip_gap: float = 0.001,
    threads: int = 0,
    log_output: bool = True,
) -> Result:
    """构建并求解 HFSP MIP 模型。

    Args:
        instance: 算例数据
        time_limit: 求解时限（秒），正式实验默认 3600
        mip_gap: MIP gap 容差
        threads: 线程数，0=自动
        log_output: 是否输出求解日志

    Returns:
        Result 对象
    """
    if gp is None:
        return Result(method="MIP", status="Error", extra={"error": "gurobipy not installed"})
    validation_errors = instance.validate()
    if validation_errors:
        raise ValueError(f"Invalid instance: {validation_errors}")
    if time_limit <= 0:
        raise ValueError("time_limit must be positive")
    if not 0 <= mip_gap < 1:
        raise ValueError("mip_gap must be in [0, 1)")
    if threads < 0:
        raise ValueError("threads must be non-negative")

    t0 = time.perf_counter()
    env = gp.Env(empty=True)
    env.setParam("OutputFlag", 1 if log_output else 0)
    env.start()

    model = gp.Model("HFSP", env=env)
    model.Params.TimeLimit = time_limit
    model.Params.MIPGap = mip_gap
    if threads > 0:
        model.Params.Threads = threads

    n_jobs = instance.num_jobs
    n_stages = instance.num_stages

    # --- 变量 ---
    S = {}  # S[j, s] 开始时间
    C = {}  # C[j, s] 完工时间
    x = {}  # x[j, s, m] 机器分配
    y = {}  # y[i, j, s, m] 排序

    for j in range(n_jobs):
        for s in range(n_stages):
            S[j, s] = model.addVar(lb=0.0, name=f"S_{j}_{s}")
            C[j, s] = model.addVar(lb=0.0, name=f"C_{j}_{s}")
            machines = instance.stage_machines.get(s, [])
            for m in machines:
                x[j, s, m] = model.addVar(vtype=GRB.BINARY, name=f"x_{j}_{s}_{m}")
                for i in range(j):
                    y[i, j, s, m] = model.addVar(vtype=GRB.BINARY, name=f"y_{i}_{j}_{s}_{m}")

    Cmax = model.addVar(lb=0.0, name="Cmax")
    model.update()

    # --- 约束 ---
    max_release = max(instance.release_times.values(), default=0.0)
    total_processing = sum(
        instance.processing_times[j][s]
        for j in range(n_jobs)
        for s in range(n_stages)
    )
    total_precedence_lag = sum(arc.lag for arc in instance.precedence)
    BIG_M = max_release + total_processing + total_precedence_lag + 1.0

    for j in range(n_jobs):
        for s in range(n_stages):
            machines = instance.stage_machines.get(s, [])
            pt = instance.processing_times.get(j, {}).get(s, 0.0)

            # 1. 每个 Job 每个 Stage 必须选择一台机器
            model.addConstr(
                gp.quicksum(x[j, s, m] for m in machines) == 1,
                name=f"assign_{j}_{s}"
            )

            # 2. 完工时间定义
            model.addConstr(C[j, s] == S[j, s] + pt,
                            name=f"comp_{j}_{s}")

            # 3. release time
            if j in instance.release_times:
                model.addConstr(S[j, s] >= instance.release_times[j], name=f"release_{j}_{s}")

            # 4. Stage 顺序约束
            if s > 0:
                model.addConstr(S[j, s] >= C[j, s - 1], name=f"prec_{j}_{s}")

            # 5. 机器非重叠约束
            for m in machines:
                for i in range(j):
                    pt_i = instance.processing_times.get(i, {}).get(s, 0.0)
                    model.addConstr(
                        S[j, s] + BIG_M * (3 - x[j, s, m] - x[i, s, m] - y[i, j, s, m]) >= C[i, s],
                        name=f"nolap_{i}_{j}_{s}_{m}"
                    )
                    model.addConstr(
                        S[i, s] + BIG_M * (3 - x[j, s, m] - x[i, s, m] - (1 - y[i, j, s, m])) >= C[j, s],
                        name=f"nolap2_{i}_{j}_{s}_{m}"
                    )

            # 6. makespan 定义
            model.addConstr(Cmax >= C[j, s], name=f"cmax_{j}_{s}")

    for arc in instance.precedence:
        model.addConstr(
            S[arc.to_job, 0] >= C[arc.from_job, n_stages - 1] + arc.lag,
            name=f"job_prec_{arc.from_job}_{arc.to_job}",
        )

    # --- 目标 ---
    model.setObjective(Cmax, GRB.MINIMIZE)

    # --- 求解 ---
    model.optimize()
    runtime = time.perf_counter() - t0

    # --- 提取结果 ---
    status_map = {
        GRB.OPTIMAL: "Optimal",
        GRB.SUBOPTIMAL: "Feasible",
        GRB.TIME_LIMIT: "Timeout",
        GRB.INFEASIBLE: "Infeasible",
    }
    status = status_map.get(model.status, "Unknown")
    if model.SolCount > 0 and status == "Unknown":
        status = "Feasible"

    result = Result(method="MIP", status=status, runtime=runtime)

    if model.SolCount > 0:
        result.objective = model.ObjVal
        result.makespan = model.ObjVal
        result.extra["LB"] = model.ObjBound
        result.extra["gap"] = model.MIPGap
        result.extra["schedule_source"] = "direct_mip"

        schedule = Schedule(objective=model.ObjVal, metrics={"makespan": model.ObjVal})
        for j in range(n_jobs):
            for s in range(n_stages):
                machines = instance.stage_machines.get(s, [])
                for m in machines:
                    if abs(x[j, s, m].X - 1.0) < 0.5:
                        op = Operation(
                            job_id=j, stage_id=s, machine_id=m,
                            start=S[j, s].X, end=C[j, s].X,
                            processing_time=instance.processing_times.get(j, {}).get(s, 0.0),
                        )
                        schedule.operations.append(op)
                        break
        result.schedule = schedule
    else:
        result.extra["LB"] = model.ObjBound if model.ObjBound < GRB.INFINITY else float("inf")

    model.dispose()
    env.dispose()
    return result

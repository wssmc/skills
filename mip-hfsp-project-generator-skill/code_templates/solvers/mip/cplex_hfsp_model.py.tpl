from docplex.mp.model import Model
from src.core.schedule import Schedule, ScheduledOperation


class CplexHFSPModel:
    """CPLEX/docplex MIP model for basic HFSP."""

    def __init__(self, instance, config=None):
        self.instance = instance
        self.config = config or {}
        self.model = Model(name=f"HFSP_{instance.name}")
        self.S = {}
        self.C = {}
        self.x = {}
        self.y = {}
        self.Cmax = None

    def build(self):
        inst = self.instance
        mdl = self.model
        jobs, stages = inst.jobs, inst.stages

        horizon = sum(
            max(inst.processing_times[j][s] for j in jobs) for s in stages
        ) * len(jobs)
        big_m = max(1.0, horizon * 2)

        self.S = {(j, s): mdl.continuous_var(lb=0, name=f"S_{j}_{s}") for j in jobs for s in stages}
        self.C = {(j, s): mdl.continuous_var(lb=0, name=f"C_{j}_{s}") for j in jobs for s in stages}
        self.Cmax = mdl.continuous_var(lb=0, name="Cmax")

        for j in jobs:
            for s in stages:
                for m in inst.stage_machines[s]:
                    self.x[j, s, m] = mdl.binary_var(name=f"x_{j}_{s}_{m}")

        for s in stages:
            for m in inst.stage_machines[s]:
                for i in jobs:
                    for j in jobs:
                        if i < j:
                            self.y[i, j, s, m] = mdl.binary_var(name=f"y_{i}_{j}_{s}_{m}")

        # Each operation selects one machine in its stage.
        for j in jobs:
            for s in stages:
                mdl.add_constraint(mdl.sum(self.x[j, s, m] for m in inst.stage_machines[s]) == 1)

        # Completion definition.
        for j in jobs:
            for s in stages:
                p = inst.processing_times[j][s]
                mdl.add_constraint(self.C[j, s] == self.S[j, s] + p)

        # Release time.
        first_stage = stages[0]
        for j in jobs:
            mdl.add_constraint(self.S[j, first_stage] >= inst.release_times.get(j, 0.0))

        # Stage precedence.
        for j in jobs:
            for a, b in zip(stages[:-1], stages[1:]):
                mdl.add_constraint(self.S[j, b] >= self.C[j, a])

        # Machine no-overlap.
        for s in stages:
            for m in inst.stage_machines[s]:
                for i in jobs:
                    for j in jobs:
                        if i < j:
                            y = self.y[i, j, s, m]
                            mdl.add_constraint(self.S[j, s] >= self.C[i, s] - big_m * (1 - y) - big_m * (2 - self.x[i, s, m] - self.x[j, s, m]))
                            mdl.add_constraint(self.S[i, s] >= self.C[j, s] - big_m * y - big_m * (2 - self.x[i, s, m] - self.x[j, s, m]))

        last_stage = stages[-1]
        for j in jobs:
            mdl.add_constraint(self.Cmax >= self.C[j, last_stage])

        mdl.minimize(self.Cmax)
        return self

    def solve(self):
        if self.config.get("time_limit"):
            self.model.parameters.timelimit = self.config["time_limit"]
        if self.config.get("mip_gap") is not None:
            self.model.parameters.mip.tolerances.mipgap = self.config["mip_gap"]
        if self.config.get("threads"):
            self.model.parameters.threads = self.config["threads"]

        return self.model.solve(log_output=self.config.get("log_output", True))

    def extract_schedule(self) -> Schedule:
        inst = self.instance
        ops = []
        for j in inst.jobs:
            for s in inst.stages:
                machine_id = None
                for m in inst.stage_machines[s]:
                    if self.x[j, s, m].solution_value > 0.5:
                        machine_id = m
                        break
                ops.append(ScheduledOperation(
                    job_id=j,
                    stage_id=s,
                    machine_id=machine_id,
                    start=float(self.S[j, s].solution_value),
                    end=float(self.C[j, s].solution_value),
                    processing_time=float(inst.processing_times[j][s]),
                ))
        return Schedule(
            operations=ops,
            objective=float(self.Cmax.solution_value),
            metadata={"solver": "cplex", "status": str(self.model.solve_details.status)}
        )

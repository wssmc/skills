def check_stage_precedence(schedule, instance, eps=1e-9):
    by_job_stage = {(op.job_id, op.stage_id): op for op in schedule.operations}
    violations = []
    for j in instance.jobs:
        for a, b in zip(instance.stages[:-1], instance.stages[1:]):
            if by_job_stage[(j, b)].start + eps < by_job_stage[(j, a)].end:
                violations.append(("precedence", j, a, b))
    return violations


def check_machine_no_overlap(schedule, eps=1e-9):
    by_machine = {}
    for op in schedule.operations:
        by_machine.setdefault(op.machine_id, []).append(op)
    violations = []
    for m, ops in by_machine.items():
        ops = sorted(ops, key=lambda x: x.start)
        for prev, cur in zip(ops[:-1], ops[1:]):
            if cur.start + eps < prev.end:
                violations.append(("machine_overlap", m, prev.job_id, cur.job_id))
    return violations


def check_feasibility(schedule, instance):
    violations = []
    violations.extend(check_stage_precedence(schedule, instance))
    violations.extend(check_machine_no_overlap(schedule))
    return violations

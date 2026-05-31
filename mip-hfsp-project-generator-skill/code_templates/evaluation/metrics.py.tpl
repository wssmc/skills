def calculate_makespan(schedule):
    return max((op.end for op in schedule.operations), default=0.0)


def calculate_total_tardiness(schedule, instance):
    last_stage = instance.stages[-1]
    completion = {}
    for op in schedule.operations:
        if op.stage_id == last_stage:
            completion[op.job_id] = op.end
    total = 0.0
    for j, c in completion.items():
        due = instance.due_dates.get(j)
        if due is not None:
            total += max(0.0, c - due) * instance.due_weights.get(j, 1.0)
    return total


def evaluate_schedule(schedule, instance):
    makespan = calculate_makespan(schedule)
    tardiness = calculate_total_tardiness(schedule, instance)
    schedule.metrics.update({
        "makespan": makespan,
        "total_tardiness": tardiness,
    })
    return schedule.metrics

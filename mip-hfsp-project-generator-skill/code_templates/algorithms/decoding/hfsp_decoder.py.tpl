from src.core.schedule import Schedule, ScheduledOperation


def decode_hfsp_encoding(encoding, instance):
    """Serial schedule generation scheme for basic HFSP."""
    job_sequence = encoding["job_sequence"]
    machine_assignment = encoding["machine_assignment"]

    job_ready = {j: instance.release_times.get(j, 0.0) for j in instance.jobs}
    machine_ready = {m: 0.0 for s in instance.stages for m in instance.stage_machines[s]}
    operations = []

    for s in instance.stages:
        for j in job_sequence:
            m = machine_assignment[(j, s)]
            p = instance.processing_times[j][s]
            start = max(job_ready[j], machine_ready[m])
            end = start + p
            operations.append(ScheduledOperation(
                job_id=j,
                stage_id=s,
                machine_id=m,
                start=start,
                end=end,
                processing_time=p,
            ))
            job_ready[j] = end
            machine_ready[m] = end

    makespan = max(op.end for op in operations) if operations else 0.0
    return Schedule(
        operations=operations,
        objective=makespan,
        metrics={"makespan": makespan},
        metadata={"method": "hfsp_decoder"}
    )

import random


def generate_random_encoding(instance, seed=None):
    """Generate HFSP encoding: job_sequence + machine_assignment."""
    rng = random.Random(seed)
    job_sequence = list(instance.jobs)
    rng.shuffle(job_sequence)

    machine_assignment = {}
    for j in instance.jobs:
        for s in instance.stages:
            machine_assignment[(j, s)] = rng.choice(instance.stage_machines[s])

    return {
        "job_sequence": job_sequence,
        "machine_assignment": machine_assignment,
    }


def validate_encoding(encoding, instance):
    seq = encoding.get("job_sequence", [])
    if sorted(seq) != sorted(instance.jobs):
        return False
    ma = encoding.get("machine_assignment", {})
    for j in instance.jobs:
        for s in instance.stages:
            if (j, s) not in ma:
                return False
            if ma[(j, s)] not in instance.stage_machines[s]:
                return False
    return True

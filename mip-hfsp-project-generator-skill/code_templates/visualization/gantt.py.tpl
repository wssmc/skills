from pathlib import Path
import matplotlib.pyplot as plt


def plot_gantt(schedule, title, output_path):
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    machines = sorted({op.machine_id for op in schedule.operations})
    machine_to_y = {m: i for i, m in enumerate(machines)}

    fig, ax = plt.subplots(figsize=(12, 6))
    for op in schedule.operations:
        y = machine_to_y[op.machine_id]
        ax.barh(y, op.end - op.start, left=op.start)
        ax.text(op.start + (op.end - op.start) / 2, y, f"J{op.job_id}-{op.stage_id}", ha="center", va="center", fontsize=8)

    ax.set_yticks(list(machine_to_y.values()))
    ax.set_yticklabels(list(machine_to_y.keys()))
    ax.set_xlabel("Time")
    ax.set_ylabel("Machine")
    ax.set_title(title)
    fig.tight_layout()
    fig.savefig(output_path, dpi=200)
    plt.close(fig)

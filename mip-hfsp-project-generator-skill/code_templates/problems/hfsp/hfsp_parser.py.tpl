from pathlib import Path
from src.io.json_index_loader import load_index
from src.io.txt_loader import read_hfsp_processing_times, read_stage_machines, read_table_txt
from src.problems.hfsp.hfsp_instance import HFSPInstance


def load_hfsp_instance(index_path: str | Path) -> HFSPInstance:
    index_path = Path(index_path)
    root = index_path.parent
    index = load_index(index_path)
    files = index["files"]

    jobs, stages, processing_times = read_hfsp_processing_times(root / files["processing_times"])
    stage_machines = read_stage_machines(root / files["stage_machines"])

    release_times = {j: 0.0 for j in jobs}
    if "release_times" in files:
        df = read_table_txt(root / files["release_times"])
        release_times = {int(r.JobID): float(r.ReleaseTime) for r in df.itertuples(index=False)}

    due_dates = {}
    due_weights = {}
    if "due_dates" in files:
        df = read_table_txt(root / files["due_dates"])
        due_dates = {int(r.JobID): float(r.DueDate) for r in df.itertuples(index=False)}
        due_weights = {int(r.JobID): float(getattr(r, "Weight", 1.0)) for r in df.itertuples(index=False)}

    instance = HFSPInstance(
        problem_type="HFSP",
        name=index.get("name", index_path.parent.name),
        jobs=jobs,
        stages=stages,
        processing_times=processing_times,
        stage_machines=stage_machines,
        release_times=release_times,
        due_dates=due_dates,
        due_weights=due_weights,
        metadata=index,
    )
    instance.validate()
    return instance

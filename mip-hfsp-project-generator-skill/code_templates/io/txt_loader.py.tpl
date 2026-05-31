from pathlib import Path
import pandas as pd


def read_table_txt(path: str | Path) -> pd.DataFrame:
    """Read tab-separated txt table."""
    return pd.read_csv(Path(path), sep="\t")


def read_hfsp_processing_times(path: str | Path):
    df = read_table_txt(path)
    if "JobID" not in df.columns:
        raise ValueError("processing_times.txt must contain JobID column.")
    stages = [c for c in df.columns if c != "JobID"]
    jobs = df["JobID"].astype(int).tolist()
    processing_times = {}
    for _, row in df.iterrows():
        j = int(row["JobID"])
        processing_times[j] = {s: float(row[s]) for s in stages}
    return jobs, stages, processing_times


def read_stage_machines(path: str | Path):
    df = read_table_txt(path)
    if "MachineCount" in df.columns:
        stage_machines = {}
        for _, row in df.iterrows():
            stage = str(row["StageID"])
            count = int(row["MachineCount"])
            stage_machines[stage] = [f"{stage}_M{k}" for k in range(count)]
        return stage_machines
    if "MachineID" in df.columns:
        stage_machines = {}
        for _, row in df.iterrows():
            stage_machines.setdefault(str(row["StageID"]), []).append(str(row["MachineID"]))
        return stage_machines
    raise ValueError("stage_machines.txt must contain MachineCount or MachineID.")

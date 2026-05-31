import json
from pathlib import Path


def load_index(index_path: str | Path) -> dict:
    index_path = Path(index_path)
    with index_path.open("r", encoding="utf-8") as f:
        data = json.load(f)
    if "problem_type" not in data:
        raise ValueError("index.json must contain problem_type.")
    if "files" not in data:
        raise ValueError("index.json must contain files.")
    return data

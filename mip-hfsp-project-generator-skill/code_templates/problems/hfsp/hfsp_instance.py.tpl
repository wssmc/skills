from dataclasses import dataclass, field
from typing import Dict, List
from src.core.instance import BaseInstance


@dataclass
class HFSPInstance(BaseInstance):
    """Hybrid Flow Shop Scheduling instance."""
    jobs: List[int] = field(default_factory=list)
    stages: List[str] = field(default_factory=list)
    processing_times: Dict[int, Dict[str, float]] = field(default_factory=dict)
    stage_machines: Dict[str, List[str]] = field(default_factory=dict)
    release_times: Dict[int, float] = field(default_factory=dict)
    due_dates: Dict[int, float] = field(default_factory=dict)
    due_weights: Dict[int, float] = field(default_factory=dict)

    def validate(self) -> None:
        if self.problem_type != "HFSP":
            raise ValueError("HFSPInstance requires problem_type='HFSP'.")
        if not self.jobs:
            raise ValueError("No jobs found.")
        if not self.stages:
            raise ValueError("No stages found.")
        for j in self.jobs:
            for s in self.stages:
                if j not in self.processing_times or s not in self.processing_times[j]:
                    raise ValueError(f"Missing processing time for job={j}, stage={s}.")
        for s in self.stages:
            if s not in self.stage_machines or not self.stage_machines[s]:
                raise ValueError(f"No machines for stage={s}.")

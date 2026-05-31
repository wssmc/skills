from dataclasses import dataclass, field
from typing import Any, Dict, List


@dataclass
class ScheduledOperation:
    job_id: int
    stage_id: str
    machine_id: str
    start: float
    end: float
    processing_time: float


@dataclass
class Schedule:
    operations: List[ScheduledOperation] = field(default_factory=list)
    objective: float | None = None
    metrics: Dict[str, Any] = field(default_factory=dict)
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_records(self) -> List[Dict[str, Any]]:
        return [op.__dict__ for op in self.operations]

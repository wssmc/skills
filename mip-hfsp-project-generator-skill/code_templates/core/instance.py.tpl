from dataclasses import dataclass, field
from typing import Any, Dict, List


@dataclass
class BaseInstance:
    """Base problem instance shared by MIP, decoder, baselines and proposed algorithms."""
    problem_type: str
    name: str = "unnamed_instance"
    metadata: Dict[str, Any] = field(default_factory=dict)

    def validate(self) -> None:
        """Validate instance data."""
        raise NotImplementedError

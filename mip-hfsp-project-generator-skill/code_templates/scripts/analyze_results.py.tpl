"""Thin CLI wrapper; analysis logic lives in python/analysis/analyze_results.py."""
from __future__ import annotations

import runpy
import sys
from pathlib import Path


if __name__ == "__main__":
    target = Path(__file__).resolve().parents[1] / "python" / "analysis" / "analyze_results.py"
    sys.argv[0] = str(target)
    runpy.run_path(str(target), run_name="__main__")

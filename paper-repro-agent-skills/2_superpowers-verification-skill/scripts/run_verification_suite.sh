#!/usr/bin/env bash
set -euo pipefail
pytest tests/unit -q
pytest tests/feasibility -q
pytest tests/consistency -q
pytest tests/regression -q

#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

instance_dir="${1:?usage: scripts/run_mip.sh INSTANCE_DIR SOLVE_SEED ROUND}"
solve_seed="${2:?usage: scripts/run_mip.sh INSTANCE_DIR SOLVE_SEED ROUND}"
round="${3:?usage: scripts/run_mip.sh INSTANCE_DIR SOLVE_SEED ROUND}"

[[ "$solve_seed" =~ ^[0-9]+$ ]] || { echo "solve seed must be a non-negative integer" >&2; exit 2; }
[[ "$round" =~ ^[1-9][0-9]*$ ]] || { echo "round must be a positive integer" >&2; exit 2; }

if [[ -z "${SCHED_OUTPUT_ROOT:-}" ]]; then
  SCHED_OUTPUT_ROOT="$(bash scripts/lib/allocate_result_root.sh "${BASH_SOURCE[0]}" "${RESULT_VARIANT:-}")"
  export SCHED_OUTPUT_ROOT
fi

python_cmd="${PYTHON:-python}"
if ! "$python_cmd" -c "import cplex" >/dev/null 2>&1; then
  echo "NOT_RUN: IBM CPLEX Python API is unavailable in $python_cmd" >&2
  exit 3
fi
"$python_cmd" python/math_models/solve_cplex.py \
  --instance "$instance_dir" \
  --solve-seed "$solve_seed" \
  --round "$round"

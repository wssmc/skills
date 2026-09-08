#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

instance_dir="${1:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND}"
algorithm="${2:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND}"
solve_seed="${3:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND}"
round="${4:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM SOLVE_SEED ROUND}"

[[ "$solve_seed" =~ ^[0-9]+$ ]] || { echo "solve seed must be a non-negative integer" >&2; exit 2; }
[[ "$round" =~ ^[1-9][0-9]*$ ]] || { echo "round must be a positive integer" >&2; exit 2; }

if [[ -z "${SCHED_OUTPUT_ROOT:-}" ]]; then
  SCHED_OUTPUT_ROOT="$(bash scripts/lib/allocate_result_root.sh "${BASH_SOURCE[0]}" "${RESULT_VARIANT:-}")"
  export SCHED_OUTPUT_ROOT
fi

runner="build/solver_run"
if [[ -x build/Release/solver_run.exe ]]; then
  runner="build/Release/solver_run.exe"
elif [[ -x build/solver_run.exe ]]; then
  runner="build/solver_run.exe"
fi
[[ -x "$runner" ]] || { echo "runner not found; run scripts/build.sh first" >&2; exit 3; }
"$runner" "$instance_dir" "$algorithm" "$solve_seed" "$round"

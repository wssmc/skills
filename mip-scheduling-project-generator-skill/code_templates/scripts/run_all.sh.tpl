#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

instance_root="${1:?usage: scripts/run_all.sh INSTANCE_ROOT SOLVE_SEEDS_FILE [ALGORITHM...]}"
seed_file="${2:?usage: scripts/run_all.sh INSTANCE_ROOT SOLVE_SEEDS_FILE [ALGORITHM...]}"
shift 2

if [[ -z "${SCHED_OUTPUT_ROOT:-}" ]]; then
  SCHED_OUTPUT_ROOT="$(bash scripts/lib/allocate_result_root.sh "${BASH_SOURCE[0]}" "${RESULT_VARIANT:-}")"
  export SCHED_OUTPUT_ROOT
fi

scripts/build.sh
SCHED_OUTPUT_ROOT=outputs/tmp/smoke/ctest ctest --test-dir build --output-on-failure
scripts/run_batch.sh "$instance_root" "$seed_file" "$@"
scripts/analyze.sh "$SCHED_OUTPUT_ROOT" "$SCHED_OUTPUT_ROOT/analysis_summary.csv"
scripts/audit.sh

#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

input_root="${1:-${SCHED_OUTPUT_ROOT:-outputs/formal}}"
output_file="${2:-${input_root}/analysis_summary.csv}"
"${PYTHON:-python}" python/analysis/analyze_results.py \
  --input "$input_root" \
  --output "$output_file"

#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

output="${1:?usage: scripts/generate_instances.sh OUTPUT JOBS STAGES INSTANCE_SEED}"
jobs="${2:?usage: scripts/generate_instances.sh OUTPUT JOBS STAGES INSTANCE_SEED}"
stages="${3:?usage: scripts/generate_instances.sh OUTPUT JOBS STAGES INSTANCE_SEED}"
instance_seed="${4:?usage: scripts/generate_instances.sh OUTPUT JOBS STAGES INSTANCE_SEED}"

[[ "$instance_seed" =~ ^[0-9]+$ ]] || { echo "instance seed must be a non-negative integer" >&2; exit 2; }
"${PYTHON:-python}" python/tools/generate_instances.py \
  --output "$output" --jobs "$jobs" --stages "$stages" --seed "$instance_seed"

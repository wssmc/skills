#!/usr/bin/env bash
set -euo pipefail

instance_dir="${1:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM}"
algorithm="${2:?usage: scripts/run_single.sh INSTANCE_DIR ALGORITHM}"
cmake --build build --config Release
if [[ -x build/Release/hfsp_run.exe ]]; then
  build/Release/hfsp_run.exe "$instance_dir" "$algorithm"
else
  build/hfsp_run "$instance_dir" "$algorithm"
fi

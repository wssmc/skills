#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release

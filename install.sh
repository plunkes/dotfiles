#!/usr/bin/env bash
# Run every setup step in order. Each step can also be run on its own.
# Usage: ./install.sh [first-step]   e.g. ./install.sh 05
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

start="${1:-00}"
for script in scripts/[0-9][0-9]-*.sh; do
  step="$(basename "$script" | cut -c1-2)"
  [[ "$step" < "$start" ]] && continue
  printf '\n\033[1;35m### %s\033[0m\n' "$script"
  bash "$script"
done

#!/usr/bin/env bash
set -euo pipefail

color="${1:-black}"
alpha="${2:-1}"
timeout_s="${3:-}"

cmd=(
  yad
  --title="window-placeholder"
  --no-buttons
  --skip-taskbar
  --css=".background { background: alpha($color, $alpha); }"
)

if [ -n "$timeout_s" ]; then
  timeout "$timeout_s" "${cmd[@]}"
else
  "${cmd[@]}"
fi
# TODO be able to create at specific size, ratio and position

#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

tiling_script="${RESIZE_TILING_SCRIPT:-$script_dir/resize-tiling.sh}"
floating_script="${RESIZE_FLOATING_SCRIPT:-$script_dir/resize-floating.sh}"

active_json="$(hyprctl activewindow -j)"
floating="$(jq -r '.floating // false' <<< "$active_json")"

if [ "$floating" = "true" ]; then
  exec "$floating_script" "$@"
else
  exec "$tiling_script" "$@"
fi

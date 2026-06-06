#!/usr/bin/env bash
set -euo pipefail

target="${1:-hidden}"

state="$(hyprctl -j monitors)"

# Estado original
orig_monitor="$(
  jq -r '.[] | select(.focused == true) | .name' <<< "$state"
)"

orig_ws="$(
  jq -r '.[] | select(.focused == true) | .activeWorkspace.name' <<< "$state"
)"

# Monitor onde a special alvo está visível
special_monitor="$(
  jq -r --arg target "special:$target" '
    .[] | select(.specialWorkspace.name == $target) | .name
  ' <<< "$state" | head -n 1
)"

[[ -n "$special_monitor" ]] || exit 0

lua_target="$(
  jq -Rn -r --arg s "$target" '$s | @json'
)"

lua_special_monitor="$(
  jq -Rn -r --arg s "$special_monitor" '$s | @json'
)"

lua_orig_monitor="$(
  jq -Rn -r --arg s "$orig_monitor" '$s | @json'
)"

hyprctl eval "
  hl.dispatch(hl.dsp.focus({ monitor = $lua_special_monitor }))
  hl.dispatch(hl.dsp.workspace.toggle_special($lua_target))
  hl.dispatch(hl.dsp.focus({ monitor = $lua_orig_monitor }))
"

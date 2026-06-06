#!/usr/bin/env bash
set -euo pipefail

direction="${1:-f}"

if hyprctl -j activewindow | jq -e '(.grouped // []) | length > 0' >/dev/null; then
  case "$direction" in
    f) hyprctl eval 'hl.dispatch(hl.dsp.group.next("f"))' ;;
    b) hyprctl eval 'hl.dispatch(hl.dsp.group.prev("b"))' ;;
    *) exit 2 ;;
  esac
else
  hyprctl eval 'hl.dispatch(hl.dsp.focus({ workspace = "previous" }))'
fi

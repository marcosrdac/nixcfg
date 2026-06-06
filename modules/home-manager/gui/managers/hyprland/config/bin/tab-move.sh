#!/usr/bin/env bash
set -euo pipefail

direction="${1:-f}"

if hyprctl -j activewindow | jq -e '(.grouped // []) | length > 0' >/dev/null; then
  case "$direction" in
    f)
      hyprctl eval '
        hl.dispatch(
          hl.dsp.group.move_window({ forward = true })
        )
      '
      ;;
    b)
      hyprctl eval '
        hl.dispatch(
          hl.dsp.group.move_window({ forward = false })
        )
      '
      ;;
    *)
      echo "usage: move-tab.sh [f|b]" >&2
      exit 2
      ;;
  esac
fi

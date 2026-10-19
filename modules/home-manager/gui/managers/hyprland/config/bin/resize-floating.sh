#!/usr/bin/env bash
set -euo pipefail

action="grow"
dir=""
step=40
debug=0
min_w=80
min_h=60

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") [--grow|--shrink] --left [PX]
  $(basename "$0") [--grow|--shrink] --right [PX]
  $(basename "$0") [--grow|--shrink] --up [PX]
  $(basename "$0") [--grow|--shrink] --down [PX]

options:
  --step PX
  --min-width PX
  --min-height PX
  --debug

meaning:
  --grow --left      grow left edge outward
  --grow --right     grow right edge outward
  --grow --up        grow top edge outward
  --grow --down      grow bottom edge outward

  --shrink --left    shrink from left edge
  --shrink --right   shrink from right edge
  --shrink --up      shrink from top edge
  --shrink --down    shrink from bottom edge
USAGE
  exit 2
}

log() {
  if [ "$debug" -eq 1 ]; then
    echo "[resize-floating] $*" >&2
  fi
}

dispatch() {
  log "dispatch: $1"
  hyprctl dispatch "$1" >/dev/null
}

clamp_amount() {
  local wanted="$1"
  local current="$2"
  local minimum="$3"
  local available

  available="$((current - minimum))"

  if [ "$available" -le 0 ]; then
    echo 0
  elif [ "$wanted" -gt "$available" ]; then
    echo "$available"
  else
    echo "$wanted"
  fi
}

resize_exact() {
  local w="$1"
  local h="$2"

  dispatch "hl.dsp.window.resize({ x = $w, y = $h, exact = true })"
}

move_exact() {
  local x="$1"
  local y="$2"

  dispatch "hl.dsp.window.move({ x = $x, y = $y, exact = true })"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --grow|grow)
      action="grow"
      shift
      ;;

    --shrink|shrink)
      action="shrink"
      shift
      ;;

    --left|left)
      dir="left"
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        step="$1"
        shift
      fi
      ;;

    --right|right)
      dir="right"
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        step="$1"
        shift
      fi
      ;;

    --up|up)
      dir="up"
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        step="$1"
        shift
      fi
      ;;

    --down|down)
      dir="down"
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        step="$1"
        shift
      fi
      ;;

    --step|-s)
      shift
      [ "$#" -gt 0 ] || usage
      step="$1"
      shift
      ;;

    --min-width)
      shift
      [ "$#" -gt 0 ] || usage
      min_w="$1"
      shift
      ;;

    --min-height)
      shift
      [ "$#" -gt 0 ] || usage
      min_h="$1"
      shift
      ;;

    --debug)
      debug=1
      shift
      ;;

    # Tiling-only args. Ignore for compatibility when using resize-general.sh.
    --target|--sign)
      shift
      [ "$#" -gt 0 ] || usage
      shift
      ;;

    --auto)
      shift
      ;;

    *)
      usage
      ;;
  esac
done

[ -n "$dir" ] || usage

case "$step" in
  ''|*[!0-9]*)
    echo "invalid step: $step" >&2
    exit 2
    ;;
esac

case "$min_w" in
  ''|*[!0-9]*)
    echo "invalid min width: $min_w" >&2
    exit 2
    ;;
esac

case "$min_h" in
  ''|*[!0-9]*)
    echo "invalid min height: $min_h" >&2
    exit 2
    ;;
esac

active_json="$(hyprctl activewindow -j)"
floating="$(jq -r '.floating // false' <<< "$active_json")"

if [ "$floating" != "true" ]; then
  echo "active window is not floating; use resize-general.sh or resize-tiling.sh" >&2
  exit 1
fi

x="$(jq -r '.at[0]' <<< "$active_json")"
y="$(jq -r '.at[1]' <<< "$active_json")"
w="$(jq -r '.size[0]' <<< "$active_json")"
h="$(jq -r '.size[1]' <<< "$active_json")"

new_x="$x"
new_y="$y"
new_w="$w"
new_h="$h"

case "$action:$dir" in
  grow:left)
    new_x="$((x - step))"
    new_w="$((w + step))"
    ;;

  grow:right)
    new_w="$((w + step))"
    ;;

  grow:up)
    new_y="$((y - step))"
    new_h="$((h + step))"
    ;;

  grow:down)
    new_h="$((h + step))"
    ;;

  shrink:left)
    amount="$(clamp_amount "$step" "$w" "$min_w")"
    new_x="$((x + amount))"
    new_w="$((w - amount))"
    ;;

  shrink:right)
    amount="$(clamp_amount "$step" "$w" "$min_w")"
    new_w="$((w - amount))"
    ;;

  shrink:up)
    amount="$(clamp_amount "$step" "$h" "$min_h")"
    new_y="$((y + amount))"
    new_h="$((h - amount))"
    ;;

  shrink:down)
    amount="$(clamp_amount "$step" "$h" "$min_h")"
    new_h="$((h - amount))"
    ;;

  *)
    usage
    ;;
esac

log "action=$action dir=$dir step=$step"
log "old x=$x y=$y w=$w h=$h"
log "new x=$new_x y=$new_y w=$new_w h=$new_h"

resize_exact "$new_w" "$new_h"
move_exact "$new_x" "$new_y"

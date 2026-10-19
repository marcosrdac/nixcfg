#!/usr/bin/env bash
set -euo pipefail

x=""
y=""
gap=0
hpos=""
vpos=""

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") --x PX --y PX
  $(basename "$0") --center
  $(basename "$0") [--left|--center-x|--right] [--top|--center-y|--bottom] [--gap [PX]]

examples:
  $(basename "$0") --center
  $(basename "$0") --top
  $(basename "$0") --top --center-x
  $(basename "$0") --top --left --gap
  $(basename "$0") --right --bottom --gap 30
  $(basename "$0") --x 100 --y 80
USAGE
  exit 2
}

hypr_outer_gap() {
  hyprctl getoption general:gaps_out \
    | awk '
        /^css gap data:/ {
          print $4
          found = 1
          exit
        }
        END {
          if (!found) print 0
        }
      '
}

resolve_gap() {
  local value="${1:-}"
  local base

  base="$(hypr_outer_gap)"

  case "$value" in
    "")
      echo "$base"
      ;;

    *x)
      awk -v base="$base" -v mult="${value%x}" '
        BEGIN { printf "%d", base * mult }
      '
      ;;

    *)
      echo "$value"
      ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --x)
      shift
      [ "$#" -gt 0 ] || usage
      x="$1"
      shift
      ;;

    --y)
      shift
      [ "$#" -gt 0 ] || usage
      y="$1"
      shift
      ;;

    -g|--gap)
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        gap="$(resolve_gap "$1")"
        shift
      else
        gap="$(resolve_gap)"
      fi
      ;;

    --center)
      if [ -z "$hpos" ] && [ -z "$vpos" ]; then
        hpos="center"
        vpos="center"
      elif [ -z "$hpos" ]; then
        hpos="center"
      elif [ -z "$vpos" ]; then
        vpos="center"
      else
        usage
      fi
      shift
      ;;

    --left)
      hpos="left"
      shift
      ;;

    --center-x)
      hpos="center"
      shift
      ;;

    --right)
      hpos="right"
      shift
      ;;

    --top)
      vpos="top"
      shift
      ;;

    --center-y)
      vpos="center"
      shift
      ;;

    --bottom)
      vpos="bottom"
      shift
      ;;

    *)
      usage
      ;;
  esac
done

active_json="$(hyprctl activewindow -j)"
monitors_json="$(hyprctl monitors -j)"

cur_x="$(jq -r '.at[0]' <<< "$active_json")"
cur_y="$(jq -r '.at[1]' <<< "$active_json")"
win_w="$(jq -r '.size[0]' <<< "$active_json")"
win_h="$(jq -r '.size[1]' <<< "$active_json")"
mon_id="$(jq -r '.monitor' <<< "$active_json")"

mon_json="$(jq -c --argjson id "$mon_id" '.[] | select(.id == $id)' <<< "$monitors_json")"

mon_x="$(jq -r '.x' <<< "$mon_json")"
mon_y="$(jq -r '.y' <<< "$mon_json")"
mon_w="$(jq -r '.width' <<< "$mon_json")"
mon_h="$(jq -r '.height' <<< "$mon_json")"

case "${gap:-}" in
  ""|null) gap=0 ;;
esac

if [ -z "$x" ]; then
  case "$hpos" in
    left)   x="$((mon_x + gap))" ;;
    center) x="$((mon_x + (mon_w - win_w) / 2))" ;;
    right)  x="$((mon_x + mon_w - win_w - gap))" ;;
    "")     x="$cur_x" ;;
    *) usage ;;
  esac
fi

if [ -z "$y" ]; then
  case "$vpos" in
    top)    y="$((mon_y + gap))" ;;
    center) y="$((mon_y + (mon_h - win_h) / 2))" ;;
    bottom) y="$((mon_y + mon_h - win_h - gap))" ;;
    "")     y="$cur_y" ;;
    *) usage ;;
  esac
fi

hyprctl dispatch "hl.dsp.window.move({ x = $x, y = $y, exact = true })"

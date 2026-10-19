#!/usr/bin/env bash
set -euo pipefail

ratio=""
invert_ratio=0
width_mode=0
height_mode=0
width=""
height=""

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") [--ratio RATIO|NAME|constant] [--invert] [--width [PX|%]] [--height [PX|%]]

examples:
  $(basename "$0") --width 900
  $(basename "$0") --height 600
  $(basename "$0") --width 80%
  $(basename "$0") --width 1200 --height 800

  $(basename "$0") -r wide --width 80%
  $(basename "$0") -r 16x9 --height 900
  $(basename "$0") -r constant --width 80%
  $(basename "$0") -r constant --invert --height 900

ratios:
  constant     current window ratio
  wide         16x9
  ultrawide    21x9
  cinema       21x9
  classic       4x3
  square        1x1
  photo         3x2
  vertical      9x16
USAGE
  exit 2
}

ratio_fraction() {
  case "$1" in
    wide|video) echo "16/9" ;;
    ultrawide|cinema) echo "21/9" ;;
    classic) echo "4/3" ;;
    square) echo "1/1" ;;
    photo) echo "3/2" ;;
    vertical|portrait) echo "9/16" ;;

    *x*)
      awk -v r="$1" 'BEGIN { split(r,a,"x"); print a[1] "/" a[2] }'
      ;;

    *:*)
      awk -v r="$1" 'BEGIN { split(r,a,":"); print a[1] "/" a[2] }'
      ;;

    */*)
      echo "$1"
      ;;

    *)
      echo "$1/1"
      ;;
  esac
}

maybe_invert_fraction() {
  local frac="$1"

  if [ "$invert_ratio" -eq 1 ]; then
    awk -v r="$frac" '
      BEGIN {
        split(r, a, "/")
        print a[2] "/" a[1]
      }
    '
  else
    echo "$frac"
  fi
}

ratio_number() {
  awk -v r="$1" '
    BEGIN {
      split(r, a, "/")
      if (a[1] == 0 || a[2] == 0) exit 1
      print a[1] / a[2]
    }
  '
}

monitor_size() {
  local axis="$1"
  local active_json monitors_json mon_id mon_json

  active_json="$(hyprctl activewindow -j)"
  monitors_json="$(hyprctl monitors -j)"
  mon_id="$(jq -r '.monitor' <<< "$active_json")"
  mon_json="$(jq -c --argjson id "$mon_id" '.[] | select(.id == $id)' <<< "$monitors_json")"

  case "$axis" in
    width)  jq -r '.width' <<< "$mon_json" ;;
    height) jq -r '.height' <<< "$mon_json" ;;
    *) exit 2 ;;
  esac
}

resolve_size() {
  local value="$1"
  local axis="$2"
  local mon_size percent

  case "$value" in
    *%)
      percent="${value%\%}"
      mon_size="$(monitor_size "$axis")"
      awk -v size="$mon_size" -v pct="$percent" '
        BEGIN { printf "%d", size * pct / 100 }
      '
      ;;
    *)
      echo "$value"
      ;;
  esac
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -r|--ratio)
      shift
      [ "$#" -gt 0 ] || usage
      ratio="$1"
      shift
      ;;

    -i|--invert|--vertical)
      invert_ratio=1
      shift
      ;;

    -w|--width)
      width_mode=1
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        width="$(resolve_size "$1" width)"
        shift
      fi
      ;;

    -h|--height)
      height_mode=1
      shift
      if [ "${1:-}" != "" ] && [[ "${1:-}" != -* ]]; then
        height="$(resolve_size "$1" height)"
        shift
      fi
      ;;

    *)
      usage
      ;;
  esac
done

active_json="$(hyprctl activewindow -j)"
cur_w="$(jq -r '.size[0]' <<< "$active_json")"
cur_h="$(jq -r '.size[1]' <<< "$active_json")"

if [ -z "$ratio" ]; then
  # No ratio mode: resize only the explicitly requested axes.
  new_w="${width:-$cur_w}"
  new_h="${height:-$cur_h}"

else
  # Ratio mode: one axis is base, the other is computed.
  if [ "$ratio" = "constant" ] || [ "$ratio" = "current" ]; then
    r_frac="$cur_w/$cur_h"
  else
    r_frac="$(ratio_fraction "$ratio")"
  fi

  r_frac="$(maybe_invert_fraction "$r_frac")"
  r_num="$(ratio_number "$r_frac")"

  if [ -n "$width" ] && [ -n "$height" ]; then
    new_w="$width"
    new_h="$height"

  elif [ "$width_mode" -eq 1 ]; then
    base_w="${width:-$cur_w}"
    new_w="$base_w"
    new_h="$(awk -v w="$base_w" -v r="$r_num" 'BEGIN { printf "%d", w / r }')"

  else
    base_h="${height:-$cur_h}"
    new_h="$base_h"
    new_w="$(awk -v h="$base_h" -v r="$r_num" 'BEGIN { printf "%d", h * r }')"
  fi
fi

hyprctl dispatch "hl.dsp.window.resize({ x = $new_w, y = $new_h, exact = true })"

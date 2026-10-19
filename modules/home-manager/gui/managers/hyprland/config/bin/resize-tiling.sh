#!/usr/bin/env bash
set -euo pipefail

action="grow"
dir=""
step=40
debug=0
auto=0
target_mode=""
sign_mode=""

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") [--grow|--shrink] --left [PX]
  $(basename "$0") [--grow|--shrink] --right [PX]
  $(basename "$0") [--grow|--shrink] --up [PX]
  $(basename "$0") [--grow|--shrink] --down [PX]

override:
  $(basename "$0") --grow --right 40 --target active --sign +
  $(basename "$0") --shrink --left 40 --target neighbor --sign +

discovery:
  $(basename "$0") --auto --debug --grow --right 40

notes:
  Normal mode applies a fixed strategy table and never undoes.
  Auto mode is only for discovering target/sign.
USAGE
  exit 2
}

log() {
  if [ "$debug" -eq 1 ]; then
    echo "[resize-tiling] $*" >&2
  fi
}

dispatch() {
  log "dispatch: $1"
  hyprctl dispatch "$1" >/dev/null
}

normalize_addr() {
  local addr="${1:-}"
  addr="${addr#address:}"

  case "$addr" in
    "") return 1 ;;
    0x*|0X*) printf '%s\n' "$addr" ;;
    *) printf '0x%s\n' "$addr" ;;
  esac
}

window_json_by_addr() {
  local addr
  addr="$(normalize_addr "$1")"

  hyprctl clients -j \
    | jq -c --arg addr "$addr" '
        .[]
        | select((.address | ascii_downcase) == ($addr | ascii_downcase))
      '
}

window_geom() {
  local addr json
  addr="$(normalize_addr "$1")"
  json="$(window_json_by_addr "$addr")"

  [ -n "$json" ] || return 1

  jq -r '[.at[0], .at[1], .size[0], .size[1]] | @tsv' <<< "$json"
}

resize_window_relative() {
  local addr="$1"
  local dx="$2"
  local dy="$3"

  addr="$(normalize_addr "$addr")"

  dispatch "hl.dsp.window.resize({
    x = $dx,
    y = $dy,
    relative = true,
    window = \"address:$addr\"
  })"
}

find_neighbor() {
  local active_json clients_json
  local active_addr active_ws_name active_ws_id
  local ax ay aw ah

  active_json="$(hyprctl activewindow -j)"
  clients_json="$(hyprctl clients -j)"

  active_addr="$(jq -r '.address // empty' <<< "$active_json")"
  active_ws_name="$(jq -r '.workspace.name // empty' <<< "$active_json")"
  active_ws_id="$(jq -r '.workspace.id // empty' <<< "$active_json")"

  ax="$(jq -r '.at[0]' <<< "$active_json")"
  ay="$(jq -r '.at[1]' <<< "$active_json")"
  aw="$(jq -r '.size[0]' <<< "$active_json")"
  ah="$(jq -r '.size[1]' <<< "$active_json")"

  jq -r \
    --arg dir "$dir" \
    --arg active_addr "$active_addr" \
    --arg ws_name "$active_ws_name" \
    --argjson ws_id "$active_ws_id" \
    --argjson ax "$ax" \
    --argjson ay "$ay" \
    --argjson aw "$aw" \
    --argjson ah "$ah" '
      def max(a;b): if a > b then a else b end;
      def min(a;b): if a < b then a else b end;
      def abs: if . < 0 then -. else . end;
      def cx($x; $w): $x + ($w / 2);
      def cy($y; $h): $y + ($h / 2);

      ($ax + $aw) as $ar |
      ($ay + $ah) as $ab |
      cx($ax; $aw) as $acx |
      cy($ay; $ah) as $acy |

      [
        .[]
        | select(.mapped == true)
        | select(.address != $active_addr)
        | select(.floating == false)
        | select((.fullscreen // 0) == 0)
        | select((.workspace.name == $ws_name) or (.workspace.id == $ws_id))

        | . as $c
        | ($c.at[0]) as $x
        | ($c.at[1]) as $y
        | ($c.size[0]) as $w
        | ($c.size[1]) as $h
        | ($x + $w) as $xr
        | ($y + $h) as $yb
        | cx($x; $w) as $ccx
        | cy($y; $h) as $ccy

        | if $dir == "left" then
            select($xr <= $ax)
            | (min($ab; $yb) - max($ay; $y)) as $overlap
            | select($overlap > 0)
            | {
                address: .address,
                distance: ($ax - $xr),
                overlap: $overlap,
                center_distance: (($acy - $ccy) | abs)
              }

          elif $dir == "right" then
            select($x >= $ar)
            | (min($ab; $yb) - max($ay; $y)) as $overlap
            | select($overlap > 0)
            | {
                address: .address,
                distance: ($x - $ar),
                overlap: $overlap,
                center_distance: (($acy - $ccy) | abs)
              }

          elif $dir == "up" then
            select($yb <= $ay)
            | (min($ar; $xr) - max($ax; $x)) as $overlap
            | select($overlap > 0)
            | {
                address: .address,
                distance: ($ay - $yb),
                overlap: $overlap,
                center_distance: (($acx - $ccx) | abs)
              }

          elif $dir == "down" then
            select($y >= $ab)
            | (min($ar; $xr) - max($ax; $x)) as $overlap
            | select($overlap > 0)
            | {
                address: .address,
                distance: ($y - $ab),
                overlap: $overlap,
                center_distance: (($acx - $ccx) | abs)
              }

          else
            empty
          end
      ]
      | sort_by(.distance, - .overlap, .center_distance)
      | .[0].address // empty
    ' <<< "$clients_json"
}

default_strategy() {
  case "$action:$dir" in
    grow:left)    echo "neighbor -" ;;
    grow:right)   echo "active +" ;;
    grow:up)      echo "neighbor -" ;;
    grow:down)    echo "active +" ;;

    shrink:left)  echo "neighbor +" ;;
    shrink:right) echo "active -" ;;
    shrink:up)    echo "neighbor +" ;;
    shrink:down)  echo "active -" ;;

    *) usage ;;
  esac
}

axis_delta() {
  local sign="$1"
  local dx=0
  local dy=0

  case "$sign" in
    +|+1|1) sign=1 ;;
    -|-1)   sign=-1 ;;
    *) echo "invalid sign: $sign" >&2; exit 2 ;;
  esac

  case "$dir" in
    left|right) dx="$((sign * step))" ;;
    up|down)    dy="$((sign * step))" ;;
    *) usage ;;
  esac

  printf '%s %s\n' "$dx" "$dy"
}

wanted_change_happened() {
  local old_x="$1"
  local old_y="$2"
  local old_w="$3"
  local old_h="$4"
  local new_x="$5"
  local new_y="$6"
  local new_w="$7"
  local new_h="$8"

  local old_r old_b new_r new_b

  old_r="$((old_x + old_w))"
  old_b="$((old_y + old_h))"
  new_r="$((new_x + new_w))"
  new_b="$((new_y + new_h))"

  case "$action:$dir" in
    grow:left)     [ "$new_x" -lt "$old_x" ] && [ "$new_w" -gt "$old_w" ] ;;
    grow:right)    [ "$new_r" -gt "$old_r" ] && [ "$new_w" -gt "$old_w" ] ;;
    grow:up)       [ "$new_y" -lt "$old_y" ] && [ "$new_h" -gt "$old_h" ] ;;
    grow:down)     [ "$new_b" -gt "$old_b" ] && [ "$new_h" -gt "$old_h" ] ;;

    shrink:left)   [ "$new_x" -gt "$old_x" ] && [ "$new_w" -lt "$old_w" ] ;;
    shrink:right)  [ "$new_r" -lt "$old_r" ] && [ "$new_w" -lt "$old_w" ] ;;
    shrink:up)     [ "$new_y" -gt "$old_y" ] && [ "$new_h" -lt "$old_h" ] ;;
    shrink:down)   [ "$new_b" -lt "$old_b" ] && [ "$new_h" -lt "$old_h" ] ;;

    *) return 1 ;;
  esac
}

direct_apply() {
  local active_addr="$1"
  local neighbor_addr="$2"
  local target_kind sign target_addr dx dy

  if [ -n "$target_mode" ] || [ -n "$sign_mode" ]; then
    [ -n "$target_mode" ] || {
      echo "--target is required when overriding strategy" >&2
      exit 2
    }
    [ -n "$sign_mode" ] || {
      echo "--sign is required when overriding strategy" >&2
      exit 2
    }

    target_kind="$target_mode"
    sign="$sign_mode"
  else
    read -r target_kind sign < <(default_strategy)
  fi

  case "$target_kind" in
    active)
      target_addr="$active_addr"
      ;;

    neighbor)
      [ -n "$neighbor_addr" ] || {
        echo "no tiled neighbor in direction: $dir" >&2
        exit 1
      }
      target_addr="$neighbor_addr"
      ;;

    *)
      echo "invalid target: $target_kind" >&2
      exit 2
      ;;
  esac

  read -r dx dy < <(axis_delta "$sign")

  log "action=$action dir=$dir step=$step"
  log "target_kind=$target_kind target=$target_addr sign=$sign dx=$dx dy=$dy"

  resize_window_relative "$target_addr" "$dx" "$dy"
}

candidate_order() {
  case "$action:$dir" in
    grow:left)
      printf 'neighbor -\n'
      printf 'neighbor +\n'
      printf 'active -\n'
      printf 'active +\n'
      ;;

    grow:right)
      printf 'active +\n'
      printf 'active -\n'
      printf 'neighbor +\n'
      printf 'neighbor -\n'
      ;;

    grow:up)
      printf 'neighbor -\n'
      printf 'neighbor +\n'
      printf 'active -\n'
      printf 'active +\n'
      ;;

    grow:down)
      printf 'active +\n'
      printf 'active -\n'
      printf 'neighbor +\n'
      printf 'neighbor -\n'
      ;;

    shrink:left)
      printf 'neighbor +\n'
      printf 'neighbor -\n'
      printf 'active +\n'
      printf 'active -\n'
      ;;

    shrink:right)
      printf 'active -\n'
      printf 'active +\n'
      printf 'neighbor -\n'
      printf 'neighbor +\n'
      ;;

    shrink:up)
      printf 'neighbor +\n'
      printf 'neighbor -\n'
      printf 'active +\n'
      printf 'active -\n'
      ;;

    shrink:down)
      printf 'active -\n'
      printf 'active +\n'
      printf 'neighbor -\n'
      printf 'neighbor +\n'
      ;;

    *)
      usage
      ;;
  esac
}

try_candidate() {
  local target_kind="$1"
  local sign="$2"
  local active_addr="$3"
  local neighbor_addr="$4"
  local old_x="$5"
  local old_y="$6"
  local old_w="$7"
  local old_h="$8"

  local target_addr dx dy new_x new_y new_w new_h

  case "$target_kind" in
    active)
      target_addr="$active_addr"
      ;;

    neighbor)
      [ -n "$neighbor_addr" ] || return 1
      target_addr="$neighbor_addr"
      ;;

    *)
      return 1
      ;;
  esac

  read -r dx dy < <(axis_delta "$sign")

  log "try target=$target_kind addr=$target_addr sign=$sign dx=$dx dy=$dy"

  resize_window_relative "$target_addr" "$dx" "$dy"
  sleep 0.025

  read -r new_x new_y new_w new_h < <(window_geom "$active_addr")

  log "active old=${old_x},${old_y},${old_w},${old_h}"
  log "active new=${new_x},${new_y},${new_w},${new_h}"

  if wanted_change_happened \
    "$old_x" "$old_y" "$old_w" "$old_h" \
    "$new_x" "$new_y" "$new_w" "$new_h"
  then
    echo "--target $target_kind --sign $sign"
    return 0
  fi

  log "failed target=$target_kind sign=$sign; undoing"

  resize_window_relative "$target_addr" "$((-dx))" "$((-dy))"
  sleep 0.025

  return 1
}

auto_discover() {
  local active_addr="$1"
  local neighbor_addr="$2"
  local old_x old_y old_w old_h

  read -r old_x old_y old_w old_h < <(window_geom "$active_addr")

  while read -r target_kind sign; do
    [ -n "$target_kind" ] || continue

    if try_candidate \
      "$target_kind" "$sign" \
      "$active_addr" "$neighbor_addr" \
      "$old_x" "$old_y" "$old_w" "$old_h"
    then
      exit 0
    fi
  done < <(candidate_order)

  echo "could not discover operation for $action $dir with step=$step" >&2
  exit 1
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

    --target)
      shift
      [ "$#" -gt 0 ] || usage
      case "$1" in
        active|neighbor) target_mode="$1" ;;
        *) usage ;;
      esac
      shift
      ;;

    --sign)
      shift
      [ "$#" -gt 0 ] || usage
      case "$1" in
        +|+1|1) sign_mode="+" ;;
        -|-1)   sign_mode="-" ;;
        *) usage ;;
      esac
      shift
      ;;

    --auto)
      auto=1
      shift
      ;;

    --debug)
      debug=1
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

active_json="$(hyprctl activewindow -j)"
active_addr="$(jq -r '.address // empty' <<< "$active_json")"

[ -n "$active_addr" ] && [ "$active_addr" != "null" ] || {
  echo "could not determine active window" >&2
  exit 1
}

active_addr="$(normalize_addr "$active_addr")"

if [ "$(jq -r '.floating // false' <<< "$active_json")" = "true" ]; then
  echo "active window is floating; this script is for tiled windows" >&2
  exit 1
fi

neighbor_addr="$(find_neighbor)"
neighbor_addr="$(normalize_addr "$neighbor_addr" 2>/dev/null || true)"

log "active=$active_addr"
log "neighbor=${neighbor_addr:-none}"

if [ "$auto" -eq 1 ]; then
  auto_discover "$active_addr" "$neighbor_addr"
else
  direct_apply "$active_addr" "$neighbor_addr"
fi

#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") l|r|u|d|left|right|up|down [PX]
  $(basename "$0") l|r|u|d --step PX

examples:
  $(basename "$0") l
  $(basename "$0") r 40
  $(basename "$0") up --step 20

behavior:
  floating window:
    move by PX in the requested direction

  tiled window:
    if moving into a grouped window, join group
    else if there is a window in that direction, swap
    else if there is a monitor in that direction, move to that monitor
    else fallback to swap
USAGE
  exit 2
}

[ "$#" -gt 0 ] || usage

dir="$1"
shift

case "$dir" in
  l|left)  dir="l" ;;
  r|right) dir="r" ;;
  u|up)    dir="u" ;;
  d|down)  dir="d" ;;
  *)
    echo "Invalid direction: $dir" >&2
    exit 2
    ;;
esac

step=40

while [ "$#" -gt 0 ]; do
  case "$1" in
    --step|-s)
      shift
      [ "$#" -gt 0 ] || usage
      step="$1"
      shift
      ;;

    *)
      if [[ "$1" =~ ^[0-9]+$ ]]; then
        step="$1"
        shift
      else
        usage
      fi
      ;;
  esac
done

case "$step" in
  ''|*[!0-9]*)
    echo "Invalid step: $step" >&2
    exit 2
    ;;
esac

active_json="$(hyprctl activewindow -j)"

active_addr="$(jq -r '.address' <<< "$active_json")"
active_ws_name="$(jq -r '.workspace.name' <<< "$active_json")"
active_ws_id="$(jq -r '.workspace.id' <<< "$active_json")"

ax="$(jq -r '.at[0]' <<< "$active_json")"
ay="$(jq -r '.at[1]' <<< "$active_json")"
aw="$(jq -r '.size[0]' <<< "$active_json")"
ah="$(jq -r '.size[1]' <<< "$active_json")"

floating="$(jq -r '.floating // false' <<< "$active_json")"

if [ "$floating" = "true" ]; then
  new_x="$ax"
  new_y="$ay"

  case "$dir" in
    l) new_x="$((ax - step))" ;;
    r) new_x="$((ax + step))" ;;
    u) new_y="$((ay - step))" ;;
    d) new_y="$((ay + step))" ;;
    *) usage ;;
  esac

  hyprctl dispatch "hl.dsp.window.move({ x = $new_x, y = $new_y, exact = true })"
  exit 0
fi

clients_json="$(hyprctl clients -j)"
monitors_json="$(hyprctl monitors -j)"

target_info="$(
  jq -r \
    --arg dir "$dir" \
    --arg active_addr "$active_addr" \
    --arg ws_name "$active_ws_name" \
    --argjson ws_id "$active_ws_id" \
    --argjson ax "$ax" \
    --argjson ay "$ay" \
    --argjson aw "$aw" \
    --argjson ah "$ah" \
    --slurpfile active <(printf '%s\n' "$active_json") '
      def abs: if . < 0 then -. else . end;
      def cx($x; $w): $x + ($w / 2);
      def cy($y; $h): $y + ($h / 2);

      ($active[0].grouped // []) as $active_group |

      ($ax + $aw) as $ar |
      ($ay + $ah) as $ab |
      cx($ax; $aw) as $acx |
      cy($ay; $ah) as $acy |

      [
        .[]
        | select(.mapped == true)
        | select(.address != $active_addr)

        # Ignore windows already inside the active group.
        | select((.address as $addr | $active_group | index($addr)) | not)

        # Restrict candidates to the same workspace.
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

        | if $dir == "l" then
            select($ccx < $acx)
            | {
                grouped: ((.grouped // []) | length),
                primary: (($ax - $xr) | if . < 0 then 0 else . end),
                secondary: (($acy - $ccy) | abs)
              }

          elif $dir == "r" then
            select($ccx > $acx)
            | {
                grouped: ((.grouped // []) | length),
                primary: (($x - $ar) | if . < 0 then 0 else . end),
                secondary: (($acy - $ccy) | abs)
              }

          elif $dir == "u" then
            select($ccy < $acy)
            | {
                grouped: ((.grouped // []) | length),
                primary: (($ay - $yb) | if . < 0 then 0 else . end),
                secondary: (($acx - $ccx) | abs)
              }

          elif $dir == "d" then
            select($ccy > $acy)
            | {
                grouped: ((.grouped // []) | length),
                primary: (($y - $ab) | if . < 0 then 0 else . end),
                secondary: (($acx - $ccx) | abs)
              }

          else
            empty
          end
      ]
      | sort_by(.primary, .secondary)
      | if length == 0 then
          "none"
        elif (($active[0].grouped // []) | length) > 0 and .[0].grouped > 0 then
          "group"
        else
          "window"
        end
    ' <<< "$clients_json"
)"

monitor_in_direction="$(
  jq -r \
    --arg dir "$dir" '
      def cx: .x + (.width / 2);
      def cy: .y + (.height / 2);

      (.[] | select(.focused == true)) as $m |
      ($m | cx) as $mcx |
      ($m | cy) as $mcy |

      [
        .[]
        | select(.id != $m.id)
        | if $dir == "l" then
            select(cx < $mcx)
          elif $dir == "r" then
            select(cx > $mcx)
          elif $dir == "u" then
            select(cy < $mcy)
          elif $dir == "d" then
            select(cy > $mcy)
          else
            empty
          end
      ]
      | if length > 0 then "yes" else "no" end
    ' <<< "$monitors_json"
)"

lua_dir="$(jq -Rn -r --arg s "$dir" '$s | @json')"

case "$target_info" in
  group)
    hyprctl eval "
      hl.dispatch(
        hl.dsp.window.move({
          into_group = $lua_dir,
        })
      )
    "
    ;;

  window)
    hyprctl eval "
      hl.dispatch(
        hl.dsp.window.swap({
          direction = $lua_dir,
        })
      )
    "
    ;;

  none)
    if [[ "$monitor_in_direction" == "yes" ]]; then
      hyprctl eval "
        hl.dispatch(
          hl.dsp.window.move({
            direction = $lua_dir,
          })
        )
      "
    else
      hyprctl eval "
        hl.dispatch(
          hl.dsp.window.swap({
            direction = $lua_dir,
          })
        )
      "
    fi
    ;;

  *)
    echo "Internal error: unexpected target_info=$target_info" >&2
    exit 1
    ;;
esac

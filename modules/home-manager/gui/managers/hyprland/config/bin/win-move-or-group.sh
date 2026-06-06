#!/usr/bin/env bash
set -euo pipefail

dir="${1:?usage: joinable_move.sh l|r|u|d|left|right|up|down}"

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

active_json="$(hyprctl activewindow -j)"
clients_json="$(hyprctl clients -j)"

active_addr="$(jq -r '.address' <<< "$active_json")"
active_ws_name="$(jq -r '.workspace.name' <<< "$active_json")"
active_ws_id="$(jq -r '.workspace.id' <<< "$active_json")"

active_group_len="$(jq -r '(.grouped // []) | length' <<< "$active_json")"

ax="$(jq -r '.at[0]' <<< "$active_json")"
ay="$(jq -r '.at[1]' <<< "$active_json")"
aw="$(jq -r '.size[0]' <<< "$active_json")"
ah="$(jq -r '.size[1]' <<< "$active_json")"

action="move"

if (( active_group_len > 0 )); then
  target_group_len="$(
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

          # CRUCIAL: ignore qualquer janela que já pertence ao grupo ativo
          | select((.address as $addr | $active_group | index($addr)) | not)

          | select((.workspace.name == $ws_name) or (.workspace.id == $ws_id))

          # Só considera alvos que já são grupos
          | select(((.grouped // []) | length) > 0)

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
                  primary: (($ax - $xr) | if . < 0 then 0 else . end),
                  secondary: (($acy - $ccy) | abs)
                }

            elif $dir == "r" then
              select($ccx > $acx)
              | {
                  primary: (($x - $ar) | if . < 0 then 0 else . end),
                  secondary: (($acy - $ccy) | abs)
                }

            elif $dir == "u" then
              select($ccy < $acy)
              | {
                  primary: (($ay - $yb) | if . < 0 then 0 else . end),
                  secondary: (($acx - $ccx) | abs)
                }

            elif $dir == "d" then
              select($ccy > $acy)
              | {
                  primary: (($y - $ab) | if . < 0 then 0 else . end),
                  secondary: (($acx - $ccx) | abs)
                }

            else
              empty
            end
        ]
        | sort_by(.primary, .secondary)
        | if length > 0 then 1 else 0 end
      ' <<< "$clients_json"
  )"

  if (( target_group_len > 0 )); then
    action="join"
  fi
fi

lua_dir="$(jq -Rn -r --arg s "$dir" '$s | @json')"

case "$action" in
  join)
    hyprctl eval "
      hl.dispatch(
        hl.dsp.window.move({
          into_group = $lua_dir,
        })
      )
    "
    ;;
  move)
    hyprctl eval "
      hl.dispatch(
        hl.dsp.window.move({
          direction = $lua_dir,
        })
      )
    "
    ;;
esac

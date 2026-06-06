#!/usr/bin/env bash
set -euo pipefail

mode="${1:-normal}"

active_json="$(hyprctl activewindow -j)"
group_len="$(jq -r '(.grouped // []) | length' <<< "$active_json")"

case "$mode" in
  normal) if (( group_len > 0 ))
    then
      # Já está em grupo:
      # remove a tab ativa para a esquerda
      hyprctl eval '
        hl.dispatch(
          hl.dsp.window.move({
            out_of_group = true,
          })
        )
      '
    else
      hyprctl eval '
        hl.dispatch(
          hl.dsp.group.toggle()
        )
      '
    fi ;;

  toggle-out) if (( group_len > 0 ))
    then
      hyprctl eval '
        hl.dispatch(
          hl.dsp.group.toggle()
        )
      '
    fi ;;
esac

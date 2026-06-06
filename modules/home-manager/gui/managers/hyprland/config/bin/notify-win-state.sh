#!/usr/bin/env bash

set -euo pipefail

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

require_cmd hyprctl
require_cmd jq
require_cmd notify-send

win="$(hyprctl activewindow -j)"

if jq -e 'length == 0 or .address == null' >/dev/null <<< "$win"; then
  msg="No active window."
  notify-send "Hyprland window info" "$msg"
  echo "$msg"
  exit 0
fi

jq_get() {
  local filter="$1"
  local fallback="${2:-?}"
  jq -r "$filter // \"$fallback\"" <<< "$win"
}

jq_bool() {
  local filter="$1"
  jq -r "$filter // false" <<< "$win"
}

jq_array_join() {
  local filter="$1"
  jq -r "$filter // [] | if length == 0 then \"none\" else join(\", \") end" <<< "$win"
}

state_name() {
  case "$1" in
    0) echo "none" ;;
    1) echo "maximized" ;;
    2) echo "fullscreen" ;;
    3) echo "maximized+fullscreen" ;;
    *) echo "unknown($1)" ;;
  esac
}

address="$(jq_get '.address')"
class="$(jq_get '.class')"
initial_class="$(jq_get '.initialClass')"
title="$(jq_get '.title')"
initial_title="$(jq_get '.initialTitle')"

workspace_id="$(jq_get '.workspace.id')"
workspace_name="$(jq_get '.workspace.name')"
monitor="$(jq_get '.monitor')"

pid="$(jq_get '.pid')"
xwayland="$(jq_bool '.xwayland')"
mapped="$(jq_bool '.mapped')"
hidden="$(jq_bool '.hidden')"

floating="$(jq_bool '.floating')"
pinned="$(jq_bool '.pinned')"
fullscreen="$(jq_get '.fullscreen' 0)"
fullscreen_client="$(jq_get '.fullscreenClient' 0)"
pseudo="$(jq_bool '.pseudo')"

focus_history_id="$(jq_get '.focusHistoryID')"

at="$(jq -r '.at // [] | if length == 2 then "\(.[0]), \(.[1])" else "?" end' <<< "$win")"
size="$(jq -r '.size // [] | if length == 2 then "\(.[0]) x \(.[1])" else "?" end' <<< "$win")"

tags="$(jq_array_join '.tags')"
is_marked="$(jq -r '(.tags // []) | index("marked") != null' <<< "$win")"

grouped="$(jq_array_join '.grouped')"
swallowing="$(jq_get '.swallowing' 'none')"

fullscreen_name="$(state_name "$fullscreen")"
fullscreen_client_name="$(state_name "$fullscreen_client")"

msg="$(
cat <<EOF
# identity
address: $address
class: $class
initial class: $initial_class
title: $title
initial title: $initial_title
pID: $pid
xWayland: $xwayland

# tags
tags: $tags
marked: $is_marked

# placement
workspace: $workspace_name ($workspace_id)
monitor: $monitor
position: $at
size: $size
focus history ID: $focus_history_id

# state
mapped: $mapped
hidden: $hidden
floating: $floating
pinned: $pinned
pseudo: $pseudo
fullscreen: $fullscreen ($fullscreen_name)
fullscreen client: $fullscreen_client ($fullscreen_client_name)

# grouping
grouped with: $grouped
swallowing: $swallowing
EOF
)"

notify-send "Hyprland window info" "$msg"
echo "$msg"

echo
echo "=== activewindow ==="
hyprctl -j activewindow | jq

echo
echo "=== monitors ==="
hyprctl -j monitors | jq '.[] | {
  id,
  name,
  description,
  focused,
  x,
  y,
  width,
  height,
  scale,
  transform,
  activeWorkspace,
  specialWorkspace,
  reserved,
  focused,
  dpmsStatus,
  vrr
}'

echo
echo "=== clients summary ==="
hyprctl -j clients | jq '.[] | {
  address,
  class,
  title,
  tags: (.tags // []),
  workspace: .workspace,
  monitor,
  floating,
  fullscreen,
  fullscreenClient,
  pinned,
  grouped: (.grouped // []),
  focusHistoryID,
  mapped,
  hidden,
  pid,
  xwayland
}'

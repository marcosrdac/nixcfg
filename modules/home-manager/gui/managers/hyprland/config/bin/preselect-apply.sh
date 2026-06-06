#!/usr/bin/env bash
set -u

log() {
  echo "[preselect] $*" >&2
}

fail() {
  log "error: $*"
  exit 1
}

clients_json() {
  hyprctl clients -j
}

dispatch_expr() {
  local expr="$1"
  log "expr: $expr"
  hyprctl dispatch "$expr"
}

focus_addr() {
  local addr="$1"
  dispatch_expr "hl.dsp.focus({ window = \"address:$addr\" })"
}

layout_preselect() {
  local dir="$1"
  dispatch_expr "hl.dsp.layout.msg({ msg = \"preselect $dir\" })"
}

move_focused_to_workspace() {
  local ws="$1"
  dispatch_expr "hl.dsp.window.move({ workspace = \"$ws\", follow = false })"
}

untag_current() {
  local tag="$1"
  dispatch_expr "hl.dsp.window.tag({ tag = \"-$tag\" })"
}

clear_current_preselect_tags() {
  untag_current "preselect-left"
  untag_current "preselect-right"
  untag_current "preselect-up"
  untag_current "preselect-down"
}

clear_parent_tags() {
  local parent_addr="$1"

  log "clear parent preselect tags"
  focus_addr "$parent_addr"
  clear_current_preselect_tags
}

clear_child_tags() {
  local child_addr="$1"

  log "clear child marked tag"
  focus_addr "$child_addr"
  untag_current "marked"
}

refresh_child_addr_by_stable_id() {
  local stable_id="$1"

  clients_json | jq -r --arg stable_id "$stable_id" '
    .[]
    | select(.stableId == $stable_id)
    | .address
  ' | head -n 1
}

parent_json="$(
  clients_json | jq -c '
    .[]
    | select((.tags // []) | any(test("^preselect-")))
  ' | head -n 1
)"

child_json="$(
  clients_json | jq -c '
    .[]
    | select((.tags // []) | index("marked"))
  ' | head -n 1
)"

log "parent_json=$parent_json"
log "child_json=$child_json"

[ -n "$parent_json" ] || fail "no parent with preselect-* tag"
[ -n "$child_json" ] || fail "no child with marked tag"

parent_addr="$(echo "$parent_json" | jq -r '.address')"
child_addr="$(echo "$child_json" | jq -r '.address')"
child_stable_id="$(echo "$child_json" | jq -r '.stableId')"
parent_ws="$(echo "$parent_json" | jq -r '.workspace.name')"

dir="$(
  echo "$parent_json" \
    | jq -r '.tags[] | select(test("^preselect-"))' \
    | head -n 1 \
    | sed 's/^preselect-//'
)"

case "$dir" in
  left)  hdir="l" ;;
  right) hdir="r" ;;
  up)    hdir="u" ;;
  down)  hdir="d" ;;
  *) fail "invalid preselect direction: $dir" ;;
esac

log "parent_addr=$parent_addr"
log "child_addr=$child_addr"
log "child_stable_id=$child_stable_id"
log "parent_ws=$parent_ws"
log "dir=$dir hdir=$hdir"

[ "$parent_addr" != "$child_addr" ] || fail "parent and child are the same window"

tmp_ws="special:__preselect_tmp"

# -------------------------------------------------------------------
# Apply by reinsertion
# -------------------------------------------------------------------
#
# 1. Remove child from current tiling tree.
# 2. Focus parent.
# 3. Set Dwindle preselect on parent.
# 4. Reinsert child into parent's workspace.
# 5. Clean both roles.
# -------------------------------------------------------------------

log "move child to temporary workspace"
focus_addr "$child_addr"
move_focused_to_workspace "$tmp_ws"

# The address should usually remain stable, but refresh defensively.
new_child_addr="$(refresh_child_addr_by_stable_id "$child_stable_id")"
if [ -n "$new_child_addr" ] && [ "$new_child_addr" != "null" ]; then
  child_addr="$new_child_addr"
fi

log "focus parent and set preselect"
focus_addr "$parent_addr"
layout_preselect "$hdir"

log "move child back to parent workspace"
focus_addr "$child_addr"
move_focused_to_workspace "$parent_ws"

# Again refresh defensively before cleanup/focus.
new_child_addr="$(refresh_child_addr_by_stable_id "$child_stable_id")"
if [ -n "$new_child_addr" ] && [ "$new_child_addr" != "null" ]; then
  child_addr="$new_child_addr"
fi

# -------------------------------------------------------------------
# Cleanup
# -------------------------------------------------------------------

clear_parent_tags "$parent_addr"
clear_child_tags "$child_addr"

focus_addr "$child_addr"

log "done"

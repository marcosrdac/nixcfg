#!/usr/bin/env bash
set -euo pipefail

MARK_TAG="${MARK_TAG:-marked}"
PLACEHOLDER_COLOR="${PLACEHOLDER_COLOR:-#000000}"
PLACEHOLDER_ALPHA="${PLACEHOLDER_ALPHA:-1}"
PLACEHOLDER_CMD="${PLACEHOLDER_CMD:-window-placeholder.sh}"
PLACEHOLDER_TITLE="${PLACEHOLDER_TITLE:-window-placeholder}"
PLACEHOLDER_TIMEOUT="${PLACEHOLDER_TIMEOUT:-5}"
WAIT_TRIES="${WAIT_TRIES:-80}"
WAIT_SLEEP="${WAIT_SLEEP:-0.025}"

log() { echo "[placeholder-move] $*" >&2; }
fail() { log "error: $*"; exit 1; }

usage() {
  cat >&2 <<USAGE
usage:
  placeholder-move.sh set h|j|k|l [color] [alpha] [timeout]
  placeholder-move.sh apply
USAGE
  exit 2
}

clients_json() { hyprctl clients -j; }
active_json() { hyprctl activewindow -j; }

dispatch() {
  log "dispatch: $1"
  hyprctl dispatch "$1"
}

focus_addr() {
  dispatch "hl.dispatch(hl.dsp.focus({ window = \"address:$1\" }))"
}

placeholder_jq_filter='select(
  (.title == $title)
  or (.initialTitle == $title)
  or (.class == $title)
  or (.initialClass == $title)
)'

get_placeholder_jsons() {
  clients_json | jq -c --arg title "$PLACEHOLDER_TITLE" "
    .[]
    | select(.mapped == true)
    | $placeholder_jq_filter
  "
}

get_placeholder_count() {
  get_placeholder_jsons | jq -s 'length'
}

get_one_placeholder_json() {
  get_placeholder_jsons | jq -s 'if length == 1 then .[0] else empty end'
}

get_marked_count() {
  clients_json | jq -r --arg tag "$MARK_TAG" '
    [
      .[]
      | select(.mapped == true)
      | select((.tags // []) | index($tag))
    ]
    | length
  '
}

get_one_marked_json() {
  clients_json | jq -c --arg tag "$MARK_TAG" '
    [
      .[]
      | select(.mapped == true)
      | select((.tags // []) | index($tag))
    ]
    | if length == 1 then .[0] else empty end
  '
}

is_alive_addr() {
  local addr="$1"
  clients_json | jq -e --arg addr "$addr" 'any(.[]; .address == $addr)' >/dev/null
}

kill_window_by_addr_pid() {
  local addr="$1"
  local pid="${2:-}"

  log "kill addr=$addr pid=$pid"

  if [ -n "$pid" ] && [ "$pid" != "null" ] && kill -0 "$pid" 2>/dev/null; then
    kill "$pid" 2>/dev/null || true
  else
    hyprctl dispatch closewindow "address:$addr" >/dev/null 2>&1 || true
  fi

  sleep 0.05

  if is_alive_addr "$addr"; then
    if [ -n "$pid" ] && [ "$pid" != "null" ] && kill -0 "$pid" 2>/dev/null; then
      kill -9 "$pid" 2>/dev/null || true
    else
      hyprctl dispatch killwindow "address:$addr" >/dev/null 2>&1 || true
    fi
  fi
}

kill_all_placeholders() {
  local json addr pid

  while IFS= read -r json; do
    [ -n "$json" ] || continue
    addr="$(jq -r '.address' <<< "$json")"
    pid="$(jq -r '.pid // empty' <<< "$json")"
    [ -n "$addr" ] && [ "$addr" != "null" ] && kill_window_by_addr_pid "$addr" "$pid"
  done < <(get_placeholder_jsons)
}

wait_one_placeholder() {
  local i count json

  for ((i = 0; i < WAIT_TRIES; i++)); do
    count="$(get_placeholder_count)"

    if [ "$count" -eq 1 ]; then
      json="$(get_one_placeholder_json)"
      [ -n "$json" ] && printf '%s\n' "$json"
      return 0
    fi

    sleep "$WAIT_SLEEP"
  done

  fail "placeholder did not appear as exactly one window"
}

place() {
  local dir="${1:-}"
  local color="${2:-$PLACEHOLDER_COLOR}"
  local alpha="${3:-$PLACEHOLDER_ALPHA}"
  local timeout_s="${4:-$PLACEHOLDER_TIMEOUT}"
  local hdir parent_addr

  case "$dir" in
    h|left)  hdir="l" ;;
    j|down)  hdir="d" ;;
    k|up)    hdir="u" ;;
    l|right) hdir="r" ;;
    *) usage ;;
  esac

  parent_addr="$(active_json | jq -r '.address // empty')"
  [ -n "$parent_addr" ] && [ "$parent_addr" != "null" ] || fail "no active parent window"

  # evita ter dois placeholders depois
  kill_all_placeholders

  # matar placeholder antigo pode mudar foco; restaura parent
  if is_alive_addr "$parent_addr"; then
    focus_addr "$parent_addr"
  fi

  dispatch "hl.dispatch(hl.dsp.layout(\"preselect $hdir\"))"

  if [ -n "$timeout_s" ]; then
    setsid -f "$PLACEHOLDER_CMD" "$color" "$alpha" "$timeout_s" >/dev/null 2>&1
  else
    setsid -f "$PLACEHOLDER_CMD" "$color" "$alpha" >/dev/null 2>&1
  fi
}

apply() {
  local marked_count placeholder_count source_json source_is_marked
  local source_addr placeholder_json placeholder_addr placeholder_pid

  marked_count="$(get_marked_count)"
  [ "$marked_count" -le 1 ] || fail "expected at most one marked window, got $marked_count"

  if [ "$marked_count" -eq 1 ]; then
    source_json="$(get_one_marked_json)"
    source_is_marked=1
  else
    source_json="$(active_json)"
    source_is_marked=0
  fi

  source_addr="$(jq -r '.address // empty' <<< "$source_json")"
  [ -n "$source_addr" ] && [ "$source_addr" != "null" ] || fail "could not determine source window"

  placeholder_count="$(get_placeholder_count)"
  [ "$placeholder_count" -le 1 ] || fail "expected at most one placeholder, got $placeholder_count"

  if [ "$placeholder_count" -eq 0 ]; then
    if [ "$source_is_marked" -eq 1 ]; then
      log "no placeholder; spawning natural placeholder from active window"
      setsid -f "$PLACEHOLDER_CMD" "$PLACEHOLDER_COLOR" "$PLACEHOLDER_ALPHA" "$PLACEHOLDER_TIMEOUT" >/dev/null 2>&1
      placeholder_json="$(wait_one_placeholder)"
    else
      fail "no marked window and no placeholder"
    fi
  else
    placeholder_json="$(get_one_placeholder_json)"
  fi

  placeholder_addr="$(jq -r '.address // empty' <<< "$placeholder_json")"
  placeholder_pid="$(jq -r '.pid // empty' <<< "$placeholder_json")"

  [ -n "$placeholder_addr" ] && [ "$placeholder_addr" != "null" ] || fail "could not determine placeholder window"

  log "source_addr=$source_addr source_is_marked=$source_is_marked"
  log "placeholder_addr=$placeholder_addr placeholder_pid=$placeholder_pid"

  # se o marcado/ativo for o próprio placeholder, isso significa cancelar
  if [ "$source_addr" = "$placeholder_addr" ]; then
    kill_window_by_addr_pid "$placeholder_addr" "$placeholder_pid"
    exit 0
  fi

  focus_addr "$source_addr"
  dispatch "hl.dispatch(hl.dsp.window.swap({ target = \"address:$placeholder_addr\" }))"

  # O PID do placeholder continua sendo o mesmo depois do swap.
  kill_window_by_addr_pid "$placeholder_addr" "$placeholder_pid"

  if [ "$source_is_marked" -eq 1 ]; then
    focus_addr "$source_addr"
    dispatch "hl.dispatch(hl.dsp.window.tag({ tag = \"-$MARK_TAG\" }))"
  else
    focus_addr "$source_addr"
  fi
}

main() {
  local action="${1:-}"
  shift || true

  case "$action" in
    set) place "$@" ;;
    apply) apply ;;
    *) usage ;;
  esac
}

main "$@"

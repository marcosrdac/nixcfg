#!/usr/bin/env bash
set -euo pipefail

MARK_TAG="${MARK_TAG:-marked}"
PLACEHOLDER_TITLE="${PLACEHOLDER_TITLE:-window-placeholder}"
PLACEHOLDER_CMD="${PLACEHOLDER_CMD:-window-placeholder.sh}"
PLACEHOLDER_COLOR="${PLACEHOLDER_COLOR:-#000000}"
PLACEHOLDER_ALPHA="${PLACEHOLDER_ALPHA:-0.0}"
PLACEHOLDER_TIMEOUT="${PLACEHOLDER_TIMEOUT:-5}"
WAIT_TRIES="${WAIT_TRIES:-80}"
WAIT_SLEEP="${WAIT_SLEEP:-0.025}"
WATCH_POLL_SLEEP="${WATCH_POLL_SLEEP:-0.05}"

SCRIPT_SELF="$(readlink -f "${BASH_SOURCE[0]}")"

log() { echo "[teleport-window] $*" >&2; }
fail() { log "error: $*"; exit 1; }

usage() {
  cat >&2 <<USAGE
usage:
  $(basename "$0") --placeholder l|r|u|d [--color COLOR] [--alpha ALPHA] [--timeout SECONDS]
  $(basename "$0") --apply

internal:
  $(basename "$0") --watch PLACEHOLDER_ADDR PLACEHOLDER_PID TIMEOUT BASELINE_FILE
USAGE
  exit 2
}

clients_json() { hyprctl clients -j; }
active_json() { hyprctl activewindow -j; }

dispatch() {
  log "dispatch: $1"
  hyprctl dispatch "$1"
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

same_addr() {
  local a b
  a="$(normalize_addr "$1" 2>/dev/null || true)"
  b="$(normalize_addr "$2" 2>/dev/null || true)"
  [ -n "$a" ] && [ -n "$b" ] && [ "${a,,}" = "${b,,}" ]
}

focus_addr() {
  local addr
  addr="$(normalize_addr "$1")"
  dispatch "hl.dsp.focus({ window = \"address:$addr\" })"
}

hypr_instance_dir() {
  local xdg_runtime="${XDG_RUNTIME_DIR:-}"
  local his="${HYPRLAND_INSTANCE_SIGNATURE:-}"

  [ -n "$xdg_runtime" ] || fail "XDG_RUNTIME_DIR is not set"
  [ -n "$his" ] || fail "HYPRLAND_INSTANCE_SIGNATURE is not set"

  printf '%s/hypr/%s\n' "$xdg_runtime" "$his"
}

state_dir() {
  local dir
  dir="$(hypr_instance_dir)/teleport-window"
  mkdir -p "$dir"
  printf '%s\n' "$dir"
}

socket2_path() {
  printf '%s/.socket2.sock\n' "$(hypr_instance_dir)"
}

watcher_pid_file() {
  printf '%s/watcher.pid\n' "$(state_dir)"
}

watcher_log_file() {
  printf '%s/watcher.log\n' "$(state_dir)"
}

baseline_file() {
  printf '%s/before-addrs.json\n' "$(state_dir)"
}

now_ms() {
  date +%s%3N
}

mapped_addrs_json() {
  clients_json | jq -c '
    [
      .[]
      | select(.mapped == true)
      | .address
      | ascii_downcase
    ]
  '
}

find_new_window_since() {
  local before_addrs_json placeholder_addr
  before_addrs_json="$1"
  placeholder_addr="$(normalize_addr "$2")"

  clients_json | jq -r \
    --argjson before "$before_addrs_json" \
    --arg placeholder "$placeholder_addr" '
      [
        .[]
        | select(.mapped == true)
        | select((.address | ascii_downcase) != ($placeholder | ascii_downcase))
        | select((.address | ascii_downcase) as $addr | ($before | index($addr)) | not)
        | .address
      ]
      | first // empty
    '
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
  local addr
  addr="$(normalize_addr "$1")"

  clients_json | jq -e --arg addr "$addr" '
    any(.[]; (.address | ascii_downcase) == ($addr | ascii_downcase))
  ' >/dev/null
}

kill_window_by_addr_pid() {
  local addr pid

  addr="$(normalize_addr "$1")"
  pid="${2:-}"

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

    addr="$(jq -r '.address // empty' <<< "$json")"
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

stop_watcher() {
  local pid_file pid

  pid_file="$(watcher_pid_file)"
  [ -f "$pid_file" ] || return 0

  pid="$(cat "$pid_file" 2>/dev/null || true)"
  rm -f "$pid_file"

  [ -n "$pid" ] || return 0

  if kill -0 "$pid" 2>/dev/null; then
    log "stop watcher pid=$pid"

    pkill -TERM -P "$pid" 2>/dev/null || true
    kill "$pid" 2>/dev/null || true

    sleep 0.03

    pkill -KILL -P "$pid" 2>/dev/null || true
    kill -9 "$pid" 2>/dev/null || true
  fi
}

start_watcher() {
  local placeholder_addr placeholder_pid timeout_s before_addrs_json
  local pid_file log_file base_file

  placeholder_addr="$(normalize_addr "$1")"
  placeholder_pid="${2:-}"
  timeout_s="${3:-$PLACEHOLDER_TIMEOUT}"
  before_addrs_json="${4:?missing before_addrs_json}"

  pid_file="$(watcher_pid_file)"
  log_file="$(watcher_log_file)"
  base_file="$(baseline_file)"

  stop_watcher

  printf '%s\n' "$before_addrs_json" > "$base_file"

  : > "$log_file"

  nohup bash "$SCRIPT_SELF" --watch "$placeholder_addr" "$placeholder_pid" "$timeout_s" "$base_file" \
    >>"$log_file" 2>&1 </dev/null &

  echo "$!" > "$pid_file"
  log "start watcher pid=$! placeholder=$placeholder_addr timeout=$timeout_s"
}

consume_window() {
  local new_addr placeholder_addr placeholder_pid

  new_addr="$(normalize_addr "$1" 2>/dev/null || true)"
  placeholder_addr="$(normalize_addr "$2")"
  placeholder_pid="${3:-}"

  [ -n "$new_addr" ] || return 0

  if same_addr "$new_addr" "$placeholder_addr"; then
    log "ignore placeholder window addr=$new_addr"
    return 0
  fi

  if ! is_alive_addr "$new_addr"; then
    log "ignore vanished new window addr=$new_addr"
    return 0
  fi

  if ! is_alive_addr "$placeholder_addr"; then
    log "placeholder is gone; exiting watcher"
    rm -f "$(watcher_pid_file)"
    exit 0
  fi

  log "consume new=$new_addr placeholder=$placeholder_addr"

  focus_addr "$new_addr"
  dispatch "hl.dsp.window.swap({ target = \"address:$placeholder_addr\" })"

  kill_window_by_addr_pid "$placeholder_addr" "$placeholder_pid"

  focus_addr "$new_addr" || true

  rm -f "$(watcher_pid_file)"
  exit 0
}

watch_next_window() {
  local placeholder_addr placeholder_pid timeout_s base_file socket
  local before_addrs_json timeout_ms end_ms line data raw_addr new_addr polled_addr

  placeholder_addr="$(normalize_addr "${1:-}")"
  placeholder_pid="${2:-}"
  timeout_s="${3:-$PLACEHOLDER_TIMEOUT}"
  base_file="${4:-}"
  socket="$(socket2_path)"

  [ -S "$socket" ] || fail "socket2 not found: $socket"
  [ -n "$base_file" ] || fail "missing baseline file"
  [ -f "$base_file" ] || fail "baseline file not found: $base_file"

  before_addrs_json="$(cat "$base_file")"

  timeout_ms="$(awk -v s="$timeout_s" 'BEGIN { printf "%d", s * 1000 }')"
  end_ms="$(( $(now_ms) + timeout_ms ))"

  log "watch placeholder=$placeholder_addr pid=$placeholder_pid timeout=$timeout_s socket=$socket"
  log "watch before_addrs=$before_addrs_json"

  # Initial diff catches windows opened before the watcher connects to socket2.
  polled_addr="$(find_new_window_since "$before_addrs_json" "$placeholder_addr")"
  if [ -n "$polled_addr" ] && [ "$polled_addr" != "null" ]; then
    log "initial diff detected new window addr=$polled_addr"
    consume_window "$polled_addr" "$placeholder_addr" "$placeholder_pid"
  fi

  exec 3< <(socat -U - "UNIX-CONNECT:$socket" 2>/dev/null || true)

  while [ "$(now_ms)" -lt "$end_ms" ]; do
    if ! is_alive_addr "$placeholder_addr"; then
      log "placeholder is gone; exiting watcher"
      exec 3<&- || true
      rm -f "$(watcher_pid_file)"
      exit 0
    fi

    # Primary path: socket2 openwindow event.
    if read -r -t "$WATCH_POLL_SLEEP" line <&3; then
      log "event: $line"

      case "$line" in
        openwindow'>>'*)
          data="${line#openwindow>>}"
          raw_addr="${data%%,*}"
          new_addr="$(normalize_addr "$raw_addr" 2>/dev/null || true)"

          if [ -n "$new_addr" ]; then
            consume_window "$new_addr" "$placeholder_addr" "$placeholder_pid"
          fi
          ;;
      esac
    fi

    # Fallback path: mapped-client diff.
    polled_addr="$(find_new_window_since "$before_addrs_json" "$placeholder_addr")"
    if [ -n "$polled_addr" ] && [ "$polled_addr" != "null" ]; then
      log "poll detected new window addr=$polled_addr"
      consume_window "$polled_addr" "$placeholder_addr" "$placeholder_pid"
    fi
  done

  exec 3<&- || true

  log "watcher timeout"
  rm -f "$(watcher_pid_file)"
}

parse_place_args() {
  PLACE_DIR=""
  PLACE_COLOR="$PLACEHOLDER_COLOR"
  PLACE_ALPHA="$PLACEHOLDER_ALPHA"
  PLACE_TIMEOUT="$PLACEHOLDER_TIMEOUT"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -p|--placeholder)
        shift
        [ "$#" -gt 0 ] || fail "--placeholder requires an argument"
        PLACE_DIR="$1"
        shift
        ;;

      -c|--color)
        shift
        [ "$#" -gt 0 ] || fail "--color requires an argument"
        PLACE_COLOR="$1"
        shift
        ;;

      -a|--alpha)
        shift
        [ "$#" -gt 0 ] || fail "--alpha requires an argument"
        PLACE_ALPHA="$1"
        shift
        ;;

      -t|--timeout)
        shift
        [ "$#" -gt 0 ] || fail "--timeout requires an argument"
        PLACE_TIMEOUT="$1"
        shift
        ;;

      --)
        shift
        break
        ;;

      -*)
        fail "unknown option: $1"
        ;;

      *)
        if [ -z "$PLACE_DIR" ]; then
          PLACE_DIR="$1"
          shift
        else
          fail "unexpected positional argument: $1"
        fi
        ;;
    esac
  done

  [ -n "$PLACE_DIR" ] || fail "missing placeholder direction"
}

place() {
  local dir color alpha timeout_s
  local hdir parent_addr before_addrs_json placeholder_json placeholder_addr placeholder_pid

  parse_place_args "$@"

  dir="$PLACE_DIR"
  color="$PLACE_COLOR"
  alpha="$PLACE_ALPHA"
  timeout_s="$PLACE_TIMEOUT"

  case "$dir" in
    l|left)  hdir="l" ;;
    d|down)  hdir="d" ;;
    u|up)    hdir="u" ;;
    r|right) hdir="r" ;;
    *) usage ;;
  esac

  parent_addr="$(active_json | jq -r '.address // empty')"
  [ -n "$parent_addr" ] && [ "$parent_addr" != "null" ] || fail "no active parent window"
  parent_addr="$(normalize_addr "$parent_addr")"

  stop_watcher

  # Avoid having two placeholders at the same time.
  kill_all_placeholders

  # Killing the old placeholder may change focus; restore the parent.
  if is_alive_addr "$parent_addr"; then
    focus_addr "$parent_addr"
  fi

  # Snapshot before creating the placeholder. Any later mapped window,
  # except the placeholder itself, is a candidate to be consumed.
  before_addrs_json="$(mapped_addrs_json)"

  dispatch "hl.dsp.layout(\"preselect $hdir\")"

  if [ -n "$timeout_s" ]; then
    setsid -f "$PLACEHOLDER_CMD" "$color" "$alpha" "$timeout_s" >/dev/null 2>&1
  else
    setsid -f "$PLACEHOLDER_CMD" "$color" "$alpha" >/dev/null 2>&1
  fi

  placeholder_json="$(wait_one_placeholder)"
  placeholder_addr="$(jq -r '.address // empty' <<< "$placeholder_json")"
  placeholder_pid="$(jq -r '.pid // empty' <<< "$placeholder_json")"

  [ -n "$placeholder_addr" ] && [ "$placeholder_addr" != "null" ] || fail "could not determine placeholder window"
  placeholder_addr="$(normalize_addr "$placeholder_addr")"

  start_watcher "$placeholder_addr" "$placeholder_pid" "$timeout_s" "$before_addrs_json"

  # Keep the original parent as the active window after placing the placeholder.
  if is_alive_addr "$parent_addr"; then
    focus_addr "$parent_addr"
  fi
}

apply() {
  local marked_count placeholder_count source_json source_is_marked
  local source_addr placeholder_json placeholder_addr placeholder_pid

  stop_watcher

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
  source_addr="$(normalize_addr "$source_addr")"

  placeholder_count="$(get_placeholder_count)"
  [ "$placeholder_count" -le 1 ] || fail "expected at most one placeholder, got $placeholder_count"

  if [ "$placeholder_count" -eq 0 ]; then
    if [ "$source_is_marked" -eq 1 ]; then
      log "no placeholder; spawning natural placeholder from active window"

      setsid -f "$PLACEHOLDER_CMD" \
        "$PLACEHOLDER_COLOR" \
        "$PLACEHOLDER_ALPHA" \
        "$PLACEHOLDER_TIMEOUT" \
        >/dev/null 2>&1

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
  placeholder_addr="$(normalize_addr "$placeholder_addr")"

  log "source_addr=$source_addr source_is_marked=$source_is_marked"
  log "placeholder_addr=$placeholder_addr placeholder_pid=$placeholder_pid"

  # If the marked/active window is the placeholder itself, treat it as cancel.
  if same_addr "$source_addr" "$placeholder_addr"; then
    kill_window_by_addr_pid "$placeholder_addr" "$placeholder_pid"
    exit 0
  fi

  focus_addr "$source_addr"
  dispatch "hl.dsp.window.swap({ target = \"address:$placeholder_addr\" })"

  # The placeholder PID remains the same after the swap.
  kill_window_by_addr_pid "$placeholder_addr" "$placeholder_pid"

  if [ "$source_is_marked" -eq 1 ]; then
    focus_addr "$source_addr"
    dispatch "hl.dsp.window.tag({ tag = \"-$MARK_TAG\" })"
  else
    focus_addr "$source_addr"
  fi
}

main() {
  local action="${1:-}"
  shift || true

  case "$action" in
    -p|--placeholder) place "$@" ;;
    -s|--swallow) apply ;;
    --watch) watch_next_window "$@" ;;
    *) usage ;;
  esac
}

main "$@"

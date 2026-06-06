#!/usr/bin/env sh
set -u

: "${SEQ_TIMEOUT:=2}"
: "${SEQ_SUBMAP:=seq}"
: "${XDG_RUNTIME_DIR:=/tmp}"
: "${SEQ_DEBUG:=0}"

DIR="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE:-}/seq"
[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || DIR="$XDG_RUNTIME_DIR/seq"

STATE="$DIR/state.json"
LOG="$DIR/debug.log"

dbg() {
  [ "$SEQ_DEBUG" = 1 ] || return 0

  mkdir -p "$DIR" 2>/dev/null || true

  printf '%s [pid=%s] %s\n' \
    "$(date '+%F %T')" \
    "$$" \
    "$*" >> "$LOG" 2>/dev/null || true
}

submap() {
  dbg "SUBMAP $1"
  hyprctl dispatch "hl.dsp.submap(\"$1\")" >/dev/null 2>&1
  dbg "SUBMAP rc=$?"
}

stop() {
  dbg "STOP state=$STATE"
  rm -f "$STATE" 2>/dev/null || true
  submap reset
}

token() {
  date +%s%N
}

timeout_later() {
  dbg "TIMER schedule timeout=$SEQ_TIMEOUT token=$1"

  (
    sleep "$SEQ_TIMEOUT"
    SEQ_DEBUG="$SEQ_DEBUG" "$0" timeout "$1"
  ) >/dev/null 2>&1 &
}

case "${1:-}" in
  start)
    dbg "START"
    dbg "DIR=$DIR"
    dbg "STATE=$STATE"
    dbg "SEQ_TIMEOUT=$SEQ_TIMEOUT"
    dbg "SEQ_SUBMAP=$SEQ_SUBMAP"
    dbg "HYPRLAND_INSTANCE_SIGNATURE=${HYPRLAND_INSTANCE_SIGNATURE:-}"
    dbg "JSON=$2"

    mkdir -p "$DIR" || {
      dbg "ERROR mkdir failed: $DIR"
      exit 1
    }

    token="$(token)"
    dbg "START token=$token"

    jq -cn \
      --argjson tree "$2" \
      --arg token "$token" \
      '{tree:$tree,path:[],token:$token}' > "$STATE"

    rc=$?
    dbg "START write_state rc=$rc"

    [ "$rc" -eq 0 ] || exit 1

    dbg "STATE_CONTENT=$(cat "$STATE" 2>/dev/null || true)"

    submap "$SEQ_SUBMAP"
    timeout_later "$token"
    ;;

  key)
    key="${2:-}"

    dbg "KEY key=$key"
    dbg "STATE exists=$([ -f "$STATE" ] && echo yes || echo no)"

    [ -f "$STATE" ] || {
      dbg "KEY no state; resetting submap"
      submap reset
      exit 0
    }

    state="$(cat "$STATE")"
    dbg "STATE_CONTENT=$state"

    node="$(
      printf '%s\n' "$state" |
        jq -ce '(.path) as $p | .tree | getpath($p)' 2>/dev/null
    )"

    rc=$?
    dbg "KEY current_node rc=$rc node=$node"

    [ "$rc" -eq 0 ] || {
      dbg "KEY failed to get current node"
      stop
      exit 0
    }

    next="$(
      printf '%s\n' "$node" |
        jq -ce --arg key "$key" '.[$key]' 2>/dev/null
    )"

    rc=$?
    dbg "KEY next rc=$rc next=$next"

    [ "$rc" -eq 0 ] || {
      dbg "KEY invalid key=$key"
      stop
      exit 0
    }

    kind="$(printf '%s\n' "$next" | jq -r 'type')"
    dbg "KEY kind=$kind"

    case "$kind" in
      string)
        cmd="$(printf '%s\n' "$next" | jq -r '.')"

        dbg "RUN key=$key cmd=$cmd"

        stop

        sh -c "$cmd" >/dev/null 2>&1 &
        dbg "RUN spawned"
        ;;

      object)
        token="$(token)"
        dbg "ENTER key=$key token=$token"

        printf '%s\n' "$state" |
          jq -c \
            --arg key "$key" \
            --arg token "$token" \
            '.path += [$key] | .token = $token' > "$STATE"

        rc=$?
        dbg "ENTER write_state rc=$rc"

        [ "$rc" -eq 0 ] || exit 1

        dbg "STATE_CONTENT=$(cat "$STATE" 2>/dev/null || true)"

        submap "$SEQ_SUBMAP"
        timeout_later "$token"
        ;;

      *)
        dbg "KEY unknown kind=$kind"
        stop
        ;;
    esac
    ;;

  cancel)
    dbg "CANCEL"
    stop
    ;;

  timeout)
    token="${2:-}"

    dbg "TIMEOUT token=$token"
    dbg "STATE exists=$([ -f "$STATE" ] && echo yes || echo no)"

    [ -f "$STATE" ] || exit 0

    current="$(jq -r '.token // empty' "$STATE" 2>/dev/null)"
    dbg "TIMEOUT current=$current"

    [ "$current" = "$token" ] || {
      dbg "TIMEOUT stale"
      exit 0
    }

    dbg "TIMEOUT accepted"
    stop
    ;;

  *)
    echo "usage: $(basename "$0") start JSON | key KEY | cancel" >&2
    exit 2
    ;;
esac

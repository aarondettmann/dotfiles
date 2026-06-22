#!/usr/bin/env bash

set -euo pipefail

# From: http://vim.wikia.com/wiki/Maximize_or_set_initial_window_size (2018-07-20)

gvim_bin="/usr/bin/gvim"
if [[ ! -x "$gvim_bin" ]]; then
    echo "Error: gvim not found at $gvim_bin." >&2
    exit 1
fi

if ! command -v wmctrl >/dev/null 2>&1; then
    echo "Error: wmctrl is required to maximize gvim." >&2
    exit 1
fi

"$gvim_bin" -f "$@" &
pid=$!
winid=""

for _ in {1..200}; do
    winid="$(wmctrl -pl | awk -v pid="$pid" '$3 == pid { print $1; exit }')"
    if [[ -n "$winid" ]]; then
        break
    fi
    sleep 0.05
done

if [[ -z "$winid" ]]; then
    echo "Error: timed out waiting for gvim window (PID: $pid)." >&2
    exit 1
fi

# echo "debug: $gvim_bin started, PID=$pid, Window ID=$winid"

# ==> this maximizes the gvim window
wmctrl -i -b add,maximized_vert,maximized_horz -r "$winid"

# ==> this switches the gvim window to fullscreen
# wmctrl -i -b add,fullscreen -r $winid

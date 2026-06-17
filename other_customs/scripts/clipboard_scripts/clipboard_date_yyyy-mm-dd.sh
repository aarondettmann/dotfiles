#!/usr/bin/env bash
set -euo pipefail

if ! command -v xclip >/dev/null 2>&1; then
    echo "Error: xclip is required but not installed." >&2
    exit 1
fi

printf '%s' "$(date '+%F')" | xclip -selection clipboard

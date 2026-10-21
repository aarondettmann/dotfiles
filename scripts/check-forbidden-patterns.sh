#!/usr/bin/env bash
set -euo pipefail

# Fails if a given file matches a pattern from this untracked list (one
# case-insensitive extended regular expression per line, '#' for comments)
patterns_file="${XDG_CONFIG_HOME:-$HOME/.config}/git/forbidden-patterns"
[[ -r "$patterns_file" ]] || exit 0
(($# > 0)) || exit 0

# An empty pattern would match every line
patterns="$(grep -vE '^[[:space:]]*(#|$)' "$patterns_file" || true)"
[[ -n "$patterns" ]] || exit 0

if grep -nHIiE -f <(printf '%s\n' "$patterns") -- "$@"; then
    echo "Error: forbidden pattern found (see $patterns_file)." >&2
    exit 1
fi

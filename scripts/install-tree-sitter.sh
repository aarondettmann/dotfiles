#!/usr/bin/env bash
#
# Build the Tree-sitter CLI with Cargo unless version 0.26.1 or later is
# installed (Ubuntu 26.04 ships 0.25.9). Installs rustup if Cargo is missing.

set -euo pipefail

required="0.26.1"
cargo_bin="$HOME/.cargo/bin"

# ~/.cargo/bin first, since it is not yet on the PATH of a fresh machine
tree_sitter="$cargo_bin/tree-sitter"
[[ -x "$tree_sitter" ]] || tree_sitter="$(command -v tree-sitter || true)"
installed=""
if [[ -n "$tree_sitter" ]]; then
    installed="$("$tree_sitter" --version | awk '{print $2}')"
fi

if [[ -n "$installed" ]] \
        && [[ "$(printf '%s\n' "$required" "$installed" | sort -V | head -n 1)" == "$required" ]]; then
    echo "Tree-sitter CLI $installed is installed."
    exit 0
fi

if [[ ! -x "$cargo_bin/cargo" ]]; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs \
        | sh -s -- -y --no-modify-path --profile minimal
fi

echo "Building the Tree-sitter CLI..."
"$cargo_bin/cargo" install --locked tree-sitter-cli

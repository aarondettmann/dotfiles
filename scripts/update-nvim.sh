#!/usr/bin/env bash
#
# Install or update Neovim from the official GitHub release tarball.
#
# Usage: ./scripts/update-nvim.sh [tag]
#   tag  Release tag such as "v0.12.4", "stable" (default) or "nightly".
#
# The tarball is unpacked to ~/.local/opt/nvim-<version> and
# ~/.local/bin/nvim is pointed at it. Old versions are kept; delete them
# from ~/.local/opt manually when no longer needed.

set -euo pipefail

tag="${1:-stable}"
asset="nvim-linux-x86_64.tar.gz"
url="https://github.com/neovim/neovim/releases/download/${tag}"
opt_dir="$HOME/.local/opt"
bin_dir="$HOME/.local/bin"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

echo "Downloading Neovim (${tag})..."
curl -fL --progress-bar -o "$tmp_dir/$asset" "$url/$asset"

# Releases carry no checksum file; the GitHub API lists a SHA-256 digest for
# each asset instead. Releases published before the API added digests (mid
# 2025) have none. GITHUB_TOKEN, when set, avoids the unauthenticated rate
# limit (for example in CI).
auth=()
[[ -n "${GITHUB_TOKEN:-}" ]] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")

digest="$(
    curl -fsSL "${auth[@]}" "https://api.github.com/repos/neovim/neovim/releases/tags/${tag}" \
        | python3 -c '
import json, sys
asset = sys.argv[1]
for a in json.load(sys.stdin)["assets"]:
    if a["name"] == asset:
        print(a.get("digest") or "")
' "$asset"
)"

if [[ "$digest" == sha256:* ]]; then
    echo "Verifying checksum..."
    echo "${digest#sha256:}  $tmp_dir/$asset" | sha256sum --check --quiet
else
    echo "No checksum published for this release; skipping verification." >&2
fi

tar xzf "$tmp_dir/$asset" -C "$tmp_dir"

version="$("$tmp_dir/nvim-linux-x86_64/bin/nvim" --version | head -n 1 | cut -d' ' -f2)"
dest="$opt_dir/nvim-$version"

if [[ -d "$dest" ]]; then
    echo "Neovim $version is already installed in $dest"
else
    mkdir -p "$opt_dir"
    mv "$tmp_dir/nvim-linux-x86_64" "$dest"
fi

mkdir -p "$bin_dir"
ln -sfn "$dest/bin/nvim" "$bin_dir/nvim"

echo "Installed: $("$bin_dir/nvim" --version | head -n 1) -> $dest"

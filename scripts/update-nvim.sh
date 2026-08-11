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

# Verify the checksum when the release publishes one (not all releases do)
if curl -fsL -o "$tmp_dir/shasum.txt" "$url/${asset}.sha256sum" \
    || curl -fsL -o "$tmp_dir/shasum.txt" "$url/shasum256.txt"; then
    echo "Verifying checksum..."
    (cd "$tmp_dir" && grep " ${asset}\$" shasum.txt | sha256sum --check --quiet)
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

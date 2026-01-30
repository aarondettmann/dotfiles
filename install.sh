#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ensure stow exists
if ! command -v stow >/dev/null 2>&1; then
    echo "Error: 'stow' is not installed or not in PATH."
    exit 1
fi

echo "Any existing configuration may be overwritten!"
read -r -p "Proceed? [y/N] " install
echo

case "$install" in
    [yY]|[yY][eE][sS]) ;;
    *)
        echo "Abort."
        exit 1
        ;;
esac

app_list=(
    bash
    conda
    conky
    editorconfig
    flake8
    fzf
    git
    ideavim
    latex
    neovim
    nethack
    taskwarrior
    templates
    tmux
    vim
)

for app in "${app_list[@]}"; do
    echo "Stowing $app..."
    stow --verbose --target="$HOME" "$app"
done

echo "Done."

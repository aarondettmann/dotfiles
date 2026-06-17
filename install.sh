#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

assume_yes=false
while (($# > 0)); do
    case "$1" in
        -y|--yes)
            assume_yes=true
            ;;
        -h|--help)
            echo "Usage: $0 [--yes]"
            exit 0
            ;;
        *)
            echo "Error: unknown argument: $1" >&2
            echo "Usage: $0 [--yes]" >&2
            exit 2
            ;;
    esac
    shift
done

# Ensure stow exists
if ! command -v stow >/dev/null 2>&1; then
    echo "Error: 'stow' is not installed or not in PATH."
    exit 1
fi

if [[ "$assume_yes" != true ]]; then
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
else
    echo "Proceeding in non-interactive mode (--yes)."
fi

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
    stow --restow --verbose --target="$HOME" "$app"
done

# Taskwarrior config includes ~/.taskrc_priv; create a stub for fresh installs.
if [[ ! -f "$HOME/.taskrc_priv" ]]; then
    printf '# Optional private Taskwarrior settings (taskd credentials, etc.)\n' > "$HOME/.taskrc_priv"
fi

echo "Done."

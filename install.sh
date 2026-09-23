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

backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

if [[ "$assume_yes" != true ]]; then
    echo "Existing files that conflict with the dotfiles are moved to:"
    echo "  $backup_dir"
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
    bin
    btop
    conky
    editorconfig
    fzf
    git
    ideavim
    kitty
    latex
    neovim
    nethack
    ranger
    readline
    tealdeer
    tmux
    vim
)

# Stow refuses to replace anything it does not own (a distribution's default
# ~/.bashrc, a symlink into another checkout), so such targets are moved to
# $backup_dir first. With --no-folding every package file maps to exactly one
# target path, which makes the conflicts computable without parsing stow's
# output. Targets that already resolve into this repository (file links, or
# files reached through a folded directory link from an older install) are
# left for stow to handle.
backup_conflicts() {
    local app="$1"
    local file rel target resolved

    while IFS= read -r -d '' file; do
        rel="${file#"$app/"}"
        target="$HOME/$rel"

        [[ -e "$target" || -L "$target" ]] || continue

        resolved="$(readlink -f -- "$target" || true)"
        [[ "$resolved" == "$SCRIPT_DIR/"* ]] && continue

        mkdir -p -- "$backup_dir/$(dirname -- "$rel")"
        mv -- "$target" "$backup_dir/$rel"
        echo "  Moved $target -> $backup_dir/$rel"
    done < <(find "$app" -type f -print0)
}

# --no-folding links individual files rather than whole directories, so
# programs writing into their config directories (spell files, logs, plugin
# state) write into $HOME instead of into this repository.
for app in "${app_list[@]}"; do
    echo "Stowing $app..."
    backup_conflicts "$app"
    stow --restow --no-folding --verbose --target="$HOME" "$app"
done

if [[ -d "$backup_dir" ]]; then
    echo
    echo "Replaced files were moved to $backup_dir"
    echo "Review and delete that directory once it is no longer needed."
fi

echo "Done."

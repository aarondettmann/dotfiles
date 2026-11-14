#!/usr/bin/env bash
#
# Set up a machine by running the install scripts in order. Neovim, the
# fonts and the Tree-sitter CLI are skipped when present; the other steps
# are safe to repeat, so the script can be run again.

set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

if (($# > 0)); then
    echo "Usage: ./scripts/bootstrap.sh" >&2
    exit 2
fi

step() {
    printf '\n==> %s\n' "$1"
}

step "Linking the dotfiles"
./install.sh

step "Installing the packages"
./scripts/install-pkgs.sh

step "Activating the pre-commit hooks"
pre-commit install

step "Installing Neovim"
if [[ -x "$HOME/.local/bin/nvim" ]]; then
    echo "Neovim is installed; ./scripts/update-nvim.sh updates it."
else
    ./scripts/update-nvim.sh
fi

step "Installing the Tree-sitter CLI"
./scripts/install-tree-sitter.sh

step "Installing the Nerd Fonts"
if [[ -d "$HOME/.local/share/fonts/Hack" ]]; then
    echo "Hack is installed; ./scripts/install-nerd-fonts.sh updates it."
else
    ./scripts/install-nerd-fonts.sh
fi

step "Cloning the personal repositories and installing their tools"
./scripts/install-repos.sh

echo
echo "Done. Open a new shell to load the dotfiles."

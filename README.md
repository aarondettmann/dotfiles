# dotfiles

Personal dotfiles and customizations.

## Requirements

### Linux (core)

- `git`
- `bash`
- [GNU stow](https://www.gnu.org/software/stow/)

## Installation

### Linux

```sh
mkdir -p ~/.dotfiles
cd ~/.dotfiles

git clone https://github.com/aarondettmann/dotfiles.git

cd dotfiles
./install.sh

# Unattended install
# ./install.sh --yes
```

### Windows

Windows setup instructions are in `_windows.md`; setup uses `_windows/bootstrap.ps1` for idempotent application.

## Optional feature dependencies

| Feature | Dependencies | Notes |
| --- | --- | --- |
| tmux clipboard integration | `xclip` | Required for `tmux` copy-mode `y` binding to copy to system clipboard. |
| Clipboard helper scripts | `xclip` | Used by `other_customs/scripts/clipboard_scripts/*.sh`. |
| Markdown → PDF/Beamer scripts | `pandoc`, TeX engine (for PDF output) | Used by `vim/.vim/my_scripts/pandoc_markdown_to_*.sh`. |
| Conky status panel | `conky`, `curl`, `bc` | Optional extras in `.conkyrc`: `task` (Taskwarrior), `apt-check`. |
| FZF integration in bash/vim | `fzf` | Sourced from `~/.fzf.bash` and used by Vim plugin config. |
| Vim completion engine | `node`/`nodejs` (>=20.19, LTS recommended) | Required by `coc.nvim` and Coc extensions (`coc-json`, `coc-pyright`, `coc-snippets`). On older Node versions, Coc completion auto-start is disabled and `jedi-vim` completion remains active. |
| Vim Python diagnostics | `flake8` | `ALE` is the single diagnostics owner and is configured to lint Python files with `flake8`. |
| Taskwarrior config | `taskwarrior` | `.taskrc` includes optional private settings from `~/.taskrc_priv`. |
| tmux clock color helper | `python3`, Python package `colour`, `tmux` | Used by `tmux/.tmux/tmux_color_clock.py`. |
| Vim plugin bootstrap | `curl` (+ `sha256sum` recommended) | Checksum verification is skipped if `sha256sum` is unavailable. |

## Git identity setup

The tracked `git/.gitconfig` contains the default personal identity.

For per-machine or alternate overrides, create `~/.gitconfig.local`:

```sh
cp ~/.gitconfig.local.example ~/.gitconfig.local
$EDITOR ~/.gitconfig.local
```

## Other Customizations

Additional customizations are in `other_customs`.

![Wake up](./other_customs/fun_tools/wakeupneo/wakeupneo.gif)

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

Windows setup instructions are in `_windows.md`; setup uses
`_windows/bootstrap.ps1` for idempotent application.

## Validation

Run configuration checks locally (same checks used by CI):

```sh
./scripts/validate-config.sh
```

For strict CI-parity (fail when optional tools are missing):

```sh
./scripts/validate-config.sh --strict-tools
```

## Git identity setup

The tracked `git/.gitconfig` keeps shared defaults, enforces explicit identity
selection, and includes `~/.gitconfig.local`. Machine-local identity routing is
configured in `~/.gitconfig.local` (untracked).

Set up layered identity files:

```sh
cp ~/.gitconfig.local.example ~/.gitconfig.local
cp ~/.gitconfig.work.example ~/.gitconfig.work
cp ~/.gitconfig.personal.example ~/.gitconfig.personal
$EDITOR ~/.gitconfig.local ~/.gitconfig.work ~/.gitconfig.personal
```

Use `~/work/...` repositories for work identity and `~/personal/...`
repositories for personal identity. Verify the resolved identity in each
repository:

```sh
git config --show-origin --show-scope --get user.email
```

## Other Customizations

Additional customizations are in `other_customs`.

![Wake up](./other_customs/fun_tools/wakeupneo/wakeupneo.gif)

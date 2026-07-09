# dotfiles

Personal dotfiles and customizations.

## Requirements

## Installation

### Linux

* Install prerequisites:

```sh
sudo apt update && sudo apt install --yes git stow
```

* Install dotfiles:

```sh
mkdir -p ~/.dotfiles
cd ~/.dotfiles

git clone https://github.com/aarondettmann/dotfiles.git

cd dotfiles
./install.sh

# Unattended install
# ./install.sh --yes
```

* Install software packages:

```sh
./other_customs/fresh_install/install_pkgs.sh
```

* Restore GPG and SSH configuration into `$HOME`.

* Create project folder:

```sh
mkdir ~/.projects
```

<details>

<summary>Windows</summary>

### Windows

Windows setup instructions are in `_windows.md`; setup uses
`_windows/bootstrap.ps1` for idempotent application.

</details>

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

## Validation

Run configuration checks locally (same checks used by CI):

```sh
./scripts/validate-config.sh
```

For strict CI-parity (fail when optional tools are missing):

```sh
./scripts/validate-config.sh --strict-tools
```

---

![Wake up](./other_customs/fun_tools/wakeupneo/wakeupneo.gif)

# dotfiles

Personal dotfiles and customizations.

## Installation

### Linux

* Install prerequisites:

```sh
sudo apt update && sudo apt install --yes git stow
```

* Clone and install the dotfiles:

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

* Restore the GPG and SSH configurations under `$HOME`.

* Create project folders:

```sh
mkdir -p ~/projects ~/projects/_personal
```

#### Optional steps

<details>

<summary>Show optional setup steps</summary>

* Install [vaultar](https://github.com/aarondettmann/vaultar):

```sh
cd ~/projects/_personal
git clone https://github.com/aarondettmann/vaultar.git
cd vaultar
./install.sh
```

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

Use `~/projects/...` repositories for work identity and
`~/projects/_personal/...` repositories for personal identity. This matches the
tracked `includeIf` rules in `git/.gitconfig.local.example`. Verify the
resolved identity for each repository:

```sh
git config --show-origin --show-scope --get user.email
```

## Validation

Run configuration checks locally (the same checks used by CI):

```sh
./scripts/validate-config.sh
```

For strict CI parity (fail if optional tools are missing):

```sh
./scripts/validate-config.sh --strict-tools
```

---

![Wake up](./other_customs/fun_tools/wakeupneo/wakeupneo.gif)

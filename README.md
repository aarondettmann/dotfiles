# dotfiles

Personal dotfiles and customizations.

## Installation

### Linux

* Install prerequisites:

```sh
sudo apt update && sudo apt install --yes git stow
```

* Create the checkout directory, then clone and install the dotfiles:

```sh
mkdir -p ~/projects/_personal
cd ~/projects/_personal

git clone https://github.com/aarondettmann/dotfiles.git

cd dotfiles
./install.sh

# Unattended install
# ./install.sh --yes
```

Existing files that conflict with the dotfiles (for example the distribution's
default `~/.bashrc`) are moved to `~/.dotfiles-backup/<timestamp>/` before the
symlinks are created. Review and delete that directory once it is no longer
needed.

* Install software packages:

```sh
./scripts/install-pkgs.sh
```

* Install Neovim (latest stable release, into `~/.local/opt`; also used to
  update an existing installation):

```sh
./scripts/update-nvim.sh
```

* Install the Tree-sitter CLI, which nvim-treesitter uses to build parsers.
  It requires version 0.26.1 or later; Ubuntu 26.04 ships 0.25.9, so it is
  built with Cargo ([rustup](https://rustup.rs)):

```sh
cargo install --locked tree-sitter-cli
```

* Install Nerd Fonts (Hack for conky; also used to update an existing
  installation, see `--help` for other fonts):

```sh
./scripts/install-nerd-fonts.sh
```

* Restore the GPG and SSH configurations under `$HOME`.

#### Optional steps

<details>

<summary>Show optional setup steps</summary>

* Go: fetch own modules directly from GitHub, bypassing the public proxy and
  checksum database (stored in the untracked `~/.config/go/env`):

```sh
go env -w GOPRIVATE='github.com/aarondettmann/*'
```

* Install [vaultar](https://github.com/aarondettmann/vaultar):

```sh
cd ~/projects/_personal
git clone https://github.com/aarondettmann/vaultar.git
cd vaultar
./install.sh
```

* Install [gato](https://github.com/aarondettmann/gato):

```sh
cd ~/projects/_personal
git clone https://github.com/aarondettmann/gato.git
ln -s ~/projects/_personal/gato/gato.py ~/.local/bin/gato
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

## Commit checks

The pre-commit hooks reject private keys, files over 500 KB, secrets found by
[gitleaks](https://github.com/gitleaks/gitleaks), and lines matching a pattern
in the untracked `~/.config/git/forbidden-patterns` (one case-insensitive
extended regular expression per line, `#` for comments):

```text
# Employer name and email domain
example-corp
@excorp\.com
# Host name as a whole word only, so that "buildhosts" does not match
\bbuildhost\b
```

Run all checks on the whole repository:

```sh
pre-commit run --all-files
```

## Third-party files

<details>

<summary>Show third-party files</summary>

* `kitty/.config/kitty/tokyonight-night.conf`: unmodified copy of the kitty
  extra from [tokyonight.nvim](https://github.com/folke/tokyonight.nvim),
  [Apache License 2.0](https://github.com/folke/tokyonight.nvim/blob/main/LICENSE).
  The `license: MIT` line in the file header predates the project's
  relicensing.

</details>

---

![Wake up](./other_customs/fun_tools/wakeupneo/wakeupneo.gif)

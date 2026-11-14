<!-- Regenerate: bin/.local/bin/teletype --prompt '# ' --color blue --bold --glow --pause 15 --seed 1 --svg .github/assets/dotfiles.svg dotfiles -->
![dotfiles](./.github/assets/dotfiles.svg)

Personal Linux dotfiles, scripts and setup.

## Installation

* Install prerequisites:

```sh
sudo apt update && sudo apt install --yes git stow
```

* Restore the GPG and SSH configurations under `$HOME`.

* Clone the dotfiles and set up the machine:

```sh
mkdir -p ~/projects/_personal
cd ~/projects/_personal

git clone https://github.com/aarondettmann/dotfiles.git

cd dotfiles
./scripts/bootstrap.sh
```

`bootstrap.sh` runs the scripts below in order and stops at the first that
fails; it can be run again. Each script can also be run alone, and the
installers of Neovim, the fonts and the repositories also update.

* `./install.sh`: link the dotfiles into `$HOME` with stow (`--yes` skips
  the confirmation). Conflicting files, such as the distribution's default
  `~/.bashrc`, are moved to `~/.dotfiles-backup/<timestamp>/`; review and
  delete that directory once it is no longer needed.
* `./scripts/install-pkgs.sh`: the apt and snap packages.
* `pre-commit install`: the commit hooks of this repository.
* `./scripts/update-nvim.sh`: the latest stable Neovim, into `~/.local/opt`.
* `./scripts/install-tree-sitter.sh`: the Tree-sitter CLI for
  nvim-treesitter, built with Cargo, since Ubuntu 26.04 ships a version
  older than the required 0.26.1; installs [rustup](https://rustup.rs) if
  needed.
* `./scripts/install-nerd-fonts.sh`: the Hack Nerd Font for conky (`--help`
  lists other fonts).
* `./scripts/install-repos.sh`: clone all personal GitHub repositories into
  `~/projects/_personal` and install their tools (`--dry-run` lists the
  actions). A repository opts in with an executable `install.sh` that
  contains the line `# install-repos: tools` and runs without input.

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

## Machine-local shell setup

`~/.bashrc` sources `~/.bashrc.local` (untracked) last, if it exists. Settings
specific to one machine, such as work tools or SDK paths, go there:

```sh
$EDITOR ~/.bashrc.local
```

## Optional setup

<details>

<summary>Show optional setup steps</summary>

* Go: fetch own modules directly from GitHub, bypassing the public proxy and
  checksum database (stored in the untracked `~/.config/go/env`):

```sh
go env -w GOPRIVATE='github.com/aarondettmann/*'
```

</details>

## Validation

<details>

<summary>Show validation steps</summary>

Run configuration checks locally (the same checks used by CI):

```sh
./scripts/validate-config.sh
```

To reproduce the CI checks exactly (fail if optional tools are missing):

```sh
./scripts/validate-config.sh --strict-tools
```

</details>

## Commit checks

<details>

<summary>Show commit checks</summary>

The pre-commit hooks reject private keys, unresolved merge conflict markers,
files over 500 KB, secrets found by
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

</details>

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

<!-- Regenerate: bin/.local/bin/teletype --matrix --seed 1 --svg .github/assets/matrix.svg -->
![Wake up, Neo...](./.github/assets/matrix.svg)

# Notes for fresh install

## Candidate distros

- Xubuntu
- Manjaro

## Post-install checklist

1. Restore repositories and private directories:
   - `~/.dotfiles/dotfiles/` (public)
   - `~/.dotfiles/dotfiles.priv/` (private)
   - `~/projects/` (private)
2. Restore GPG and SSH configuration into `$HOME`.
3. Install software from the package lists below.
4. Run dotfiles validation checks:
   - `./scripts/validate-config.sh`
   - `./scripts/validate-config.sh --strict-tools`
5. Ensure `shellcheck` is installed (required for shell lint checks in strict mode/CI).
6. Configure cron jobs.
7. Review `/etc` changes and update `/etc/hosts`.

```sh
wget -q -O - "https://someonewhocares.org/hosts/hosts" | grep -E "^127.0.0.1" > hosts
sudo cp /etc/hosts /etc/hosts.bak
# Append entries from ./hosts into /etc/hosts
```

## Software packages

### Essentials

- conky
- firefox
- gimp
- gparted
- htop
- inkscape
- kdeconnect
- synapse (application launcher)
- thunderbird
- ttf-mscorefonts-installer (Microsoft fonts)
- vlc
- youtube-dl

### Development and CLI

- curl
- editorconfig
- flake8
- fonts-hack-ttf (https://github.com/source-foundry/Hack)
- gcc
- git
- gitk
- gocryptfs
- gpg (gnupg)
- neovim
- octave
- pandoc
- pandoc-citeproc
- python3-dev
- shellcheck
- sloccount
- ssh
- stow
- tmux
- tree
- urlview
- vim
- gvim
- virtualenvwrapper
- wget
- wireshark
- xclip

### Additional tooling

- espeak
- faker
- jupyter-notebook

### Privacy, backup, and security

- enigmail
- keepassxc
- nmap
- pwgen
- rsync
- seahorse
- tor browser
- zulucrypt

### Miscellaneous

- cheese
- cmatrix
- cowsay
- dropbox (+ thunar integration)
- faenza-icon-theme
- figlet
- fortune
- gsmartcontrol
- matlab
- meld
- nethack-console
- ranger
- skypeforlinux
- sl
- spotify
- taskwarrior
- tasksh
- terminator
- toilet
- translate-shell (`trans`)
- virtual-box
- wikipedia2text
- xflr5

### Optional extras

- dia
- ktouch
- latex (etc.)

#!/usr/bin/env bash
set -euo pipefail

packages=(
    # Shell and command line tools
    btop
    curl
    fd-find
    fzf
    git-delta
    htop
    pv
    pwgen
    ranger
    ripgrep
    rsync
    stow
    tealdeer
    tmux
    tree
    unzip
    urlscan
    wget
    wl-clipboard
    zoxide

    # Editors
    emacs
    vim

    # Development
    build-essential
    clang
    clang-format
    gh
    git
    git-cola
    git-filter-repo
    git-lfs
    gitk
    golang-go
    libsqlite3-dev
    meld
    nodejs
    npm
    shellcheck
    sqlite3

    # Python
    pipx
    python-is-python3
    python3-dev
    python3-pytest
    python3-venv

    # LaTeX (the metapackages installed instead of texlive-full)
    biber
    latexmk
    python3-pylatexenc
    texlive-fonts-extra
    texlive-fonts-recommended
    texlive-latex-base
    texlive-latex-extra
    texlive-latex-recommended
    texlive-luatex
    texlive-pictures
    texlive-xetex

    # Documents and media
    ghostscript
    gimp
    imagemagick
    inkscape
    pandoc
    poppler-utils
    vlc
    yt-dlp
    zathura

    # Fonts
    fonts-hack
    fonts-jetbrains-mono
    ttf-mscorefonts-installer

    # Security and network
    age
    gnupg
    gocryptfs
    keepassxc
    nmap
    openssh-client
    openssh-server
    zulucrypt-gui

    # Desktop
    conky-all
    kitty
    ktouch

    # Miscellaneous
    cmatrix
    cowsay
    figlet
    fortune-mod
    nethack-console
    sherlock
    sl
    toilet
    translate-shell
)

snaps=(
    astral-uv
    chromium
    dust
    firefox
    procs
    ruff
    scc
    thunderbird
)

sudo apt update
sudo apt install "${packages[@]}"

sudo snap install "${snaps[@]}"

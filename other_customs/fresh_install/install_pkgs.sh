#!/usr/bin/env bash

packages=(
    # texlive-full
    build-essential
    cheese
    cmatrix
    conky
    cowsay
    curl
    editorconfig
    fd-find
    figlet
    firefox
    fonts-hack
    fortune-mod
    gimp
    git
    gitk
    gnupg
    gocryptfs
    htop
    inkscape
    jupyter-notebook
    keepassxc
    kitty
    ktouch
    meld
    neovim
    nethack-console
    nmap
    openssh-client
    openssh-server
    pandoc
    pwgen
    python3-dev
    ranger
    ripgrep
    rsync
    shellcheck
    sl
    stow
    synapse
    taskwarrior
    thunderbird
    tldr-py
    tmux
    toilet
    translate-shell
    tree
    ttf-mscorefonts-installer
    urlview
    vim
    vlc
    wget
    xclip
    yt-dlp
    zulucrypt-gui
)

sudo apt update
sudo apt install "${packages[@]}"

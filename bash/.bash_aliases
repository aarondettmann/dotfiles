# BASH aliases, sourced by ~/.bashrc
# ==================================

# Conventions:
# - use aliases for direct command substitutions
# - use functions for commands that need arguments or logic

# Source bashrc
alias source_bashrc='source ~/.bashrc'

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='grep -F --color=auto'
    alias egrep='grep -E --color=auto'
fi

alias pygrep="grep -Er --color=auto --include='*.py'"

alias less='less -R'

# Some more ls aliases
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# Confirm before overwriting/removing files
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias prgrep='pgrep -fl'

# Check internet connections
if command -v netstat >/dev/null 2>&1; then
    alias chincon='sudo netstat -tupan'
fi

# Copy with rsync (useful for large or many files, shows progress)
cpwr() {
    rsync -Pavh --stats "$@"
}

# Compute md5sums recursively and save in file
md5sum_recursive() {
    find . -type f ! -name 'md5sum.txt' -exec md5sum {} + > md5sum.txt
}

# Get today's date in format yyyy-mm-dd
alias today='date "+%F"'

# Close terminal like Vim
alias :q='exit'

# Shortcut for thunar
if command -v thunar >/dev/null 2>&1; then
    alias t='thunar'
fi

# Stop the steam locomotive
if command -v sl >/dev/null 2>&1; then
    alias sl='sl -e'
fi

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Use python3 as standard interpreter
alias python='python3'
alias py='python'
alias p='python'
if command -v bpython >/dev/null 2>&1; then
    alias bpy='bpython'
fi

# Python
pyclean() {
    find . -type d -name '__pycache__' -prune -exec rm -rfv {} +
    find . -type f \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -fv {} +
}

# Python virtual env
alias venv='python3 -m venv .venv'
mkvenv() {
    python3 -m venv .venv || return
    source .venv/bin/activate
}

# Git
alias g='git'
alias gs='git status'  # Run git instead of ghostscript

# Ranger
if command -v ranger >/dev/null 2>&1; then
    alias r='ranger'
fi

# cd to root of git repository
git_root() {
    local root

    if ! root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
        echo "git_root: not inside a git repository" >&2
        return 1
    fi
    cd "$root" && pwd
}
alias git-root='git_root'
alias gr='git_root'

# Define what happens when calling vim
alias vim='$VIM_TERM'
alias :e='$VIM_TERM'

# Custom tmux sessions
alias tmux-split='~/.tmux/tmux-split.sh'

# Packages
alias packs='apt-cache search'
alias packin='sudo apt install'

clone_website() {
    wget --mirror \
         --convert-links \
         --adjust-extension \
         --page-requisites \
         --no-parent \
         "$1"  # url
}

# Useful for viewing generated HTML, docs, or test data
serve() {
    python3 -m http.server --bind "${2:-127.0.0.1}" "${1:-8000}"
}

# System update and apt-clean-up
sysupd() {
    sudo apt update
    sudo apt full-upgrade
    sudo apt autoremove --purge
    sudo apt autoclean
    sudo snap refresh
}

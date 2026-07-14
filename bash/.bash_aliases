# BASH aliases, sourced by ~/.bashrc
# ==================================

# Conventions:
# - use aliases for direct command substitutions
# - use functions for commands that need arguments or logic

# ======================================================================
# SHELL
# ======================================================================

# Reload Bash configuration
alias source_bashrc='source ~/.bashrc'

# Close terminal like Vim
alias :q='exit'

# ======================================================================
# CORE UTILITIES
# ======================================================================

# Enable color support
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='grep -F --color=auto'
    alias egrep='grep -E --color=auto'
fi

alias less='less -R'

# ls
alias ll='ls -ahlF'
alias la='ls -A'
alias l='ls -CF'

# Safer file operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'

# Processes
alias prgrep='pgrep -fl'

# Recursive grep in Python files
alias pygrep="grep -Er --color=auto --include='*.py'"

# ======================================================================
# NAVIGATION
# ======================================================================

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ======================================================================
# DATE / TIME
# ======================================================================

alias today='date "+%F"'

# ======================================================================
# NETWORK
# ======================================================================

if command -v netstat >/dev/null 2>&1; then
    alias chincon='sudo netstat -tupan'
fi

# ======================================================================
# FILE UTILITIES
# ======================================================================

# Copy using rsync (better for large transfers)
cpwr() {
    rsync -Pavh --stats "$@"
}

# Compute md5 sums recursively
md5sum_recursive() {
    find . -type f ! -name md5sum.txt -exec md5sum {} + > md5sum.txt
}

clone_website() {
    wget \
        --mirror \
        --convert-links \
        --adjust-extension \
        --page-requisites \
        --no-parent \
        "$1"
}

# ======================================================================
# PYTHON
# ======================================================================

# Prefer Python 3
alias python='python3'
alias py='python'
alias p='python'

if command -v bpython >/dev/null 2>&1; then
    alias bpy='bpython'
fi

pyclean() {
    find . -type d -name __pycache__ -prune -exec rm -rfv {} +
    find . -type f \( -name '*.pyc' -o -name '*.pyo' \) -exec rm -fv {} +
}

alias venv='python3 -m venv .venv'

mkvenv() {
    python3 -m venv .venv || return
    source .venv/bin/activate
}

# ======================================================================
# GIT
# ======================================================================

alias g='git'
alias gs='git status'   # Instead of Ghostscript

git_root() {
    local root

    root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
        printf 'git_root: not inside a git repository\n' >&2
        return 1
    }

    cd -- "$root" && pwd
}

alias git-root='git_root'
alias gr='git_root'

# ======================================================================
# EDITORS
# ======================================================================

alias vi='nvim'
alias vim='nvim'
alias ovim='command vim'

# ======================================================================
# FILE MANAGERS
# ======================================================================

if command -v ranger >/dev/null 2>&1; then
    alias r='ranger'
fi

if command -v thunar >/dev/null 2>&1; then
    alias t='thunar'
fi

# ======================================================================
# PACKAGES
# ======================================================================

alias packs='apt-cache search'
alias packin='sudo apt install'

sysupd() {
    sudo apt update &&
    sudo apt full-upgrade &&
    sudo apt autoremove --purge &&
    sudo apt autoclean &&
    sudo snap refresh
}

# ======================================================================
# WEB
# ======================================================================

# Useful for viewing generated HTML, docs, or test data
serve() {
    python3 -m http.server --bind "${2:-127.0.0.1}" "${1:-8000}"
}

# ======================================================================
# MISCELLANEOUS
# ======================================================================

# Stop the steam locomotive
if command -v sl >/dev/null 2>&1; then
    alias sl='sl -e'
fi

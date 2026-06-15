# BASH aliases, sourced by ~/.bashrc
# ==================================

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

# Add an "alert" alias for long running commands
# Use like so:
# --> sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# confirm before overwriting something
alias cp='cp -i'
alias prgrep='pgrep -fl'

# Check internet connections
alias chincon='sudo netstat -tupan'

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
alias t='thunar'

# Stop the steam locomotive
alias sl='sl -e'

alias cd..='cd ..'
alias ..='cd ..'

# Use python3 as standard interpreter
alias python='python3'
alias py='python'
alias p='python'
alias bpy='bpython'

# Python
alias pyclean='find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rfv'

# Python virtual env
alias venv='python3 -m venv .venv'

# Git
alias g='git'
alias gs='git status'  # Run git instead of ghostscript

# Ranger
alias r='ranger'

# cd to root of git repository
git_root() {
    local root

    root="$(git rev-parse --show-toplevel)" || return
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
    python3 -m http.server "${1:-8000}"
}

# System update and apt-clean-up
sysupd() {
    sudo apt update
    sudo apt full-upgrade
    sudo apt autoremove --purge
    sudo apt autoclean
    sudo snap refresh
}

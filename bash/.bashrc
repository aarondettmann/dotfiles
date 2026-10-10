#      __ __  __   ____    _          ____               __
#   __/ // /_/ / _/_/ /_  (_)___    _/_/ /_  ____ ______/ /_
#  /_  _  __/ /_/_// __ \/ / __ \ _/_// __ \/ __ `/ ___/ __ \
# /_  _  __/_//_/ / /_/ / / / / //_/ / /_/ / /_/ (__  ) / / /
#  /_//_/ (_)_/  /_.___/_/_/ /_/_/  /_.___/\__,_/____/_/ /_/

# ======================================================================
# BASIC
# ======================================================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# History. Kept away from ~/.bash_history: an interactive shell that never
# read this file (--norc, another HOME) truncates the default path to 500
# lines on exit.
HISTFILE="$HOME/.local/state/bash/history"
mkdir -p "${HISTFILE%/*}"
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE='ls:ll:pwd:exit:clear'
HISTTIMEFORMAT='%F %T '
HISTSIZE=100000
HISTFILESIZE=300000

shopt -s histappend
shopt -s histverify
shopt -s cmdhist
shopt -s lithist
shopt -s checkwinsize
shopt -s globstar
shopt -s extglob

# Useful shell conveniences
shopt -s autocd
shopt -s cdspell
shopt -s dirspell

# Make 'less' more friendly for non-text input files
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in
if [[ -z "${debian_chroot:-}" && -r /etc/debian_chroot ]]; then
    debian_chroot=$(</etc/debian_chroot)
fi

# ======================================================================
# PROMPT
# ======================================================================

# Display the exit status of the previous command when it failed.
exit_code_indicator() {
    local rc=$?
    (( rc == 0 )) || printf ' [%d]' "$rc"
}

# Git prompt (__git_ps1) ships with git itself; the path varies by distro
for _git_prompt in \
    /usr/lib/git-core/git-sh-prompt \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/share/git/completion/git-prompt.sh; do
    if [[ -r "$_git_prompt" ]]; then
        source "$_git_prompt"
        GIT_PS1_SHOWDIRTYSTATE=true
        GIT_PS1_SHOWUNTRACKEDFILES=true
        GIT_PS1_SHOWSTASHSTATE=true
        # Relation to the upstream branch: `<` behind, `>` ahead, `<>`
        # diverged, `=` in sync
        GIT_PS1_SHOWUPSTREAM=auto
        break
    fi
done
unset _git_prompt

if command -v tput >/dev/null 2>&1 && tput setaf 1 >/dev/null 2>&1; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]$(exit_code_indicator)'
    if declare -F __git_ps1 >/dev/null 2>&1; then
        PS1+=' \[\033[01;36m\]$(__git_ps1 "[%s]")\[\033[00m\]'
    fi
    PS1+='\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W$(exit_code_indicator)\$ '
fi

PS2='... '

# If this is an xterm, set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
esac

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ======================================================================
# OTHER SETTINGS
# ======================================================================

# Needed for tmux prefix Ctrl-S (`set -g prefix C-s`)
if [[ -t 0 ]] && command -v stty >/dev/null 2>&1; then
    stty -ixon
fi

# Default editor
export EDITOR=nvim
export VISUAL=nvim

# less options for every caller (git, direct calls): -R keeps colours, -i
# ignores case unless the pattern has an uppercase letter, -F quits when the
# output fits one screen. Without -X long output is paged in the alternate
# screen, so the mouse wheel scrolls the pager, not the tmux history.
export LESS='-R -i -F'

# Man pages rendered by Neovim (`:help :Man`). Skipped inside a Neovim
# terminal, where `man` would start a nested instance; use `:Man` there.
if [[ -z "${NVIM:-}" ]]; then
    export MANPAGER='nvim +Man!'
fi

PROJECTS="$HOME/projects"
DOTFILES="$PROJECTS/_personal/dotfiles"

# ======================================================================
# PATH
# ======================================================================

# Helper functions for safely modifying PATH
pathprepend() {
    [[ -d $1 ]] || return
    [[ ":$PATH:" == *":$1:"* ]] || PATH="$1:$PATH"
}

pathappend() {
    [[ -d $1 ]] || return
    [[ ":$PATH:" == *":$1:"* ]] || PATH="$PATH:$1"
}

# User-local executables (including the dotfiles `bin` package)
pathprepend "$HOME/.local/bin"

# Rust
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

export PATH

# ======================================================================
# ALIASES / COMPLETION
# ======================================================================

[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# In kitty, wrap ssh so remote sessions get kitty's SSH integration
if [[ "${TERM:-}" == "xterm-kitty" ]] && command -v kitty >/dev/null 2>&1; then
    alias ssh='kitten ssh'
fi

if ! shopt -oq posix; then
    if [[ -r /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -r /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi
fi

# ======================================================================
# FUNCTIONS
# ======================================================================

mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}

# ======================================================================
# NEOVIM
# ======================================================================

if [[ -n "${NVIM:-}" ]]; then
    nvim() {
        echo "Running nvim inside nvim makes life hard"
        return 1
    }
fi

# ======================================================================
# TMUX
# ======================================================================

# Auto-start tmux only in real TTYs and non-JetBrains terminals
if [[ -z "${TMUX:-}" ]] \
    && [[ -z "${DOTFILES_NO_AUTO_TMUX:-}" ]] \
    && [[ "${TERM:-}" != "dumb" ]] \
    && [[ "${TERMINAL_EMULATOR:-}" != "JetBrains-JediTerm" ]] \
    && [[ -z "${PYCHARM_HOSTED:-}" ]] \
    && [[ -t 0 && -t 1 ]] \
    && command -v tmux >/dev/null 2>&1; then
    exec tmux
fi

# ======================================================================
# FZF
# ======================================================================

[[ -r "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"

# Ubuntu ships `fd` as `fdfind` (package `fd-find`, see scripts/install-pkgs.sh)
fzf_fd_bin="$(type -P fd fdfind 2>/dev/null | head -n 1)"

if [[ -n "${fzf_fd_bin}" ]]; then
    export FZF_DEFAULT_COMMAND="${fzf_fd_bin} --type f --hidden --follow \
        --exclude .git \
        --exclude Dropbox \
        --exclude .venv \
        --exclude venv \
        --exclude node_modules \
        --exclude __pycache__ \
        --exclude '*.pyc' \
        --exclude '*.pdf' \
        --exclude '*.o' \
        --exclude '*.so' \
        --exclude '*.log'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
unset fzf_fd_bin

# Inside tmux, open fzf in a popup covering 80% of the window (fzf 0.53+);
# `--style full` draws borders around the input, list and preview (fzf 0.58+).
export FZF_DEFAULT_OPTS='--tmux 80% --style full'

# ======================================================================
# ZOXIDE
# ======================================================================

# `--cmd cd` replaces `cd` itself instead of adding `z`: an existing path is
# entered as usual, any other argument (`cd dotfiles`) jumps to the
# best-matching visited directory. `cdi` selects a match interactively.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi

# ======================================================================
# HISTORY SYNC
# ======================================================================

history_sync() {
    history -a
    history -n
}

PROMPT_COMMAND+=(history_sync)

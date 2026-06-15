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
    *) return;;
esac

# See bash(1)
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=5000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

# Make 'less' more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# ======================================================================
# PROMPT
# ======================================================================

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
else
    color_prompt=
fi

# Function used in shell prompt to indicate exit code of last command
exit_code_indicator () {
    local exit_code=$?
    printf '[%s]' "$exit_code"
}

# Git
if [[ -r "$HOME/.bash_git_prompt" ]]; then
    source "$HOME/.bash_git_prompt"
    GIT_PS1_SHOWDIRTYSTATE="true"
    GIT_PS1_SHOWUNTRACKEDFILES="true"
    GIT_PS1_SHOWSTASHSTATE="true"
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\] $(exit_code_indicator)'
    if declare -F __git_ps1 >/dev/null 2>&1; then
        PS1+=' \[\e[01;36m\]$(__git_ps1 "[%s]")\[\033[00m\]'
    fi
    PS1+='\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

PS2='... '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ======================================================================
# Other settings
# ======================================================================

# Quick access to folders
DOTFILES="$HOME/.dotfiles/dotfiles/"
DOTFILES_PRIV="$HOME/.dotfiles/dotfiles.priv/"
PROJECTS="$HOME/projects/"

# Preferred Vim version
VIM_TERM="nvim"

mkcd () { mkdir -p "$@" && cd "$1"; }

# Source private settings
[[ -r "$HOME/.bashrc_priv" ]] && source "$HOME/.bashrc_priv"

# Customisations for neovim terminal
if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
    alias nvim='cowsay "Running nvim inside nvim makes life hard -- Shakespeare"'
fi

# Auto-start tmux only in real TTYs and non-JetBrains terminals.
if [[ -z "$TMUX" ]] \
    && [[ -z "${DOTFILES_NO_AUTO_TMUX:-}" ]] \
    && [[ "${TERMINAL_EMULATOR:-}" != "JetBrains-JediTerm" ]] \
    && [[ -z "${PYCHARM_HOSTED:-}" ]] \
    && [[ -t 0 && -t 1 ]] \
    && command -v tmux >/dev/null 2>&1; then
    tmux
fi

# FZF fuzzy finder
[[ -r "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"

export FZF_DEFAULT_COMMAND="find . \
    \( -path '*/.git' -o -path '*/Dropbox' -o -path '*/.venv' -o -path '*/venv' \) -prune -o \
    -type f \
    ! -iname '*.pyc' \
    ! -iname '*.pdf' \
    ! -iname '*.o' \
    ! -iname '*.so' \
    ! -iname '*.log' \
    -print"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

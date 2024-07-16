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
    exit_code=$?

    if [ $exit_code -ne "0" ]; then
        echo "[${exit_code}]"
    else
        echo "[${exit_code}]"
    fi
}

# Git
source $HOME/.bash_git_prompt
GIT_PS1_SHOWDIRTYSTATE="true"
GIT_PS1_SHOWUNTRACKEDFILES="true"
GIT_PS1_SHOWSTASHSTATE="true"

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\] $(exit_code_indicator) \[\e[01;36m\]$(__git_ps1 "[%s]")\[\033[00m\]\$ '
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
DOTFILES="$HOME/.MyDotfiles/dotfiles/"
DOTFILES_PRIV="$HOME/.MyDotfiles/dotfiles.priv/"
PROJECTS="$HOME/projects/"

# Preferred Vim version
VIM_TERM="nvim"

mkcd () { mkdir -p "$@" && cd "$1"; }

# Tar gpg-config
tar_gpg_conf() {
    cd $HOME
    tar -cvzf "gpg-config_$(date "+%F_%H%M").tgz" "./.gnupg/"
}

# Tar ssh-config
tar_ssh_conf() {
    cd $HOME
    tar -cvzf "ssh-config_$(date "+%F_%H%M").tgz" "./.ssh/"
}

# Source private settings
[[ -f ~/.bashrc_priv ]] && source ~/.bashrc_priv

# Customisations for neovim terminal
if [[ -n "$NVIM_LISTEN_ADDRESS" ]]; then
    alias nvim='cowsay "Running nvim inside nvim makes life hard -- Shakespeare"'
fi

# Always run tmux
[[ -z "$TMUX" ]] && tmux

# FZF fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_COMMAND="find -type f \( \
                            ! -iname '.git' \
                            ! -iname '*.pyc' \
                            ! -iname '*.pdf' \
                            ! -iname '*.o' \
                            ! -iname '*.so' \
                            ! -iname '*.log' \
                            \) \
                            ! -path '~/Dropbox/*' \
                            "

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
alias mkvirtualenv='mkvirtualenv --python=/usr/bin/python3'

# ===== CONDA =====
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias cworkon='conda activate'
alias cdeactivate='conda deactivate'

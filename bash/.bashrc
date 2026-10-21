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

# Active virtualenv, named after its project directory; `$?` is passed
# through for exit_code_indicator, which runs after it in PS1
export VIRTUAL_ENV_DISABLE_PROMPT=1
venv_indicator() {
    local rc=$? project
    if [[ -n "${VIRTUAL_ENV:-}" ]]; then
        project="${VIRTUAL_ENV%/*}"
        printf '(%s) ' "${project##*/}"
    fi
    return "$rc"
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
    # ANSI colours, so the terminal theme sets the actual values
    PS1='${debian_chroot:+($debian_chroot)}'
    PS1+='\[\033[33m\]$(venv_indicator)\[\033[00m\]'       # yellow
    PS1+='\[\033[01;32m\]\u@\h\[\033[00m\]:'               # bold green
    PS1+='\[\033[01;34m\]\W\[\033[00m\]'                   # bold blue
    PS1+='\[\033[31m\]$(exit_code_indicator)\[\033[00m\]'  # red
    if declare -F __git_ps1 >/dev/null 2>&1; then
        PS1+=' \[\033[01;35m\]$(__git_ps1 "[%s]")\[\033[00m\]' # bold magenta
    fi
    PS1+='\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}$(venv_indicator)\u@\h:\W$(exit_code_indicator)\$ '
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

# gato: the cat's name and birthday (MM-DD); tmux/.tmux.conf sets the same
# values for the status line
export GATO_NAME=DK
export GATO_BIRTHDAY=02-25

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

# Go: tools installed with `go install` go to ~/.local/bin, the module cache
# next to the build cache (~/.cache/go-build) and GOPATH keeps only the
# checksum database. The `go env` file does not expand $HOME, hence exports.
export GOPATH="$HOME/.local/share/go"
export GOMODCACHE="$HOME/.cache/go/mod"
export GOBIN="$HOME/.local/bin"

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

# Complete the `g` alias like `git`. The git completion is normally loaded
# on the first <Tab>, so it is sourced here for `__git_complete`.
if [[ -r /usr/share/bash-completion/completions/git ]]; then
    source /usr/share/bash-completion/completions/git
    __git_complete g __git_main
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
# PALABRA
# ======================================================================

# Spanish word of the day (bin/.local/bin/palabra), one line. Only in
# tmux, so ssh sessions and IDE terminals stay quiet.
if [[ -n "${TMUX:-}" ]] && command -v palabra >/dev/null 2>&1; then
    printf '\033[01;35mpalabra:\033[00m \033[36m%s\033[00m\n' "$(palabra --line)"
fi

# ======================================================================
# ZOXIDE
# ======================================================================

# `--cmd cd` replaces `cd` itself instead of adding `z`: an existing path is
# entered as usual, any other argument (`cd dotfiles`) jumps to the
# best-matching visited directory. `cdi` selects a match interactively.
# Only existing directories reach the builtin, so `shopt -s cdspell` would
# have no effect.
#
# Before the FZF section: zoxide's `complete` call for `cd` is unconditional
# and would replace fzf's; fzf wraps whatever `cd` has when it loads.
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash --cmd cd)"
fi

# ======================================================================
# FZF
# ======================================================================

[[ -r "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"

# `cd **<Tab>` opens fzf; otherwise fzf falls through to zoxide (`cd dot<Tab>`
# completes directories, `cd dot <Tab>` picks a visited one). fzf returns
# quoted names and needs `-o nospace`; zoxide returns raw names and needs
# `-o filenames`. fzf's wrapper keeps only zoxide's options (`cd sub\\\ dir/`
# plus a space), so the options are set per completion here.
if declare -F __zoxide_z_complete _fzf_dir_completion >/dev/null 2>&1; then
    _cd_complete() {
        if [[ ${COMP_WORDS[COMP_CWORD]} == *"${FZF_COMPLETION_TRIGGER-**}" ]]; then
            compopt +o filenames -o nospace
        fi
        _fzf_dir_completion "$@"
    }
    complete -o filenames -F _cd_complete cd
fi

# Ubuntu ships `fd` as `fdfind` (package `fd-find`, see scripts/install-pkgs.sh)
fzf_fd_bin="$(type -P fd fdfind 2>/dev/null | head -n 1)"

if [[ -n "${fzf_fd_bin}" ]]; then
    # Shared by Ctrl-T, Alt-C and the `**<Tab>` functions below
    fzf_fd_cmd="${fzf_fd_bin} --hidden --follow \
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
    export FZF_DEFAULT_COMMAND="${fzf_fd_cmd} --type f"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="${fzf_fd_cmd} --type d"
    # Files and directories for `**<Tab>` (`ls`, `cp`, `mv`), as with fzf's
    # default walker; read only by _fzf_compgen_path below
    FZF_COMPGEN_PATH_COMMAND="${fzf_fd_cmd}"

    # `**<Tab>` completion. fzf calls these with the base directory as $1 in
    # a subshell with FZF_DEFAULT_COMMAND unset, hence the separate variables.
    # fd prefixes results with the search path; a leading `./` is removed, as
    # in fzf's own example.
    _fzf_compgen_path() {
        eval "$FZF_COMPGEN_PATH_COMMAND . $(printf '%q' "$1")" | sed 's@^\./@@'
    }

    _fzf_compgen_dir() {
        eval "$FZF_ALT_C_COMMAND . $(printf '%q' "$1")" | sed 's@^\./@@'
    }
fi
unset fzf_fd_bin fzf_fd_cmd

# Inside tmux, open fzf in a popup covering 80% of the window (fzf 0.53+);
# `--style full` draws borders around the input, list and preview (fzf 0.58+).
export FZF_DEFAULT_OPTS='--tmux 80% --style full'

# Ctrl-R: entries are `<number><Tab><command>`, so `{2..}` is the command
# (`printf` rather than `echo`, which would parse a command starting with
# `-` as its options). The list cuts long and multi-line commands off;
# Ctrl-/ shows the selected one in full. Ctrl-Y copies it to the clipboard
# instead of inserting it.
export FZF_CTRL_R_OPTS="
    --preview 'printf \"%s\\n\" {2..}'
    --preview-window up:3:hidden:wrap
    --bind 'ctrl-/:toggle-preview'"
if command -v wl-copy >/dev/null 2>&1; then
    FZF_CTRL_R_OPTS+="
    --bind 'ctrl-y:execute-silent(printf \"%s\" {2..} | wl-copy)+abort'
    --header 'Ctrl-/: show command, Ctrl-Y: copy to clipboard'"
else
    FZF_CTRL_R_OPTS+="
    --header 'Ctrl-/: show command'"
fi

# ======================================================================
# DIRENV
# ======================================================================

# direnv loads and unloads the .envrc of the current directory from a prompt
# hook, which runs before history_sync below. `layout venv` is defined in
# ~/.config/direnv/direnvrc. The empty log format silences `loading` and
# `unloading` messages, errors are still printed; the toml `log_format` key
# cannot do this (direnv 2.37.1).
if command -v direnv >/dev/null 2>&1; then
    export DIRENV_LOG_FORMAT=
    eval "$(direnv hook bash)"
fi

# ======================================================================
# HISTORY SYNC
# ======================================================================

history_sync() {
    history -a
    history -n
}

PROMPT_COMMAND+=(history_sync)

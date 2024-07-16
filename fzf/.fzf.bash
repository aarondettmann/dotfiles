# Setup fzf
# ---------
if [[ ! "$PATH" == */home/aaron/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/aaron/.fzf/bin"
fi

eval "$(fzf --bash)"

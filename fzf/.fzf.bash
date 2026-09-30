# Setup fzf (Ubuntu package `fzf`; `fzf --bash` requires fzf 0.48 or later)
# ---------
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"
fi

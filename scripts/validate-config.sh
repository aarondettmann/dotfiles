#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

strict_tools=false

while (($# > 0)); do
    case "$1" in
        --strict-tools)
            strict_tools=true
            ;;
        -h|--help)
            cat <<'USAGE'
Usage: ./scripts/validate-config.sh [--strict-tools]

Runs repository configuration checks locally.

Options:
  --strict-tools  Fail if optional tools (shellcheck, nvim, vim, tmux, perl)
                  are missing.
USAGE
            exit 0
            ;;
        *)
            echo "Error: unknown argument: $1" >&2
            exit 2
            ;;
    esac
    shift
done

require_or_skip() {
    local tool="$1"
    local message="$2"
    if command -v "$tool" >/dev/null 2>&1; then
        return 0
    fi

    if [[ "$strict_tools" == true ]]; then
        echo "Error: required tool missing: $tool" >&2
        exit 1
    fi

    echo "Skipping: $message (missing '$tool')." >&2
    return 1
}

# Scripts in bin have no extension; the shebang tells shell from Python
sh_files=()
py_files=()
while IFS= read -r file; do
    [[ -f "$file" ]] || continue
    case "$(head -n 1 "$file")" in
        *python*) py_files+=("$file") ;;
        *) sh_files+=("$file") ;;
    esac
done < <(git ls-files '*.sh' 'bin/.local/bin/*')
mapfile -t -O "${#py_files[@]}" py_files < <(git ls-files '*.py')

echo "Running bash syntax checks..."
bash -n install.sh bash/.bashrc bash/.bash_aliases fzf/.fzf.bash direnv/.config/direnv/direnvrc
for file in "${sh_files[@]}"; do
    bash -n "$file"
done

if require_or_skip shellcheck "ShellCheck checks"; then
    echo "Running ShellCheck..."
    shellcheck -S error -x -s bash install.sh bash/.bashrc bash/.bash_aliases fzf/.fzf.bash direnv/.config/direnv/direnvrc bash/.local/share/bash-completion/completions/*
    for file in "${sh_files[@]}"; do
        shellcheck -S error -x "$file"
    done
fi

echo "Running Python syntax checks..."
for file in "${py_files[@]}"; do
    [[ -f "$file" ]] || continue
    python3 -m py_compile "$file"
done

echo "Running Git config validation..."
git config --file git/.gitconfig --list >/dev/null

if require_or_skip vim "Vim config validation"; then
    echo "Running Vim config validation..."
    # Vim in Ex mode does not report errors through its exit status, so any
    # message written while sourcing the vimrc counts as a failure.
    vim_messages="$(vim -Nu vim/.vimrc -i NONE -es '+redir! > /dev/stdout' '+messages' '+redir END' '+qa!' 2>&1 || true)"
    vim_errors="$(grep -E '^(E[0-9]+|Error)' <<<"$vim_messages" || true)"
    if [[ -n "$vim_errors" ]]; then
        echo "$vim_errors" >&2
        exit 1
    fi
fi

if require_or_skip tmux "tmux config validation"; then
    echo "Running tmux config validation..."
    # `source-file -n` only checks the syntax, so the file is executed in a
    # server on a private socket, away from any running tmux server.
    tmux_status=0
    tmux -L dotfiles-validate -f /dev/null new-session -d \; source-file tmux/.tmux.conf \
        || tmux_status=$?
    tmux -L dotfiles-validate kill-server 2>/dev/null || true
    ((tmux_status == 0)) || exit "$tmux_status"
fi

if require_or_skip perl "latexmk config validation"; then
    echo "Running latexmk config validation..."
    perl -c latex/.latexmkrc 2>/dev/null
fi

echo "Running palabra word list validation..."
# The script rejects malformed rows and duplicate words. Fixed dates keep the
# run independent of today: before the start date, in the first week (a
# partial review schedule), with the full schedule, and after the list wrapped.
run_palabra() {
    PALABRA_WORDS=palabra/.local/share/palabra/words.tsv \
        bin/.local/bin/palabra "$@" >/dev/null
}
run_palabra --date 2026-01-01
run_palabra --date 2026-08-01 --width 40
run_palabra --new --width 42 --date 2026-12-01
run_palabra --line --date 2030-01-01

echo "Running teletype SVG check..."
# The README animations are generated with a fixed seed and must be up to date
check_svg() {
    local svg="$1"
    shift
    if ! cmp -s <(bin/.local/bin/teletype "$@" --svg -) "$svg"; then
        echo "Error: $svg is out of date, regenerate it with:" >&2
        printf '  bin/.local/bin/teletype --svg %q' "$svg" >&2
        printf ' %q' "$@" >&2
        echo >&2
        exit 1
    fi
}
check_svg .github/assets/dotfiles.svg \
    --prompt '# ' --color blue --bold --glow --pause 15 --seed 1 dotfiles
check_svg .github/assets/matrix.svg --matrix --seed 1

echo "Running JSON validation..."
python3 -m json.tool neovim/.config/nvim/nvim-pack-lock.json >/dev/null

if python3 -c 'import yaml' 2>/dev/null; then
    echo "Running YAML validation..."
    python3 -c 'import sys, yaml; [yaml.safe_load(open(p)) for p in sys.argv[1:]]' \
        lazygit/.config/lazygit/config.yml
else
    echo "Skipping: YAML validation (missing python module 'yaml')." >&2
fi

if require_or_skip nvim "Neovim config validation"; then
    echo "Running Neovim config validation..."
    mapfile -t nvim_lua_files < <(git ls-files 'neovim/.config/nvim' | awk '/\.lua$/')

    (
        set -euo pipefail

        tmpdir="$(mktemp -d)"

        # The startup check quits while plugins may still run async jobs
        # (e.g. tree-sitter parser downloads). Neovim terminates them on
        # exit, but they can briefly keep writing, so retry the cleanup.
        cleanup() {
            local _try
            for _try in 1 2 3; do
                rm -rf "$tmpdir" 2>/dev/null && return 0
                sleep 2
            done
            rm -rf "$tmpdir"
        }
        trap cleanup EXIT

        existing_nvim_lua_files=()
        for file in "${nvim_lua_files[@]}"; do
            [[ -f "$file" ]] || continue
            existing_nvim_lua_files+=("$file")
        done

        if ((${#existing_nvim_lua_files[@]} > 0)); then
            printf '%s\n' "${existing_nvim_lua_files[@]}" >"$tmpdir/nvim-lua-files.txt"

            NVIM_VALIDATE_FILES="$tmpdir/nvim-lua-files.txt" \
                nvim --headless -u NONE --noplugin -i NONE \
                '+lua for path in io.lines(vim.env.NVIM_VALIDATE_FILES) do local chunk, err = loadfile(path); if not chunk then error(err) end end' \
                '+qa'
        fi

        mkdir -p "$tmpdir/state" "$tmpdir/cache" "$tmpdir/data"

        XDG_CONFIG_HOME="$REPO_ROOT/neovim/.config" \
        XDG_STATE_HOME="$tmpdir/state" \
        XDG_CACHE_HOME="$tmpdir/cache" \
        XDG_DATA_HOME="$tmpdir/data" \
            nvim --headless -i NONE '+qa'
    )
fi

echo "Config validation completed."

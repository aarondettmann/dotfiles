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
  --strict-tools  Fail if optional tools (shellcheck, nvim, pwsh) are missing.
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

echo "Running bash syntax checks..."
bash -n install.sh bash/.bashrc bash/.bash_aliases
mapfile -t sh_files < <(git ls-files '*.sh')
for file in "${sh_files[@]}"; do
    bash -n "$file"
done

if require_or_skip shellcheck "ShellCheck checks"; then
    echo "Running ShellCheck..."
    shellcheck -S error -x -s bash install.sh bash/.bashrc bash/.bash_aliases
    for file in "${sh_files[@]}"; do
        shellcheck -S error -x "$file"
    done
fi

echo "Running Python syntax checks..."
mapfile -t py_files < <(git ls-files '*.py')
for file in "${py_files[@]}"; do
    python3 -m py_compile "$file"
done

echo "Running JSON validation..."
python3 -m json.tool _windows/windows_terminal_settings.json >/dev/null
python3 -m json.tool neovim/.config/nvim/nvim-pack-lock.json >/dev/null

if require_or_skip nvim "Neovim config validation"; then
    echo "Running Neovim config validation..."
    mapfile -t nvim_lua_files < <(git ls-files 'neovim/.config/nvim' | awk '/\.lua$/')

    (
        set -euo pipefail

        tmpdir="$(mktemp -d)"
        trap 'rm -rf "$tmpdir"' EXIT

        if ((${#nvim_lua_files[@]} > 0)); then
            printf '%s\n' "${nvim_lua_files[@]}" >"$tmpdir/nvim-lua-files.txt"

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

if require_or_skip pwsh "PowerShell syntax/analyzer checks"; then
    echo "Running PowerShell syntax checks..."
    # shellcheck disable=SC2016
    pwsh -NoLogo -NoProfile -Command '
      $files = git ls-files "*.ps1"
      foreach ($file in $files) {
        $tokens = $null
        $errors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$tokens, [ref]$errors)

        if ($errors.Count -gt 0) {
          $errors | Format-Table -AutoSize | Out-String | Write-Output
          throw "PowerShell parse errors found in $file."
        }
      }
    '

    echo "Running PowerShell analyzer checks..."
    # shellcheck disable=SC2016
    pwsh -NoLogo -NoProfile -Command '
      $module = Get-Module -ListAvailable -Name PSScriptAnalyzer | Select-Object -First 1
      if (-not $module) {
        Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
      }

      $files = git ls-files "*.ps1"
      if (-not $files) {
        exit 0
      }

      $warnings = @()
      $errors = @()
      foreach ($file in $files) {
        $results = Invoke-ScriptAnalyzer -Path $file -Severity Warning,Error
        $warnings += $results | Where-Object Severity -eq "Warning"
        $errors += $results | Where-Object Severity -eq "Error"
      }

      if ($warnings.Count -gt 0) {
        Write-Output "PSScriptAnalyzer warnings:"
        $warnings | Format-Table -AutoSize | Out-String | Write-Output
      }

      if ($errors.Count -gt 0) {
        Write-Output "PSScriptAnalyzer errors:"
        $errors | Format-Table -AutoSize | Out-String | Write-Output
        throw "PSScriptAnalyzer found errors."
      }
    '
fi

echo "Config validation completed."

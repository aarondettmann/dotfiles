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
  --strict-tools  Fail if optional tools (shellcheck, pwsh) are missing.
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

if require_or_skip pwsh "PowerShell syntax/analyzer checks"; then
    echo "Running PowerShell syntax checks..."
    # shellcheck disable=SC2016
    pwsh -NoLogo -NoProfile -Command '
      $files = git ls-files "*.ps1"
      foreach ($file in $files) {
        [void][System.Management.Automation.Language.Parser]::ParseFile($file, [ref]$null, [ref]$null)
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

      $results = @()
      foreach ($file in $files) {
        $results += Invoke-ScriptAnalyzer -Path $file -Severity Warning,Error
      }

      if ($results.Count -gt 0) {
        $results | Format-Table -AutoSize | Out-String | Write-Host
        throw "PSScriptAnalyzer found issues."
      }
    '
fi

echo "Config validation completed."

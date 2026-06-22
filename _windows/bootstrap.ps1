param(
    [string]$DotfilesDir = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path,
    [switch]$SkipGitConfig,
    [switch]$SkipVimConfig
)

$ErrorActionPreference = "Stop"
$env:HOME = "$env:HOMEDRIVE$env:HOMEPATH"

if (-not (Test-Path -LiteralPath $DotfilesDir)) {
    throw "Dotfiles directory not found: $DotfilesDir"
}

$resolvedDotfilesDir = (Resolve-Path -LiteralPath $DotfilesDir).Path
[Environment]::SetEnvironmentVariable("DOTFILES_DIR", $resolvedDotfilesDir, "User")
$env:DOTFILES_DIR = $resolvedDotfilesDir

function Copy-Dotfile {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source file not found: $Source"
    }

    $destinationDir = Split-Path -Parent $Destination
    if ($destinationDir -and -not (Test-Path -LiteralPath $destinationDir)) {
        New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
    }

    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    Write-Host "Updated $Destination"
}

function Resolve-WindowsTerminalSettingsPath {
    $candidateDirectories = @(
        (Join-Path $env:LocalAppData "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"),
        (Join-Path $env:LocalAppData "Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState"),
        (Join-Path $env:LocalAppData "Microsoft\Windows Terminal"),
        (Join-Path $env:LocalAppData "Microsoft\Windows Terminal Preview")
    )

    foreach ($directory in $candidateDirectories) {
        if (Test-Path -LiteralPath $directory) {
            return (Join-Path $directory "settings.json")
        }
    }

    throw "Windows Terminal settings directory not found. Start Windows Terminal once, then run bootstrap again."
}

$windowsDir = Join-Path $resolvedDotfilesDir "_windows"
$terminalSettingsPath = Resolve-WindowsTerminalSettingsPath
Copy-Dotfile -Source (Join-Path $windowsDir "powershell_settings.ps1") -Destination $PROFILE
Copy-Dotfile -Source (Join-Path $windowsDir "windows_terminal_settings.json") -Destination $terminalSettingsPath

if (-not $SkipGitConfig) {
    Copy-Dotfile -Source (Join-Path $resolvedDotfilesDir "git\.gitconfig") -Destination (Join-Path $HOME ".gitconfig")
}

if (-not $SkipVimConfig) {
    $vimConfigSource = Join-Path $windowsDir "_vimrc"

    Copy-Dotfile -Source $vimConfigSource -Destination (Join-Path $HOME "AppData\Local\nvim\init.vim")

    foreach ($target in @(
        "C:\Program Files (x86)\Vim\_vimrc",
        "C:\tools\vim\_vimrc"
    )) {
        $targetDir = Split-Path -Parent $target
        if (Test-Path -LiteralPath $targetDir) {
            Copy-Dotfile -Source $vimConfigSource -Destination $target
        }
    }
}

Write-Host "DOTFILES_DIR set to $resolvedDotfilesDir"
Write-Host "Done."

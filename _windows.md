# Windows

* Install Chocolatey (https://chocolatey.org/install)

* 7zip
* autoruns
* curl
* firefox
* gimp
* git
* inkscape
* keepassxc
* microsoft-windows-terminal
* neovim
* notepadplusplus
* python
* vim
* vlc
* wget

* Install
    * Add to *neovim*
        * ``pip install --user neovim jedi``
    * Hack font (https://github.com/source-foundry/Hack)

* Add to AutoRun programs
    * _windows/fua.bat

(PowerShell with admin rights)

```powershell
# Install dotfiles repo
New-Item -ItemType Directory -Force "$HOME\.dotfiles" | Out-Null
Set-Location "$HOME\.dotfiles"
git clone https://github.com/aarondettmann/dotfiles.git
Set-Location .\dotfiles

# Set and persist repository location for Vim/PowerShell config lookups
$env:DOTFILES_DIR = (Resolve-Path .).Path
[Environment]::SetEnvironmentVariable("DOTFILES_DIR", $env:DOTFILES_DIR, "User")

# Install Vim config (place config file in installation folder)
Copy-Item .\_windows\_vimrc "C:\Program Files (x86)\Vim\_vimrc"

# Or with Chocolatey
Copy-Item .\_windows\_vimrc "C:\tools\vim\_vimrc"

# Neovim
Copy-Item .\_windows\_vimrc "$HOME\AppData\Local\nvim\init.vim"

# Install Git config
$env:HOME = "$env:HOMEDRIVE$env:HOMEPATH"
Copy-Item .\git\.gitconfig $HOME

# Install Powershell settings
Copy-Item .\_windows\powershell_settings.ps1 $PROFILE

# Install Windows Terminal settings
Copy-Item .\_windows\windows_terminal_settings.json "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
```

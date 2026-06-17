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

(PowerShell; use admin rights if you want to copy Vim config into `C:\Program Files (x86)\Vim`)

```powershell
# Install dotfiles repo
New-Item -ItemType Directory -Force "$HOME\.dotfiles" | Out-Null
Set-Location "$HOME\.dotfiles"
git clone https://github.com/aarondettmann/dotfiles.git
Set-Location .\dotfiles

# If needed once (for local script execution)
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# Install/update tracked config files idempotently
.\_windows\bootstrap.ps1

# Optional switches
# .\_windows\bootstrap.ps1 -SkipVimConfig
# .\_windows\bootstrap.ps1 -SkipGitConfig
```

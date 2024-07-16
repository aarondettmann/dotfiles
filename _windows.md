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

(Shell with admin rights)

```sh
# Install dotfile repo
$ mkdir C:\myconf
$ cd C:\myconf
$ git clone https://github.com/aarondettmann/dotfiles.git
$ cd dotfiles

# Install Vim config (place config file in installation folder)
$ cp _windows/_vimrc "C:\Program Files (x86)\Vim"

# Or with Chocolatey
$ cp _windows/_vimrc C:\tools\vim

# Neovim
$ cp .\_vimrc ~/AppData/Local/nvim/init.vim

# Install Git config
set HOME="$HOMEDRIVE$HOMEPATH"
cp .\git\.gitconfig $HOME

# Install Powershell settings
cp _windows\powershell_settings.ps1 $PROFILE

# Install Windows Terminal settings
cp _windows\windows_terminal_settings.json $env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
```

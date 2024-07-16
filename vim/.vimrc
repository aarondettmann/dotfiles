"  _    ___                        __  __  _
" | |  / (_)___ ___     ________  / /_/ /_(_)___  ____ ______
" | | / / / __ `__ \   / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
" | |/ / / / / / / /  (__  )  __/ /_/ /_/ / / / / /_/ (__  )
" |___/_/_/ /_/ /_/  /____/\___/\__/\__/_/_/ /_/\__, /____/
"                                              /____/

" ---------- SOURCE CONFIG FILES ----------

" Source if file exists
function! SourceIfExists(file)
    if filereadable(expand(a:file))
        exe 'source' a:file
    endif
endfunction

" TODO:
" * Clean up mess
" * Explicit paths needed if RTP set?
if has('win32')
    set rtp^=C:\myconf\dotfiles\vim\.vim
    call SourceIfExists('C:\myconf\dotfiles\vim\.vim\my_config\plugins.vim')
    call SourceIfExists('C:\myconf\dotfiles\vim\.vim\my_config\basic_settings.vim')
    call SourceIfExists('C:\myconf\dotfiles\vim\.vim\my_config\mappings.vim')
    call SourceIfExists('C:\myconf\dotfiles\vim\.vim\my_config\abbreviations.vim')
elseif has('unix')
    call SourceIfExists("~/.vim/my_config/plugins.vim")
    call SourceIfExists("~/.vim/my_config/basic_settings.vim")
    call SourceIfExists("~/.vim/my_config/mappings.vim")
    call SourceIfExists("~/.vim/my_config/abbreviations.vim")
    call SourceIfExists("~/.vimrc_priv") " Private settings
endif

"  _    ___                        __  __  _
" | |  / (_)___ ___     ________  / /_/ /_(_)___  ____ ______
" | | / / / __ `__ \   / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
" | |/ / / / / / / /  (__  )  __/ /_/ /_/ / / / / /_/ (__  )
" |___/_/_/ /_/ /_/  /____/\___/\__/\__/_/_/ /_/\__, /____/
"                                              /____/

" ---------- SOURCE CONFIG FILES ----------

" Source if file exists
function! SourceIfExists(file)
    let l:path = expand(a:file)
    if filereadable(l:path)
        execute 'source' fnameescape(l:path)
    endif
endfunction

call SourceIfExists("~/.vim/my_config/plugins.vim")
call SourceIfExists("~/.vim/my_config/basic_settings.vim")
call SourceIfExists("~/.vim/my_config/mappings.vim")
call SourceIfExists("~/.vim/my_config/abbreviations.vim")

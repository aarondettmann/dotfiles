"  ________
" < neovim >
"  --------
"   \
"    \   \_\_    _/_/
"     \      \__/
"            (oo)\_______
"            (__)\       )\/\
"                ||----w |
"                ||     ||

let s:shared_vimrc = expand('~/.vimrc')
if filereadable(s:shared_vimrc)
    execute 'source' fnameescape(s:shared_vimrc)
endif
unlet s:shared_vimrc

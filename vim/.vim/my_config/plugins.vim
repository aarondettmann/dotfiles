" ---------- PLUGINS ----------

" VIM-PLUG plugin manager (https://github.com/junegunn/vim-plug)
" TODO:
" * Clean up mess
if has('win32')
    if has('nvim') && empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/AppData/Local/nvim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    elseif empty(glob('C:\myconf\dotfiles\vim\.vim\autoload\plug.vim'))
        silent !curl -fLo C:\myconf\dotfiles\vim\.vim\autoload\plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('C:\myconf\dotfiles\vim\.vim\plugged')
elseif has('unix')
    if has('nvim') && empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    elseif empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.vim/plugged')
endif

Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'bronson/vim-visual-star-search'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'nvie/vim-flake8'
Plug 'scrooloose/nerdtree'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'

" Snipptes and completion
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'zchee/deoplete-jedi'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()

" Shortcut for updating VIM-PLUG and all other plugins
command! PU w | source $MYVIMRC | PlugUpdate | PlugUpgrade

" ------------------------------
" ----- Not used regularly -----
" Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
" Plug 'altercation/vim-colors-solarized'
" Plug 'elzr/vim-json'
" Plug 'godlygeek/tabular'
" Plug 'nathanaelkane/vim-indent-guides'

" " VIM-INDENT-GUIDES
" let g:indent_guides_enable_on_vim_startup = 0
" let g:indent_guides_start_level           = 1
" let g:indent_guides_guide_size            = 1
"
" " TEX-CONCEAL
" set conceallevel=2
" let g:tex_conceal="abdgm"
" ----- Not used regularly -----
" ------------------------------

" ---------- PLUGIN SETTINGS ----------

" NERDTREE
let NERDTreeShowHidden = 1

" GRUVBOX
let g:gruvbox_contrast_dark = 'hard' " Options: soft, medium (default), hard

" VIM-COLORS-SOLARIZED
let g:solarized_contrast   = "high" " default value is normal
let g:solarized_visibility = "high" " default value is normal
let g:solarized_diffmode   = "high" " default value is normal

" VIM-AIRLINE
let g:airline#extensions#tabline#enabled   = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" VIM-AIRLINE-THEMES
let g:airline_theme='gruvbox'

" SYNTASTIC
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list            = 0
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_python_python_exec       = 'python3'

" VIMTEX
let g:vimtex_compiler_latexmk = {
    \ 'backend'    : 'jobs',
    \ 'background' : 1,
    \ 'build_dir'  : 'build',
    \ 'callback'   : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'options'    : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" ULTISNIPS
let g:UltiSnipsExpandTrigger       = "<S-Tab>"
let g:UltiSnipsJumpForwardTrigger  = "<C-b>"
let g:UltiSnipsJumpBackwardTrigger = "<C-z>"

" " DEOPLETE
" let g:deoplete#enable_at_startup = 1

" JEDI-VIM
let g:jedi#use_splits_not_buffers = "right"

" EDITORCONFIG-VIM
let g:EditorConfig_exclude_patterns   = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_max_line_indicator = "line"

" VIM-COMMENTARY
" Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s

" FZF.VIM
let g:fzf_layout={'down': '70%'}

" FLAKE8
let g:flake8_quickfix_height=15

" SUPERTAB
let g:SuperTabDefaultCompletionType = "<c-n>"

if has('win32')
    let g:python3_host_prog = 'C:\Python38\python.EXE'
endif

" ---------- PLUGINS ----------

" VIM-PLUG plugin manager (https://github.com/junegunn/vim-plug)
if has('win32')
    if has('nvim')
        let s:plug_autoload = stdpath('data') . '/site/autoload/plug.vim'
        let s:plugged_dir = stdpath('data') . '/plugged'
    else
        let s:dotfiles_dir = exists('$DOTFILES_DIR') && !empty($DOTFILES_DIR)
                    \ ? substitute($DOTFILES_DIR, '\\', '/', 'g')
                    \ : expand('~/.dotfiles/dotfiles')
        let s:plug_autoload = s:dotfiles_dir . '/vim/.vim/autoload/plug.vim'
        let s:plugged_dir = s:dotfiles_dir . '/vim/.vim/plugged'
        unlet s:dotfiles_dir
    endif
elseif has('unix')
    if has('nvim')
        let s:plug_autoload = stdpath('data') . '/site/autoload/plug.vim'
        let s:plugged_dir = stdpath('data') . '/plugged'
    else
        let s:plug_autoload = expand('~/.vim/autoload/plug.vim')
        let s:plugged_dir = expand('~/.vim/plugged')
    endif
else
    finish
endif

if empty(glob(s:plug_autoload))
    let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/0.14.0/plug.vim'
    let s:plug_sha256 = '20b4c895f98d13848204698068c4dd031730d4e7c9c4b630d6273b9b9afcdcdb'
    execute 'silent !curl -fsSLo ' . shellescape(s:plug_autoload) . ' --create-dirs ' . shellescape(s:plug_url)
    if executable('sha256sum')
        let s:plug_hash = get(split(system('sha256sum ' . shellescape(s:plug_autoload))), 0, '')
        if empty(s:plug_hash) || s:plug_hash !=# s:plug_sha256
            call delete(s:plug_autoload)
            echohl ErrorMsg
            echom 'vim-plug bootstrap failed: SHA256 mismatch.'
            echohl None
            finish
        endif
        unlet s:plug_hash
    else
        echom 'Warning: sha256sum not available; skipped vim-plug checksum verification.'
    endif
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    unlet s:plug_url s:plug_sha256
endif

call plug#begin(s:plugged_dir)
unlet s:plug_autoload s:plugged_dir

Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'bronson/vim-visual-star-search'
Plug 'davidhalter/jedi-vim'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
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
Plug 'dense-analysis/ale'

" Snipptes and completion
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Shortcut for updating VIM-PLUG and all other plugins
command! PU w | source $MYVIMRC | PlugUpdate | PlugUpgrade

" ---------- PLUGIN SETTINGS ----------

" NERDTREE
let NERDTreeShowHidden = 1

" GRUVBOX
let g:gruvbox_contrast_dark = 'hard' " Options: soft, medium (default), hard

" VIM-AIRLINE
let g:airline#extensions#tabline#enabled   = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" VIM-AIRLINE-THEMES
let g:airline_theme='gruvbox'

" ALE
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_list_window_size = 15
let g:ale_linters = {'python': ['flake8']}
let g:ale_python_flake8_executable = 'flake8'

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

" COC.NVIM (completion/navigation)
let s:node_major = -1
let s:node_minor = -1
if executable('node')
    let g:coc_node_path = exepath('node')
    let s:node_version = substitute(system(shellescape(g:coc_node_path) . ' -v'), '\n\+$', '', '')
    let s:node_parts = split(substitute(s:node_version, '^v', '', ''), '\.')
    if len(s:node_parts) >= 1
        let s:node_major = str2nr(s:node_parts[0])
    endif
    if len(s:node_parts) >= 2
        let s:node_minor = str2nr(s:node_parts[1])
    endif
endif

let g:dotfiles_use_coc_completion = (s:node_major > 20) || (s:node_major == 20 && s:node_minor >= 19)
if g:dotfiles_use_coc_completion
    let g:coc_global_extensions = ['coc-json', 'coc-pyright', 'coc-snippets']
    let g:coc_start_at_startup = 1
else
    let g:coc_global_extensions = []
    let g:coc_start_at_startup = 0
endif

if exists('s:node_parts')
    unlet s:node_parts
endif
if exists('s:node_version')
    unlet s:node_version
endif
unlet s:node_major s:node_minor

if exists('g:coc_user_config')
    let g:coc_user_config['diagnostic.enable'] = v:false
else
    let g:coc_user_config = {'diagnostic.enable': v:false}
endif

let g:coc_disable_startup_warning = 1
let g:coc_enable_locationlist = 0
let g:coc_enable_quickfix = 0
set completeopt=menuone,noselect
set shortmess+=c

" JEDI-VIM
let g:jedi#use_splits_not_buffers = "right"
if get(g:, 'dotfiles_use_coc_completion', 0)
    let g:jedi#completions_enabled = 0
else
    let g:jedi#completions_enabled = 1
endif

" EDITORCONFIG-VIM
let g:EditorConfig_exclude_patterns   = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_max_line_indicator = "line"

" VIM-COMMENTARY
" Matlab comments
autocmd FileType matlab setlocal commentstring=%\ %s

" FZF.VIM
let g:fzf_layout={'down': '70%'}

" SUPERTAB
let g:SuperTabDefaultCompletionType = "<c-n>"

if has('win32')
    let s:python3_host = exepath('python3')
    if empty(s:python3_host)
        let s:python3_host = exepath('python')
    endif
    if !empty(s:python3_host)
        let g:python3_host_prog = s:python3_host
    endif
    unlet s:python3_host
endif

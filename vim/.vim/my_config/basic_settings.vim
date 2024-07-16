" ---------- BASIC SETTINGS ----------

set encoding=utf-8  " Standard character encoding

" Standard shell
if has('win32')
    set shell=C:\Windows\System32\cmd.exe
elseif has('unix')
    set shell=/bin/bash
endif

syntax enable 	    " Syntax highlighting

if ! has("nvim")
    " packadd! matchit          " Load Vim's matchit plugin
    filetype plugin indent on " Turns on 'detection', 'plug-in' and 'indent'
    set showcmd               " Show command in bottom bar
    set ruler                 " Show line and column number of cursor position
    set hlsearch              " Highlight matches
    set incsearch             " Search results are highlighted while typing
    set autoindent            " Indent from current line when starting a new line
    set backspace=2           " Backspace over autoindent/line break/start of insert
    set autoread              " Automatically read external file changes
    set smarttab
endif

set confirm          " Dialogue when an operation has to be confirmed
set visualbell t_vb= " Visual bell instead of beeping
set mouse=a          " Enable use of the mouse for all modes
set notimeout ttimeout ttimeoutlen=100 " Quickly time out on keycodes, but never time out on mappings (?)

set shortmess+=I          " Do not show Vim standard startup message
set number relativenumber " Show relative line numbers
set cursorline            " Highlight current line
set laststatus=2          " Always display the status line
set cmdheight=2           " Number of screen lines to use for command-line
set scrolloff=1           " Vertical scroll offset
set sidescrolloff=5       " Horizontal scroll offset
set linebreak             " Wrap text at full words
set showbreak=@           " Characters indicating line wrapping
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:$ " Invisibles

set showmatch             " Highlight matching brackets
set shiftwidth=4 softtabstop=4 expandtab " Use 4 spaces instead of tabs
set smartindent

set wildmode=longest,list   " Bash-shell-like autocompletion
set history=1000            " Last 1000 commands are recorded in command line (:)
set hidden                  " Makes it easier to create hidden buffers
set path+=./**              " :find looks for files in all subdirectories
set foldlevelstart=10       " Open most folds by default
set foldmethod=indent       " Fold based on indent level
set wildignore+=*.swp,*.zip " Patterns to ignore when expanding wildcards
set complete+=kspell        " Autocomplete with dictionary words when spell check is on

set nostartofline    " Keep horizontal cursor position when scrolling
set nrformats-=octal
set formatoptions+=j " Delete comment character when joining commented lines
set spelllang=en_gb  " Standard language for spell checking
                     " --> other important languages:
                     "     - en_us : USA
                     "     - de_20 : new German spelling

" set autowrite         " Automatically :write before running commands
set splitright        " Vsplit to the right side
set nojoinspaces      " Use one space, not two, after punctuation.
set diffopt+=vertical " Always use vertical diffs
set updatetime=100

set background=dark " Always use dark mode

" Standard colorscheme
if has('win32') && !has('nvim') && !has('gui_running')
    colorscheme ron
else
    colorscheme gruvbox
endif
" ----------
set textwidth=0
set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#2c2d27

" " Make undo persist between sessions
" set undofile
" set undodir=~/.cache/vim/undo

" if !isdirectory(&undodir)
"     call mkdir(&undodir, 'p')
" endif

" " Don't save undo history for specific files (security)
" augroup no_undo_files
"     autocmd!
"     autocmd BufWritePre /tmp/*,/etc/hosts
"                 \ setlocal noundofile
" augroup END

if has("nvim")
    set inccommand=split

    " Terminal cursor color
    highlight! link TermCursor Cursor
    highlight! TermCursorNC guibg=green guifg=white ctermbg=10 ctermfg=15
endif


" ---------- BASIC SETTINGS ----------

set encoding=utf-8  " Standard character encoding

" Standard shell
if has('win32')
    set shell=C:\Windows\System32\cmd.exe
elseif has('unix')
    set shell=/bin/bash
endif

syntax enable        " Syntax highlighting

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
set breakindent           " Preserve indentation on wrapped lines
set linebreak             " Wrap text at full words
set showbreak=@           " Characters indicating line wrapping
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:$ " Invisibles

set showmatch             " Highlight matching brackets
set shiftwidth=4 softtabstop=4 expandtab " Use 4 spaces instead of tabs
set smartindent
set ignorecase smartcase  " Case-insensitive search unless uppercase is used

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
set spelllang=en_us  " Standard language for spell checking
                     " --> other important languages:
                     "     - en_us : USA
                     "     - de_20 : new German spelling

" set autowrite         " Automatically :write before running commands
set splitbelow        " Split below the current window
set splitright        " Vsplit to the right side
set nojoinspaces      " Use one space, not two, after punctuation.
set diffopt+=vertical " Always use vertical diffs
set updatetime=100

set background=dark " Always use dark mode

" Standard colorscheme
if has('win32') && !has('gui_running')
    colorscheme ron
else
    colorscheme gruvbox
endif
" ----------
set textwidth=0
set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#2c2d27

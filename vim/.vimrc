"  _    ___                        __  __  _
" | |  / (_)___ ___     ________  / /_/ /_(_)___  ____ ______
" | | / / / __ `__ \   / ___/ _ \/ __/ __/ / __ \/ __ `/ ___/
" | |/ / / / / / / /  (__  )  __/ /_/ /_/ / / / / /_/ (__  )
" |___/_/_/ /_/ /_/  /____/\___/\__/\__/_/_/ /_/\__, /____/
"                                              /____/
"
" Stripped-down, plugin-free Vim config kept as a fallback for emergency
" root/remote use. Day-to-day editing happens in Neovim (see neovim/);
" settings and mappings mirror the Neovim setup where practical.

" ---------- BASIC SETTINGS ----------

set encoding=utf-8
set shell=/bin/bash

filetype plugin indent on
syntax enable
set background=dark
silent! colorscheme habamax

set backspace=indent,eol,start " Sane backspace (defaults.vim is skipped when a vimrc exists)
set confirm                    " Dialogue when an operation has to be confirmed
set visualbell t_vb=           " Visual bell instead of beeping
set mouse=a                    " Enable use of the mouse for all modes
set notimeout ttimeout ttimeoutlen=100 " Time out on keycodes, never on mappings
set autoread                   " Pick up external changes to unmodified buffers

set shortmess+=I          " Do not show Vim standard startup message
set number relativenumber " Show relative line numbers
set cursorline            " Highlight current line
set laststatus=2 ruler    " Always show the status line, with cursor position
set display=lastline      " Show as much as possible of a long wrapped last line
set scrolloff=8           " Vertical scroll offset
set sidescrolloff=5       " Horizontal scroll offset
set breakindent           " Preserve indentation on wrapped lines
set linebreak             " Wrap text at full words
set showbreak=@           " Characters indicating line wrapping
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,eol:$ " Invisibles
set colorcolumn=80

set showmatch             " Highlight matching brackets
set shiftwidth=4 softtabstop=4 expandtab " Use 4 spaces instead of tabs
set smartindent
set ignorecase smartcase  " Case-insensitive search unless uppercase is used
set incsearch hlsearch    " Search while typing, highlight matches

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

set splitbelow        " Split below the current window
set splitright        " Vsplit to the right side
set nojoinspaces      " Use one space, not two, after punctuation.
set diffopt+=vertical " Always use vertical diffs
set updatetime=100

" Persistent undo across sessions (Neovim has this via `undofile` too)
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p', 0700)
endif
set undofile undodir=~/.vim/undo//

" Use ripgrep for :grep when available
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
    set grepformat=%f:%l:%c:%m
endif

" ---------- AUTOCOMMANDS ----------

augroup vimrc
    autocmd!
    " Open the quickfix window after :grep / :vimgrep
    autocmd QuickFixCmdPost [^l]* cwindow
augroup END

" ---------- GENERAL MAPPINGS ----------

let mapleader = " "

" Moving through buffer list
nnoremap <silent> <C-Right> :bnext<CR>
nnoremap <silent> <C-Left>  :bprevious<CR>

" Navigating between split windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Navigate display lines (visible wrapped lines) with jk and <Up>/<Down>
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk
xnoremap j gj
xnoremap k gk
xnoremap <Down> gj
xnoremap <Up>   gk

" In Vims command-line prompt: typing %% automatically expands to path of active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Create pairing brackets in insert mode
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR>  {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Tab starts keyword completion, then cycles completion items
inoremap <expr> <Tab> pumvisible()
      \ ? "\<C-n>"
      \ : "\<C-x>\<C-n>"
inoremap <expr> <S-Tab> pumvisible()
      \ ? "\<C-p>"
      \ : "\<S-Tab>"

" ---------- FUNCTION KEY MAPPINGS ----------

" Source vimrc
nnoremap <F2> :source $MYVIMRC<CR>

" Strip trailing whitespace
nnoremap <silent> <F5> :%s/\s\+$//e<CR>

" ---------- LEADER KEY MAPPINGS ----------

" System clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+yy
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P

" Execute the current line of text as a shell command.
" Keep this on an explicit leader mapping to avoid accidental execution.
nnoremap <leader>! !!$SHELL<CR>

" ROT13 the entire buffer
nnoremap <leader>c ggg?G

" Shortcut to edit...
" - bashrc
" - vimrc
nnoremap <silent> <leader>eb :e $HOME/.bashrc<CR>
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

" Buffer management
nnoremap <silent> <leader>bn :enew<CR>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>bD :bdelete!<CR>

" Search helpers (leave the command line open; Tab completes)
nnoremap <leader>sf :find<Space>
nnoremap <leader>sg :grep<Space>
nnoremap <leader>sh :help<Space>

" Simple formatting
nnoremap <silent> <leader>f mzgg=G`z
xnoremap <silent> <leader>f =

" Toggle for showing invisibles (tabs, carriage returns, ...)
nnoremap <silent> <leader>tl :set list!<CR>

" Toggle line wrapping
nnoremap <silent> <leader>tw :setlocal wrap!<CR>

" Toggle spell checking on and off
nnoremap <silent> <leader>tst :setlocal spell!<CR>

" Change language for spell checking
" tse : English (US)
" tsg : German
" tss : Swedish
nnoremap <silent> <leader>tse :setlocal spelllang=en_us<CR>
nnoremap <silent> <leader>tsg :setlocal spelllang=de<CR>
nnoremap <silent> <leader>tss :setlocal spelllang=sv<CR>

" Open terminal
nnoremap <silent> <leader>tt :terminal<CR>

" Turn off search highlight
nnoremap <silent> <leader>h :nohlsearch<CR>

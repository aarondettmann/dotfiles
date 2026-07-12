" ---------- GENERAL KEY REMAPPING ----------

" NORMAL MODE
" VISUAL MODE
" INSERT MODE
" COMMAND MODE
" TERMINAL MODE

let mapleader = " "
noremap \ <Space>

" --------------------------------------
" ---------- GENERAL MAPPINGS ----------
" --------------------------------------

" Moving through buffer list
nmap <silent> <C-Right> :bnext<CR>
nmap <silent> <C-Left>  :bprevious<CR>
nmap <silent> <C-Del>   :bdelete<CR>
nmap <silent> <C-S-Del> :bdelete!<CR>

" Navigating between split windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Swap meaning marker jumps
nnoremap ' `
nnoremap ` '

" Remove entire words in insert mode (backwards and forward)
inoremap <C-BS> <C-w>
inoremap <C-Del> <C-o>daw

" Copy & paste to clipboard with <C-c> and <C-v>
vmap     <C-c> "+y
inoremap <C-v> <C-r>+

" (Plugin) VIM-UNIMPAIRED
" Bubble single lines
nmap <C-Up>   [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up>   [egv
vmap <C-Down> ]egv

" (Plugin) NERDTREE
map <silent> <C-n> :NERDTreeToggle<CR>

" (Plugin) FZF
nnoremap <C-p> :<C-u>FZF<CR>

" Move by VISUAL line (wrapped lines treated as separate lines)
nnoremap  j gj
nnoremap gj  j
nnoremap  k gk
nnoremap gk  k
nnoremap  $ g$
nnoremap g$  $
nnoremap  0 g0
nnoremap g0  0
nnoremap  ^ g^
nnoremap g^  ^
nnoremap  <Up>   g<Up>
nnoremap g<Up>    <Up>
nnoremap  <Down> g<Down>
nnoremap g<Down>  <Down>

" " Move by VISUAL line in INSERT MODE too
" " ----- Mapping interferes with auto-completion list -----
" inoremap <Up>   <C-o>g<Up>
" inoremap <Down> <C-o>g<Down>

" FOR GERMAN KEYBOARD: Use "ö" and "ä" to flip through character searches
nnoremap ö ;
nnoremap ä ,

" Highlight last inserted text
nnoremap gV `[v`]

" In Vims command-line prompt: typing %% automatically expands to path of active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Execute the current line of text as a shell command.
" Keep this on an explicit leader mapping to avoid accidental execution.
nnoremap <leader>! !!$SHELL<CR>

" Space open/closes folds
" nnoremap <space> za

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

if get(g:, 'dotfiles_use_coc_completion', 0) && exists('*coc#refresh')
    " Trigger completion explicitly while keeping existing Tab/S-Tab snippet behavior.
    inoremap <silent><expr> <C-Space> coc#refresh()
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
endif

" Fix last spelling mistakes in insert mode
inoremap <C-s> <C-g>u<Esc>[s1z=`]a<C-g>u

" -------------------------------------------
" ---------- FUNCTION KEY MAPPINGS ----------
" -------------------------------------------

" Source vimrc
nnoremap <F2> :source $MYVIMRC<CR>

" (Plugin) STRIP-TRAILING-WHITESPACE
nnoremap <F5> :FixWhitespace<CR>

" Compress whitespace in a visual selection
"   --> Replace two or more '{2,}' whitespaces '\s' with a single space
"       character, but only if preceded '\@<=' by one or more non-whitespace
"       characters '\S'
"   --> For instance useful to convert THIS:
"
"        foo   =      1729
"        bar  =   42
"
"       ... TO THIS:
"
"        foo = 1729
"        bar = 42
vmap <F5> :s/\(\S\+\)\@<=\s\{2,\}/ /g<CR>

" Add spaces to "="
vmap <F6> :s/\(\S\+\)\@<==/ = /g<CR>

" Window splits
nmap <F9> :vsplit<CR>
nmap <F10> :split<CR>

" Toggle paste-option
set pastetoggle=<F11>

" -----------------------------------------
" ---------- LEADER KEY MAPPINGS ----------
" -----------------------------------------

" ROT13 the entire file
nmap <leader>c ggg?G

" Shortcut to edit...
" - bashrc
" - vimrc
nmap <leader>fb :e $HOME/.bashrc<CR>
nmap <leader>fv :e $MYVIMRC<CR>

" --- Git mappings ---
" (Plugin) VIM-FUGITIVE: 'git diff' and 'git status'
nmap <silent> <leader>gd :Gdiff <CR>
nmap <silent> <leader>gs :Git status<CR>
" (Plugin) VIM-GITGUTTER: Highlighting and hunks
nmap <silent> <leader>gt :GitGutterLineHighlightsToggle <CR>
nmap <leader>ghn <Plug>(GitGutterNextHunk)
nmap <leader>ghN <Plug>(GitGutterPrevHunk)
nmap <leader>ghs <Plug>(GitGutterStageHunk)
nmap <leader>ghu <Plug>(GitGutterUndoHunk)
nmap <leader>ghv <Plug>(GitGutterPreviewHunk)

" Toggle for showing invisibles (tabs, carriage returns, ...)
nnoremap <silent> <leader>l :set list!<CR>

" Open new buffer
map <silent> <leader>n :enew<CR>

" Toggle spell checking on and off
nmap <silent> <leader>s :set spell!<CR>

" Change language for spell checking
" Se : English (US)
" Sg : German
" Ss : Swedish
nmap <silent> <leader>Se :set spelllang=en_us<CR>
nmap <silent> <leader>Sg :set spelllang=de_20<CR>
nmap <silent> <leader>Ss :set spelllang=sv<CR>

" Open terminal buffer
" nmap <leader>t :vsplit <Bar> terminal<CR>
nmap <leader>t :terminal<CR>

" Map <leader>v in command-line mode to replace the commandline with the Ex command-line beneath the cursor in the buffer
cnoremap ,v <C-\>esubstitute(getline('.'), '^\s*\(' . escape(substitute(&commentstring, '%s.*$', '', ''), '*') . '\)*\s*:*' , '', '')<CR>

" Turn off search highlight
nnoremap <silent> <leader>h :nohlsearch<CR>

" Run Python code selected in visual mode
vmap <silent> <leader>p :'<,'> w !python3<CR>

vmap <leader>s :'<,'> sort<CR>
nmap <leader>v ggVG<CR>

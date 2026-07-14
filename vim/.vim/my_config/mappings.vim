" ---------- GENERAL KEY REMAPPING ----------

" NORMAL MODE
" VISUAL MODE
" INSERT MODE
" COMMAND MODE
" TERMINAL MODE

let mapleader = " "

function! s:FormatBuffer() abort
    normal! mzgg=G`z
endfunction

function! s:SearchFiles() abort
    call inputsave()
    let l:target = input('Find file: ')
    call inputrestore()

    if empty(l:target)
        return
    endif

    execute 'find ' . fnameescape(l:target)
endfunction

function! s:SearchHelp() abort
    call inputsave()
    let l:topic = input('Help topic: ')
    call inputrestore()

    if empty(l:topic)
        return
    endif

    execute 'help ' . escape(l:topic, ' ')
endfunction

function! s:SearchGrep() abort
    call inputsave()
    let l:pattern = input('Grep pattern: ')
    call inputrestore()

    if empty(l:pattern)
        return
    endif

    execute 'silent vimgrep /' . escape(l:pattern, '\/') . '/gj **/*'
    cwindow
endfunction

function! s:ToggleSpell() abort
    if &l:spell
        setlocal nospell
    else
        setlocal spell
    endif
endfunction

function! s:SetSpellLanguage(language) abort
    let &l:spelllang = a:language
endfunction

" --------------------------------------
" ---------- GENERAL MAPPINGS ----------
" --------------------------------------

" Moving through buffer list
nmap <silent> <C-Right> :bnext<CR>
nmap <silent> <C-Left>  :bprevious<CR>

" Navigating between split windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

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

" Clear highlights on search when pressing <Esc> in normal mode
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR><Esc>

" Exit terminal mode
tnoremap <Esc> <C-\><C-n>

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
xnoremap  j gj
xnoremap  k gk
xnoremap  <Up>   g<Up>
xnoremap  <Down> g<Down>

" " Move by VISUAL line in INSERT MODE too
" " ----- Mapping interferes with auto-completion list -----
" inoremap <Up>   <C-o>g<Up>
" inoremap <Down> <C-o>g<Down>

" In Vims command-line prompt: typing %% automatically expands to path of active buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Execute the current line of text as a shell command.
" Keep this on an explicit leader mapping to avoid accidental execution.
nnoremap <leader>! !!$SHELL<CR>

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

" -------------------------------------------
" ---------- FUNCTION KEY MAPPINGS ----------
" -------------------------------------------

" Source vimrc
nnoremap <F2> :source $MYVIMRC<CR>

" (Plugin) STRIP-TRAILING-WHITESPACE
nnoremap <F5> :FixWhitespace<CR>

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
nnoremap <silent> <leader>eb :e $HOME/.bashrc<CR>
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>

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

" Buffer management
nnoremap <silent> <leader>bn :enew<CR>
nnoremap <silent> <leader>bd :bdelete<CR>
nnoremap <silent> <leader>bD :bdelete!<CR>

" Search helpers
nnoremap <silent> <leader>sf :call <SID>SearchFiles()<CR>
nnoremap <silent> <leader>sg :call <SID>SearchGrep()<CR>
nnoremap <silent> <leader>sh :call <SID>SearchHelp()<CR>

" Simple formatting
nnoremap <silent> <leader>f :call <SID>FormatBuffer()<CR>
xnoremap <silent> <leader>f =

" Toggle for showing invisibles (tabs, carriage returns, ...)
nnoremap <silent> <leader>tl :set list!<CR>

" Toggle spell checking on and off
nnoremap <silent> <leader>tst :call <SID>ToggleSpell()<CR>

" Change language for spell checking
" tse : English (US)
" tsg : German
" tss : Swedish
nnoremap <silent> <leader>tse :call <SID>SetSpellLanguage('en_us')<CR>
nnoremap <silent> <leader>tsg :call <SID>SetSpellLanguage('de_20')<CR>
nnoremap <silent> <leader>tss :call <SID>SetSpellLanguage('sv')<CR>

" Open terminal
nnoremap <silent> <leader>tt :terminal<CR>

" Map <leader>v in command-line mode to replace the commandline with the Ex command-line beneath the cursor in the buffer
cnoremap ,v <C-\>esubstitute(getline('.'), '^\s*\(' . escape(substitute(&commentstring, '%s.*$', '', ''), '*') . '\)*\s*:*' , '', '')<CR>

" Turn off search highlight
nnoremap <silent> <leader>h :nohlsearch<CR>


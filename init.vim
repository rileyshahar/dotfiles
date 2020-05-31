" general
set nocompatible

" plugins
call plug#begin()                       " start plug
" appearance
Plug 'joshdick/onedark.vim'             " good color scheme
Plug 'itchyny/lightline.vim'            " statusline
Plug 'scrooloose/nerdtree'              " file tree viewer
Plug 'ap/vim-buftabline'                " buffers in tabline

" fast editing
Plug 'jiangmiao/auto-pairs'             " autoclose brackets
Plug 'preservim/nerdcommenter'          " easy commenting
Plug 'tpope/vim-surround'               " quote manipulation

" git
Plug 'tpope/vim-fugitive'               " git integration
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'airblade/vim-gitgutter'           " show git info in gutter

" code parsing
Plug 'dense-analysis/ale'               " asynchronous linter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'maximbaz/lightline-ale'           " ale on statusline

" notes
Plug 'xolox/vim-misc'                   " vim-notes dependency
Plug 'xolox/vim-notes'                  " note-taking

" python
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'numirias/semshi'                  " python syntax highlighting
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation
call plug#end()                         " end plug

" color-related
syntax enable			        " syntax processing on
colorscheme onedark                     " generic colorscheme

" tabs and spacing
set expandtab			        " turn tabs into spaces

" ui
set number			        " show line numbers
filetype indent on		        " detect filetypes and load language-specific indent files
set wildmenu			        " graphical command autocomplete menu
set showmatch			        " highlight matching bracket-like characters
set hidden                              " don't close buffers when switching to a new buffer

" search
set incsearch			        " search as characters are entered
set hlsearch			        " highlight matches
set ignorecase                          " ignore case in search
set smartcase                           " unless there are uppercase letters

" folding
set foldenable			        " enable folding
set foldlevelstart=5		        " default level to start folding
nnoremap <space> za|		        " make space toggle the current fold
set foldmethod=indent                   " fold based on language syntax file

" common keybindings
let mapleader = ","                     " \ is hard to get to
inoremap jk <esc>|                      " <esc> is hard to get to
nnoremap <leader>s :mksession<CR>|      " save the current session
map <leader>m :NERDTreeToggle<CR>|      " open the file tree
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>| " clear highlighting
" if a line is autowrapped, don't skip the second graphical line
nnoremap j gj
nnoremap k gk
" shift is hard to type
nnoremap ; :
vnoremap ; :

" make gitgutter use the correct executabl
let g:gitgutter_git_executable = '/usr/local/bin/git'
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" nerdtree
let NERDTreeQuitOnOpen = 1              " quit when you open a file
let NERDTreeMinimalUI = 1               " minimal UI

" coc
" use tab for autocompletion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <c-space> to trigger autocomplete
inoremap <silent><expr> <c-space> coc#refresh()

" add `:Fold` command to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" graphical settings they like
set cmdheight=2
set updatetime=100

" code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" show documentation
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" refactoring
nmap <leader>rn <Plug>(coc-rename)|     " rename
nmap <leader>ac <Plug>(coc-codeaction)| " code actions
nmap <leader>qf  <Plug>(coc-fix-current)

" ale
let g:ale_lint_on_insert_leave = 1      " lint on leaving insert
let g:ale_linters = {
        \ 'python': ['pylint', 'mypy', 'flake8', 'pydocstyle'],
        \ }
let g:ale_fix_on_save = 1               " run fixer on save
let g:ale_fixers = {
        \ '*' : ['remove_trailing_lines', 'trim_whitespace'],
        \ 'python': ['black', 'isort'],
        \ }
let g:ale_python_pylint_options = '--rcfile=~/code/dotfiles/.pylintrc'
" error navigation
nmap <silent> <C-K> <Plug>(ale_previous_wrap)
nmap <silent> <C-J> <Plug>(ale_next_wrap)
" display text
let g:ale_echo_msg_format = '[%linter%] %s'

" lightline
let g:lightline = {}
let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
let g:lightline.active = {
      \  'left': [[ 'mode', 'paste' ],
      \          [ 'readonly', 'filename', 'modified' ],
      \          [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]]
      \ }

" language-specific settings
" python
let g:python3_host_prog='~/.local/share/virtualenvs/dotfiles-fBLaMnxs/bin/python'       " python3 provider with pynvim installed
let g:semshi#mark_selected_nodes=2                                                      " highlight copies of the same symbol

" notes
let g:notes_directories = ['~/notes']           " change where notes save
" make the C-] combination search for @tags
imap <C-]> <C-o>:SearchNotes<CR>
nmap <C-]> :SearchNotes<CR>
" make double mouse click search for @tags
imap <2-LeftMouse> <C-o>:SearchNotes<CR>
nmap <2-LeftMouse> :SearchNotes<CR>

" project-specific settings
" botcbot (python)
autocmd FileType python map <buffer> <F9> :w<CR>:vsplit<CR><C-W>L:term<CR>ipython main.py Test Bot<cr><C-\><C-N>

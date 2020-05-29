" plugins
call plug#begin()                       " start plug
Plug 'joshdick/onedark.vim'             " good color scheme
Plug 'scrooloose/nerdtree'              " file tree viewer
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'jiangmiao/auto-pairs'             " autoclose brackets
Plug 'preservim/nerdcommenter'          " easy commenting
Plug 'tpope/vim-fugitive'               " git integration
Plug 'tpope/vim-surround'               " quote manipulation
Plug 'dense-analysis/ale'               " asynchronous linter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'itchyny/lightline.vim'            " statusline
Plug 'maximbaz/lightline-ale'           " ale on statusline
Plug 'ap/vim-buftabline'                " buffers in tabline
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'numirias/semshi'                  " python syntax highlighting
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation
Plug 'airblade/vim-gitgutter'           " show git info in gutter
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
"coc
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

"ale
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

" project-specific settings
" botcbot (python)
autocmd FileType python map <buffer> <F9> :w<CR>:vsplit<CR><C-W>L:term<CR>ipython main.py Test Bot<cr><C-\><C-N>

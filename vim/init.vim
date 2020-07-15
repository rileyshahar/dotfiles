" general
set nocompatible
let mapleader = ","                     " \ is hard to get to
let maplocalleader = "\<space>"         " ditto

" plugins
call plug#begin()                       " start plug


" appearance
Plug 'joshdick/onedark.vim'             " atom color scheme
Plug 'itchyny/lightline.vim'            " statusline
Plug 'ap/vim-buftabline'                " buffers in tabline
Plug 'mhinz/vim-startify'               " custom start menu

" file navigation
Plug 'scrooloose/nerdtree'              " file tree viewer
Plug 'tpope/vim-eunuch'                 " UNIX shell commands
Plug 'christoomey/vim-tmux-navigator'   " use <C-HJKL> to move between vim and tmux splits
Plug 'airblade/vim-rooter'              " automatically set cwd

" text objects
Plug 'kana/vim-textobj-user'            " easy custom text objects
Plug 'wellle/targets.vim'               " lots of useful text objects

" fast editing
Plug 'jiangmiao/auto-pairs'             " autoclose brackets
Plug 'preservim/nerdcommenter'          " easy commenting
Plug 'tpope/vim-surround'               " quote manipulation
Plug 'tommcdo/vim-exchange'             " exchange text objects
Plug 'simnalamburt/vim-mundo'           " undo tree viewer
Plug 'AndrewRadev/splitjoin.vim'        " switch betweeen single- and multiline statemenets
Plug 'machakann/vim-highlightedyank'    " highlight yanked text
Plug 'christoomey/vim-sort-motion'      " sort easily

" snippets
Plug 'SirVer/ultisnips'                 " snippet engine
Plug 'honza/vim-snippets'               " actual snippets

" search
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'                 " search for files
Plug 'dyng/ctrlsf.vim'                  " search within files

" testing
Plug 'vim-test/vim-test'                " automated tests

" git
Plug 'tpope/vim-fugitive'               " git integration
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'airblade/vim-gitgutter'           " show git info in gutter
Plug 'rhysd/git-messenger.vim'          " view recent commit message

" code parsing
Plug 'dense-analysis/ale'               " asynchronous linter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'maximbaz/lightline-ale'           " ale on statusline

" python
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'numirias/semshi'                  " python syntax highlighting
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation
" Plug 'heavenshell/vim-pydocstring', {'do': 'make install'}
Plug 'thalesmello/vim-textobj-multiline-str' " multiline comment object

" latex
Plug 'lervag/vimtex'                    " latex
Plug 'KeitaNakamura/tex-conceal.vim'    " concealed text

" fish scripts
Plug 'dag/vim-fish'                     " fish language support

call plug#end()                         " end plug

" color-related
syntax enable			        " syntax processing on
set termguicolors                       " fancier colors
colorscheme onedark                     " generic colorscheme

" tabs and spacing
set expandtab			        " turn tabs into spaces

" ui
set number relativenumber		" show relative line numbers
filetype indent on		        " detect filetypes and load language-specific indent files
set wildmenu			        " graphical command autocomplete menu
set showmatch			        " highlight matching bracket-like characters
set hidden                              " don't close buffers when switching to a new buffer
set conceallevel=2                      " autoconcealed text

" search
set incsearch			        " search as characters are entered
set hlsearch			        " highlight matches
set ignorecase                          " ignore case in search
set smartcase                           " unless there are uppercase letters
nnoremap <leader>f :Files<CR>|          " shortcut for fzf
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>   " search under visual selection

" ctrlsf
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
" folding
set foldenable			        " enable folding
set foldlevelstart=5		        " default level to start folding
set foldmethod=indent                   " fold based on language syntax file

" common keybindings
inoremap jk <esc>|                      " <esc> is hard to get to
nnoremap <leader>s :mksession!<CR>|     " save the current session
nnoremap <silent> <leader>l :nohlsearch<CR><C-L>| " clear highlighting
nmap Y y$|                              " this should be a default
" if a line is autowrapped, don't skip the second graphical line
nnoremap j gj
nnoremap k gk
" shift is hard to type
nnoremap ; :
vnoremap ; :
" sy to copy to the system clipboard
nnoremap sy "*y
vnoremap sy "*y
" buffer navigation
nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

" permanent undo
set undodir=~/.vimdid
set undofile
nnoremap <leader>uu :MundoToggle<CR>

" splits
" open new splits on the right and down
set splitbelow
set splitright

" yank highlighting
let g:highlightedyank_highlight_duration = -1   " make it permanent

" snippets
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-d>"
let g:UltiSnipsJumpBackwardTrigger="<c-a>"
let g:UltiSnipsEditSplit="vertical"
let g:ultisnips_python_style="numpy"

" terminal
let g:floaterm_keymap_toggle = '<F8>'

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-p> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>

" make gitgutter use the correct executabl
let g:gitgutter_git_executable = '/usr/local/bin/git'
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

" nerdtree
let NERDTreeQuitOnOpen = 1              " quit when you open a file
let NERDTreeMinimalUI = 1               " minimal UI
map <leader>m :NERDTreeToggle<CR>|      " open the file tree

" startify

" all modified git files
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" all untracked git files
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" actual config
let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   Git Modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   Git Untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

" coc
" use tab for autocompletion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

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
nnoremap <silent> W :call <SID>show_documentation()<CR>
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
        \ 'typescript': ['eslint'],
        \ 'rust': ['cargo']
        \ }
let g:ale_fix_on_save = 1               " run fixer on save
let g:ale_fixers = {
        \ '*' : ['remove_trailing_lines', 'trim_whitespace'],
        \ 'python': ['black', 'isort'],
        \ 'typescript': ['pretter'],
        \ 'rust': ['rustfmt']
        \ }
let g:ale_python_pylint_options = '--rcfile=~/code/dotfiles/python/.pylintrc'
let g:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_clippy_options =
      \'-- -W clippy::nursery -W clippy::pedantic'
" error navigation
nmap gk <Plug>(ale_previous_wrap)
nmap gj <Plug>(ale_next_wrap)
" display text
let g:ale_echo_msg_format = '[%linter%] %s'

" lightline
let g:lightline = {}
let g:lightline.colorscheme = 'onedark'
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
let g:python3_host_prog='/Users/rileyshahar/.local/share/virtualenvs/vim-R3ASTuF3/bin/python'       " python3 provider with pynvim installed
let g:semshi#mark_selected_nodes=2                                                      " highlight copies of the same symbol
let g:pydocstring_formatter = 'numpy'                   " numpy docstrings for autodoc
autocmd FileType python nnoremap <leader>dd :Pydocstring<CR>

" latex
let g:tex_flavor = 'latex'              " we never want to write og tex
let g:vimtex_view_method = 'skim'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line'
let g:tex_conceal='abdmg'

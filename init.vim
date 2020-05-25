" plugins
call plug#begin()                       " start plug
Plug 'joshdick/onedark.vim'             " good color scheme
Plug 'scrooloose/nerdtree'              " file tree viewer
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'jiangmiao/auto-pairs'             " autoclose brackets
Plug 'preservim/nerdcommenter'          " easy commenting
Plug 'liuchengxu/vista.vim'             " vista tagbar
Plug 'itchyny/lightline.vim'            " statusline
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'numirias/semshi'                  " python syntax highlighting
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation
call plug#end()                         " end plug

" color-related
syntax enable			        " syntax processing on
colorscheme onedark                     " generic colorscheme

" tabs and spacing
set expandtab			        " turn tabs into spaces

"" ui
set number			        " show line numbers
filetype indent on		        " detect filetypes and load language-specific indent files
set wildmenu			        " graphical command autocomplete menu
set showmatch			        " highlight matching bracket-like characters

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

" movement
" if a line is autowrapped, don't skip the second graphical line
nnoremap j gj
nnoremap k gk
" shift is hard to type
nnoremap ; :
vnoremap ; :

" common keybindings
let mapleader = ","                     " \ is hard to get to
inoremap jk <esc>|                      " <esc> is hard to get to
nnoremap <leader>s :mksession<CR>|      " save the current session
map <leader>m :NERDTreeToggle<CR>|      " open the file tree

" misc
let g:AutoPairsFlyMode = 1              " force closed-pair jumping


" language-specific settings
" python
let g:python3_host_prog='/usr/local/opt/python@3.8/bin/python3'         " python3 provider with pynvim installed
let g:semshi#mark_selected_nodes=2                                      " highlight copies of the same symbol
let g:semshi#no_default_builtin_highlight=v:true                        " vim shouldn't highlight builtins natively

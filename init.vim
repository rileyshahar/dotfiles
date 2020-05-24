" plugins
call plug#begin()                       " start plug
Plug 'joshdick/onedark.vim'             " good color scheme
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

" search
set incsearch			        " search as characters are entered
set hlsearch			        " highlight matches
set ignorecase                          " ignore case in search
set smartcase                           " unless there are uppercase letters

" folding
set foldenable			        " enable folding
set foldlevelstart=5		        " default level to start folding
nnoremap <space> za|		        " make space toggle the current fold
set foldmethod=syntax		        " fold based on language syntax file

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

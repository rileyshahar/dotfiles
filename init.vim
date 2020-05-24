" color-related
colorscheme solarized		        " generic colorscheme
syntax enable			        " syntax processing on

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

" folding
set foldenable			        " enable folding
set foldlevelstart=5		        " default level to start folding
nnoremap <space> za		        " make space toggle the current fold
set foldmethod=syntax		        " fold based on language syntax file

" movement
nnoremap j gj			        " if a line is autowrapped, don't skip the second graphical line
nnoremap k gk			        " ditto
nnoremap B ^			        " ^ is hard to type and moving to the beginning of a line is common
nnoremap E $			        " ditto, for the end of a line

" common keybindings
let mapleader = ","                     " \ is hard to get to
inoremap jk <esc>                       " <esc> is hard to get to
nnoremap <leader>s :mksession<CR>       " save the current session


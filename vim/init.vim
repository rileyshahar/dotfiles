" general
set nocompatible
let mapleader = ","                     " \ is hard to get to
let maplocalleader = "\<space>"         " ditto

" plugins
call plug#begin()                       " start plug

" plugin meta
Plug 'tpope/vim-repeat'                 " repeat plugin commands

" appearance
Plug 'joshdick/onedark.vim'             " atom color scheme
Plug 'itchyny/lightline.vim'            " statusline
Plug 'ap/vim-buftabline'                " buffers in tabline

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" file navigation
Plug 'scrooloose/nerdtree'              " file tree viewer
Plug 'tpope/vim-eunuch'                 " UNIX shell commands
Plug 'christoomey/vim-tmux-navigator'   " use <C-HJKL> to move between vim and tmux splits

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
Plug 'unblevable/quick-scope'           " easier inline navigation

" snippets
Plug 'SirVer/ultisnips'                 " snippet engine
Plug 'honza/vim-snippets'               " actual snippets

" completion
Plug 'nvim-lua/completion-nvim'         " nvim completion

" search
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'                 " search for files

" git
Plug 'tpope/vim-fugitive'               " git integration
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'airblade/vim-gitgutter'           " show git info in gutter
Plug 'rhysd/git-messenger.vim'          " view recent commit message

" code parsing
Plug 'neovim/nvim-lspconfig'            " neovim lsp
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'          " neovim lsp utils

" python
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'numirias/semshi'                  " python syntax highlighting
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation
" Plug 'heavenshell/vim-pydocstring', {'do': 'make install'}
Plug 'thalesmello/vim-textobj-multiline-str' " multiline comment object

" latex
Plug 'lervag/vimtex'                    " latex

" fish scripts
Plug 'dag/vim-fish'                     " fish language support

" markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()                         " end plug


" color-related
syntax enable                           " syntax processing on
set termguicolors                       " fancier colors
colorscheme onedark                     " generic colorscheme
set spell                               " spellcheck

" tabs and spacing
set expandtab                           " turn tabs into spaces

" ui
set number relativenumber               " show relative line numbers
filetype indent on                      " detect filetypes and load language-specific indent files
set wildmenu                            " graphical command autocomplete menu
set showmatch                           " highlight matching bracket-like characters
set hidden                              " don't close buffers when switching to a new buffer

" search
set incsearch                           " search as characters are entered
set hlsearch                            " highlight matches
set ignorecase                          " ignore case in search
set smartcase                           " unless there are uppercase letters
nnoremap <leader>f :Files<CR>|          " shortcut for fzf
nnoremap <c-f> :Rg |                    " search within project
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>   " search under visual selection

" folding
set foldenable                          " enable folding
set foldlevelstart=1                    " default level to start folding
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
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
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

" lightline
let g:lightline = {}
let g:lightline.colorscheme = 'onedark'
let g:lightline.active = {
                        \  'left': [[ 'mode', 'paste' ],
                        \          [ 'readonly', 'filename', 'modified' ]]
                        \ }

" neovim-lsp
" general
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> W     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ac    <cmd>lua vim.lsp.buf.code_action()<CR>

lua << EOF
require'lspconfig'.rust_analyzer.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.pyls.setup{on_attach=require'completion'.on_attach}
require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
EOF

" autoformat on save
augroup fmt
        autocmd!
        autocmd FileType python,rust,c,cpp nnoremap <localleader>f <cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>
        autocmd BufWritePre *.rs,*.c,*.cpp,*.py,*.h,*.hh lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END

" neovim-complete
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

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

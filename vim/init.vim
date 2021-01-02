" general
set nocompatible
let mapleader = ","                     " \ is hard to get to
let maplocalleader = "\<space>"         " ditto

" plugins
call plug#begin()                       " start plug

" plugin meta
Plug 'tpope/vim-repeat'                 " repeat plugin commands

" display
Plug 'joshdick/onedark.vim'             " atom color scheme
Plug 'itchyny/lightline.vim'            " statusline
Plug 'ap/vim-buftabline'                " buffers in tabline
Plug 'christoomey/vim-tmux-navigator'   " use <C-HJKL> to move between vim and tmux splits

" telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-github.nvim'

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

" git
Plug 'tpope/vim-fugitive'               " git integration
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in nerdtree
Plug 'airblade/vim-gitgutter'           " show git info in gutter
Plug 'itchyny/vim-gitbranch'            " git branch function
Plug 'rhysd/git-messenger.vim'          " view recent commit message

" code parsing
Plug 'neovim/nvim-lspconfig'            " neovim lsp
Plug 'dense-analysis/ale'               " asynchronous linter
Plug 'maximbaz/lightline-ale'           " ale on statusline
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" completion
Plug 'nvim-lua/completion-nvim'         " nvim completion

" python
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation

" latex
Plug 'lervag/vimtex'                    " latex

" fish scripts
Plug 'dag/vim-fish'                     " fish language support

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

" telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').git_bcommits()<cr>

" github telescope
lua << EOF
require('telescope').load_extension('ghcli')
EOF
nnoremap <leader>gi <cmd>lua require('telescope.builtin').gh_issues()<cr>
nnoremap <leader>gp <cmd>lua require('telescope.builtin').gh_pull_request()<cr>

" folding
set foldenable                          " enable folding
set foldlevelstart=1                    " default level to start folding
set foldmethod=expr                     " fold based on tree-sitter
set foldexpr=nvim_treesitter#foldexpr()

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
        \ 'rust': ['rustfmt'],
        \ 'cpp': ['clang-format']
        \ }
let g:ale_python_pylint_options = '--rcfile=~/code/dotfiles/python/pylintrc'
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
let g:lightline.component_function = {'gitbranch': 'gitbranch#name'}
let g:lightline.active = {
      \  'left': [[ 'mode', 'paste' ],
      \          [ 'readonly', 'filename', 'modified' ],
      \          [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
      \          [ 'gitbranch' ]]
      \ }


" neovim-lsp
" general
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> W     <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gw    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>| "note this doesn't work with telescope
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

nnoremap gr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap g0 <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>

lua << EOF
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.pyls.setup{}
require'lspconfig'.clangd.setup{}
vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end -- disable diagnostics
EOF

" neovim-complete
" Use completion-nvim in every buffer
augroup completion
        autocmd!
        autocmd BufEnter * lua require'completion'.on_attach()
augroup END

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" snippets support
let g:completion_enable_snippet = 'UltiSnips'

" tree-sitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}
EOF


" language-specific settings
" python
let g:python3_host_prog='/Users/rileyshahar/.local/share/virtualenvs/vim-R3ASTuF3/bin/python'       " python3 provider with pynvim installed

" latex
let g:tex_flavor = 'latex'              " we never want to write og tex
let g:vimtex_view_method = 'skim'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line'

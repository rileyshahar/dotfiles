"                                  _
"   __ _  ___ _ __   ___ _ __ __ _| |
"  / _` |/ _ \ '_ \ / _ \ '__/ _` | |
" | (_| |  __/ | | |  __/ | | (_| | |
"  \__, |\___|_| |_|\___|_|  \__,_|_|
"  |___/
"
set nocompatible
let mapleader = ","                     " \ is hard to get to
let maplocalleader = "\<space>"         " ditto

"        _             _
"  _ __ | |_   _  __ _(_)_ __  ___
" | '_ \| | | | |/ _` | | '_ \/ __|
" | |_) | | |_| | (_| | | | | \__ \
" | .__/|_|\__,_|\__, |_|_| |_|___/
" |_|            |___/
"
call plug#begin()                       " start plug

" plugin meta
Plug 'tpope/vim-repeat'                 " repeat plugin commands

" display
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'            " statusline

" navigation
Plug 'moll/vim-bbye'                    " exit buffer command
Plug 'ap/vim-buftabline'                " buffers in tabline
Plug 'christoomey/vim-tmux-navigator'   " use <C-HJKL> to move between vim and tmux splits

" misc
Plug 'mhinz/vim-startify'               " starting screen

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
Plug 'tpope/vim-commentary'             " easy commenting
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
Plug 'airblade/vim-gitgutter'           " show git info in gutter
Plug 'itchyny/vim-gitbranch'            " git branch function
Plug 'rhysd/git-messenger.vim'          " view recent commit message

" code parsing
Plug 'neovim/nvim-lspconfig'            " neovim lsp
Plug 'nvim-lua/lsp_extensions.nvim'     " rust inlay hints
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" completion
Plug 'nvim-lua/completion-nvim'         " nvim completion

" formatting
Plug 'sbdchd/neoformat'                 " autoformating

" python
Plug 'jeetsukumaran/vim-pythonsense'    " python motions
Plug 'Vimjas/vim-python-pep8-indent'    " python autoindentation

" latex
Plug 'lervag/vimtex'                    " latex

" fish scripts
Plug 'dag/vim-fish'                     " fish language support

" tmux
Plug 'tmux-plugins/vim-tmux'            " tmux.conf

call plug#end()                         " end plug


"        _
"  _   _(_)
" | | | | |
" | |_| | |
"  \__,_|_|
"
"
set number relativenumber               " show relative line numbers
filetype indent on                      " detect filetypes and load language-specific indent files
set wildmenu                            " graphical command autocomplete menu
set showmatch                           " highlight matching bracket-like characters
set hidden                              " don't close buffers when switching to a new buffer
set signcolumn=yes                      " always show the signcolumn

" color
syntax enable                           " syntax processing on
set termguicolors                       " fancier colors
colorscheme tokyonight                  " generic colorscheme
highlight Comment guifg=#f6bdff|        " better comment color
highlight Normal guibg=None|            " let tmux control background highlighting
highlight EndOfBuffer guibg=None
highlight NormalNC guibg=#232433|       " darken inactive windows
highlight EndOfBufferNC guibg=#232433

" tabs and spacing
set expandtab                           " turn tabs into spaces
set shiftwidth=2

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

" splits
" open new splits on the right and down
"set splitbelow
"set splitright

" figlet text
function! FigletFormat(text)
  let commentlist = split(&commentstring, '%s')
  let text = a:text
  for comment in commentlist
    if text[:len(comment)] =~ comment
      let text = text[len(comment):]
      break
    endif
  endfor
  let output = system("figlet " . shellescape(text))
  let output = substitute(l:output, "\n", "\n" . commentlist[0], "g")
  let output = substitute(l:output, "^", commentlist[0], "g")
  put =output
endfunction

nnoremap g@ <cmd>call FigletFormat(getline("."))<cr>`[kdd

"            _            _              _     _           _
"  _ __ ___ (_)___  ___  | | _____ _   _| |__ (_)_ __   __| |___
" | '_ ` _ \| / __|/ __| | |/ / _ \ | | | '_ \| | '_ \ / _` / __|
" | | | | | | \__ \ (__  |   <  __/ |_| | |_) | | | | | (_| \__ \
" |_| |_| |_|_|___/\___| |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
"                                  |___/
"
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
nnoremap X :Bdelete<CR>


"                  _
"  _   _ _ __   __| | ___
" | | | | '_ \ / _` |/ _ \
" | |_| | | | | (_| | (_) |
"  \__,_|_| |_|\__,_|\___/
"
"
" permanent undo
set undofile
nnoremap <leader>uu :MundoToggle<CR>

" yank highlighting
let g:highlightedyank_highlight_duration = -1   " make it permanent

"  _        __             _ _           _
" (_)_ __  / _| ___     __| (_)___ _ __ | | __ _ _   _ ___
" | | '_ \| |_ / _ \   / _` | / __| '_ \| |/ _` | | | / __|
" | | | | |  _| (_) | | (_| | \__ \ |_) | | (_| | |_| \__ \
" |_|_| |_|_|  \___/   \__,_|_|___/ .__/|_|\__,_|\__, |___/
"                                 |_|            |___/
"
" make gitgutter use the correct executabl
let g:gitgutter_git_executable = '/usr/local/bin/git'
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

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
let g:lightline.colorscheme = 'tokyonight'
let g:lightline.component_function = {'gitbranch': 'gitbranch#name'}
let g:lightline.active = {
      \  'left': [[ 'mode', 'paste' ],
      \          [ 'readonly', 'filename', 'modified' ],
      \          [ 'gitbranch' ]]
      \ }


"                                 _   _
"  ___  ___ _ __ ___   __ _ _ __ | |_(_) ___ ___
" / __|/ _ \ '_ ` _ \ / _` | '_ \| __| |/ __/ __|
" \__ \  __/ | | | | | (_| | | | | |_| | (__\__ \
" |___/\___|_| |_| |_|\__,_|_| |_|\__|_|\___|___/
"
"
" snippets
let g:UltiSnipsExpandTrigger = "<nop>"
inoremap <expr> <tab> pumvisible() ? "<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>" : "\<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"
let g:ultisnips_python_style="numpy"

" neovim-lsp
" general
augroup lsp
        autocmd!
        autocmd FileType rust,python,c,cpp,tex :call EnableLspKeybinds()
augroup END

function EnableLspKeybinds()
        nnoremap <silent> <c-]>         <cmd>lua vim.lsp.buf.definition()<CR>
        nnoremap <silent> K             <cmd>lua vim.lsp.buf.hover()<CR>
        nnoremap <silent> gD            <cmd>lua vim.lsp.buf.implementation()<CR>
        nnoremap <silent> W             <cmd>lua vim.lsp.buf.signature_help()<CR>
        nnoremap <silent> 1gD           <cmd>lua vim.lsp.buf.type_definition()<CR>
        nnoremap <silent> gw            <cmd>lua vim.lsp.buf.workspace_symbol()<CR>| "note this doesn't work with telescope
        nnoremap <silent> gd            <cmd>lua vim.lsp.buf.declaration()<CR>
        nnoremap <silent> ga            <cmd>lua vim.lsp.buf.code_action()<CR>
        nnoremap <silent> <leader>t     <cmd>lua require'lsp_extensions'.inlay_hints()<cr>
        nnoremap <silent> gr            <cmd>lua require('telescope.builtin').lsp_references()<cr>
        nnoremap <silent> g0            <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
        nnoremap <silent> <leader>d     <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>
        nnoremap <silent> gk            <cmd>lua vim.lsp.diagnostic.goto_prev({ wrap = true })<cr>
        nnoremap <silent> gj            <cmd>lua vim.lsp.diagnostic.goto_next({ wrap = true })<cr>
        nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<cr>
endfunction

lua << EOF
require'lspconfig'.rust_analyzer.setup{
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        overrideCommand = {"cargo", "clippy", "--tests", "--message-format=json", "--", "-W", "clippy::nursery", "-W", "clippy::pedantic", "--verbose"}
      }
    }
  }
}
require'lspconfig'.pyls.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.texlab.setup{
  settings = {
    latex = {
      lint = {
        onSave = true
      }
    }
  }
}

-- https://github.com/nvim-lua/diagnostic-nvim/issues/73
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- disable virtual text
    virtual_text = false,
  }
)
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

" neoformat
" run on save
augroup fmt
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END

" run all formatters
let g:neoformat_run_all_formatters = 1

" trim whitespace
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1

" enabled formatters
let g:neoformat_enabled_c = ["clang-format"]
let g:neoformat_enabled_cpp = ["clang-format"]
let g:neoformat_enabled_fish = ["fish_indent"]
let g:neoformat_enabled_lua = ["lua-fmt"]
let g:neoformat_enabled_python = ["black", "docformatter", "isort"]
let g:neoformat_enabled_rust = ["rustfmt"]


"  _
" | | __ _ _ __   __ _ _   _  __ _  __ _  ___       ___ _ __   ___  ___
" | |/ _` | '_ \ / _` | | | |/ _` |/ _` |/ _ \_____/ __| '_ \ / _ \/ __|
" | | (_| | | | | (_| | |_| | (_| | (_| |  __/_____\__ \ |_) |  __/ (__
" |_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___|     |___/ .__/ \___|\___|
"                |___/             |___/               |_|
"
" python
let g:python3_host_prog='/Users/rileyshahar/.local/share/virtualenvs/nvim-L1s0lsRG/bin/python'       " python3 provider with pynvim installed

" latex
let g:tex_flavor = 'latex'              " we never want to write og tex
let g:vimtex_view_method = 'skim'
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line'

" tmux
augroup tmux
        autocmd!
        autocmd BufNewFile,BufRead *.tmux set ft=tmux | compiler tmux
augroup END

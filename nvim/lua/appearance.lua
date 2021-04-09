-- prettier colors
vim.o.termguicolors = true

-- colorscheme
paq "ghifarit53/tokyonight-vim"
cmd "colorscheme tokyonight" -- todo: this is *slow as fuck*, we need to rewrite smth by hand
cmd "highlight Comment guifg=#f6bdff" -- better comment color

-- syntax highlighting
cmd "syntax enable"

-- tmux background highlighting
cmd "highlight Normal guibg=None"
cmd "highlight EndOfBuffer guibg=None"
cmd "highlight NormalNC guibg=#232433"
cmd "highlight EndOfBufferNC guibg=#232433"

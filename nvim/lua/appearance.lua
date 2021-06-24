-- prettier colors
vim.o.termguicolors = false

-- colorscheme
cmd "colorscheme inherit"

-- syntax highlighting
cmd "syntax enable"

-- tmux background highlighting
cmd "highlight Normal guibg=None"
cmd "highlight EndOfBuffer guibg=None"
cmd "highlight NormalNC guibg=#232433"
cmd "highlight EndOfBufferNC guibg=#232433"

-- better comment color
cmd "highlight Comment guifg=#f6bdff"
cmd "highlight SpecialComment guifg=#f6bdff"

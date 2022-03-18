-- prettier colors
vim.o.termguicolors = false

-- colorscheme
cmd("colorscheme inherit")

-- syntax highlighting
cmd("syntax enable")

-- better comment color
cmd("highlight Comment guifg=#f6bdff")
cmd("highlight SpecialComment guifg=#f6bdff")

require("pqf").setup()

-- prettier colors
vim.o.termguicolors = false

-- colorscheme
vim.cmd("colorscheme inherit")

-- syntax highlighting
vim.cmd("syntax enable")

-- better comment color
vim.cmd("highlight Comment guifg=#f6bdff")
vim.cmd("highlight SpecialComment guifg=#f6bdff")

-- todo: is there a better way to do this
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "

require("pqf").setup()

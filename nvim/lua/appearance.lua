-- prettier colors
vim.o.termguicolors = false

-- colorscheme
cmd("colorscheme inherit")

-- syntax highlighting
cmd("syntax enable")

-- better comment color
cmd("highlight Comment guifg=#f6bdff")
cmd("highlight SpecialComment guifg=#f6bdff")

-- todo: is there a better way to do this
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "

require("pqf").setup()

-- prettier colors
vim.o.termguicolors = false

-- conceal
vim.o.conceallevel = 2

-- colorscheme
vim.cmd("colorscheme inherit")

-- syntax highlighting
vim.cmd("syntax enable")

-- make split borders blank
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "

require("pqf").setup()

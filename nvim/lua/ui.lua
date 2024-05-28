-- prettier colorsui.
vim.o.termguicolors = true

-- colorscheme
vim.cmd("colorscheme tokyonight-night")

-- make split borders blank
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "

-- command height
vim.o.cmdheight = 1

-- conceal
vim.o.conceallevel = 2
-- vim.o.concealcursor = ""

-- splits
vim.o.splitright = true
map("<c-q>", "<cmd>q<cr>", "close split", { "i", "n", "t", "v", "x" })
map("<c-q>", "<cmd>q<cr>", "close split", { "i", "n", "t", "v", "x" })
map("<c-h>", "<cmd>wincmd h<cr>", "move to left window", "t")
map("<c-j>", "<cmd>wincmd j<cr>", "move to right window", "t")
map("<c-k>", "<cmd>wincmd k<cr>", "move to above window", "t")
map("<c-l>", "<cmd>wincmd l<cr>", "move to below window", "t")

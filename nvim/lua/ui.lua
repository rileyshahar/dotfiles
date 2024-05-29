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

-- statusline
vim.o.laststatus = 3

-- splits
vim.o.splitright = true
map("<c-q>", "<cmd>q<cr>", "close split", { "i", "n", "t", "v", "x" })
map("<c-q>", "<cmd>q<cr>", "close split", { "i", "n", "t", "v", "x" })
map("<c-h>", "<cmd>wincmd h<cr>", "move to left window", "t")
map("<c-j>", "<cmd>wincmd j<cr>", "move to right window", "t")
map("<c-k>", "<cmd>wincmd k<cr>", "move to above window", "t")
map("<c-l>", "<cmd>wincmd l<cr>", "move to below window", "t")
map("<c-m-h>", "<cmd>wincmd H<cr>", "move window to left", "t")
map("<c-m-j>", "<cmd>wincmd J<cr>", "move window to right", "t")
map("<c-m-k>", "<cmd>wincmd K<cr>", "move window above", "t")
map("<c-m-l>", "<cmd>wincmd L<cr>", "move window below", "t")

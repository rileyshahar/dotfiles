-- prettier colorsui.
vim.o.termguicolors = true

-- colorscheme
vim.cmd("colorscheme theme")

-- make split borders blank
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "

-- command height
vim.o.cmdheight = 1

-- conceal
vim.o.conceallevel = 2
vim.o.concealcursor = "n"

-- terminal
local termopen = vim.api.nvim_create_augroup("termopen", {})
local cmd = vim.api.nvim_create_autocmd("TermOpen", {
  group = termopen,
  callback = function(_)
    vim.cmd("setlocal nonumber norelativenumber")
  end
})

local termenter = vim.api.nvim_create_augroup("termenter", {})
local cmd = vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = { "fish" },
  group = termenter,
  callback = function(_)
    vim.cmd("startinsert")
  end
})

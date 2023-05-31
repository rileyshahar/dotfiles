-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- map function
function map(lhs, rhs, mode, opts)
	mode = mode or "n"
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- set leaders
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
map("<space>", "<nop>", "n")
map("<space>", "<nop>", "v")

leaders = {
	edit = "<leader>e",
	finder = "<leader>f",
	git = "<leader>g",
  goto = "g",
	make = "m",
	plugin_meta = "<leader>p",
	ui = "<leader>z"
}

require("lazy").setup("plugins")

-- shell out to modules
require("appearance")
require("completion")
require("git")
require("lsp")
require("make")
require("misc")
require("picker")
require("snippets")
require("statusline")
require("treesitter")

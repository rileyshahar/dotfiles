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
function map(lhs, rhs, desc, mode, opts)
	mode = mode or "n"

	local options = { noremap = true, desc = desc }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- set leaders
vim.g.mapleader = ","
vim.g.maplocalleader = ",,"

leaders = {
	edit = "<leader>e",
	finder = "<leader>f",
	git = "<leader>g",
	make = "<leader>m",
	notify = "<leader>n",
	plugin_meta = "<leader>p",
	go = "g",
}

-- appearance first bc some plugins (notify) rely on the colorscheme
require("lazy").setup("plugins", {
	dev = {
		path = "~/code/lua"
	}
})

-- shell out to modules
require("make")
require("misc")
require("statusline")

require("ui")

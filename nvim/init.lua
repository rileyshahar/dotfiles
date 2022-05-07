-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end


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
vim.g.maplocalleader = " "
map("<space>", "<nop>", "n")
map("<space>", "<nop>", "v")

leaders = {
	edit = "<leader>e",
	finder = "<leader>f",
	git = "<leader>g",
  goto = "g",
	plugin_meta = "<leader>p"
}

require("plugins")

-- shell out to modules
require("appearance")
require("buffers")
require("git")
require("make")
require("misc")
require("picker")
require("statusline")

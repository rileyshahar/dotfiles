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
	git = "<leader>h",
  goto = "g",
}

require("plugins")

-- shell out to modules
require("appearance")
require("buffers")
require("completion")
require("git")
require("lsp")
require("make")
require("misc")
require("picker")
require("snippets")
require("statusline")
require("treesitter")

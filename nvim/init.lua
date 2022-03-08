-- useful aliases
cmd = vim.cmd
fn = vim.fn
g = vim.g

-- map function
function map(lhs, rhs, mode, opts)
	mode = mode or "n"
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options) -- todo: use lua instead of vimscript where possible
end

-- set basics
g.mapleader = ","
map("<space>", "<nop>", "n")
map("<space>", "<nop>", "v")
cmd('let maplocalleader = "\\<space>"')

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

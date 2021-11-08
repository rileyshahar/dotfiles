-- useful aliases
cmd = vim.cmd
fn = vim.fn
g = vim.g

-- map function
function map(lhs, rhs, mode, opts)
    mode = mode or "n"
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function map_lua(lhs, rhs, mode, opts)
    map(lhs, "<cmd>lua " .. rhs .. "<cr>", mode, opts)
end

-- set basics
g.mapleader = ","
map("<space>", "<nop>")
map("<space>", "<nop>", "v")
cmd 'let maplocalleader = "\\<space>"'

require("plugins")

-- shell out to modules
require("appearance")
require("buffers")
require("completion")
require("git")
require("lsp")
require("make")
require("misc")
require("statusline")
require("snippets")
require("telescope")
require("treesitter")

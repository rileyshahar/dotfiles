-- todo: reorg this into other files

-- basic keybinds
map("jk", "<esc>", "i") -- exit insert mode
map(";", ":") -- don't type shift
map(";", ":", "v")
map("\\", ",") -- we remapped , and ;
map("<c-\\>", ";")

-- line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- filetype support
vim.o.filetype = "on"
vim.o.syntax = "on" -- syntax highlighting

-- misc
vim.o.showmatch = true -- highlight matching brackets
vim.o.hidden = true -- don't close buffers unnecessarily

-- signcolumn
vim.wo.signcolumn = "yes" -- always show the signcolumn

-- spacing
vim.bo.expandtab = true -- turn tabs into spaces
vim.o.shiftwidth = 2 -- 2 length spaces by default
vim.o.tabstop = 2 -- make tabs appear as 2 spaces

-- search
vim.o.incsearch = true -- search while typing
vim.o.hlsearch = true -- highlight matches
vim.o.ignorecase = true -- ignore case
vim.o.smartcase = true -- except when the query has uppercase letters
map("<leader>l", "<cmd>nohlsearch<cr><c-l><cmd>lua vim.lsp.buf.clear_references()<cr>")
map("Y", "y$") -- should be a default
map("*", [[y/\V<C-R>"<CR>]], "v")

-- folding
vim.wo.foldenable = true -- enable folding
vim.o.foldlevelstart = 1 -- default level to start folding at
vim.wo.foldmethod = "syntax" -- method to fold on (treesitter?)

-- goyo
map("<leader>z", "<cmd>Goyo<cr>")
vim.o.mouse = "a"

-- undo
vim.cmd("set undofile") -- persistent undo

-- autopairs
-- todo: fix
local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

npairs.add_rule(Rule("$", "$", "markdown"))

-- spell
-- todo: make spellchecker work well
map("z=", require("telescope.builtin").spell_suggest)

-- copilot
-- cmd([[ imap <silent><script><expr> <c-f> copilot#Accept("<c-f>") ]])
-- vim.g.copilot_no_tab_map = true

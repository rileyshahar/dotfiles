-- TODO: reorg this into other files

-- basic keybinds
map("jk", "<c-\\><c-n>", "exit insert mode", { "i", "t" }) -- exit insert mode
map(";", ":", "command mode", { "n", "v" })                -- don't type shift

-- move to window
map("<c-h>", "<c-w>h", "move to left window")
map("<c-j>", "<c-w>j", "move to lower window")
map("<c-k>", "<c-w>k", "move to upper window")
map("<c-l>", "<c-w>l", "move to right window")

-- resize windows
map("<c-up>", "<cmd>resize +2<cr>", "increase window height")
map("<c-down>", "<cmd>resize -2<cr>", "decrease window height")
map("<c-left>", "<cmd>vertical resize -2<cr>", "decrease window width")
map("<c-right>", "<cmd>vertical resize +2<cr>", "increase window width")

-- line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- text wrap
vim.o.textwidth = 80

-- misc
vim.o.showmatch = true -- highlight matching brackets
vim.o.hidden = true    -- don't close buffers unnecessarily

-- sign column
vim.wo.signcolumn = "yes" -- always show the sign column

-- spacing
vim.bo.expandtab = true -- turn tabs into spaces
vim.o.shiftwidth = 2    -- 2 length spaces by default
vim.o.tabstop = 2       -- make tabs appear as 2 spaces

-- search
vim.o.incsearch = true                -- search while typing
vim.o.hlsearch = true                 -- highlight matches
vim.o.ignorecase = true               -- ignore case
vim.o.smartcase = true                -- except when the query has uppercase letters
map("<leader>l", "<cmd>nohlsearch<cr><c-l><cmd>lua vim.lsp.buf.clear_references()<cr>", "clear highlights")
map("Y", "y$", "yank to end of line") -- should be a default
map("*", [[y/\V<C-R>"<CR>]], "search under cursor", "x")

-- folding
vim.wo.foldenable = true -- enable folding
vim.o.foldlevelstart = 1 -- default level to start folding at

-- TODO: do we like treesitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

-- mouse
vim.o.mouse = "a"

-- undo
vim.cmd("set undofile") -- persistent undo

-- spell
vim.o.spelllang = 'en_us'
-- vim.o.spell = true TODO: stop spellchecking strings
map("z=", function() require("telescope.builtin").spell_suggest() end, "suggest spelling replacements")

-- todo: reorg this into other files

-- basic keybinds
map("jk", "<esc>", "i")                 -- exit insert mode
map(";", ":")                           -- don't type shift
map(";", ":", "v")
map("\\", ",")                          -- we remapped , and ;
map("<c-\\>", ";")

-- line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- filetype support
vim.o.filetype = "on"                   -- todo: we need indent/maybe ftplugin support (treesitter?)
vim.o.syntax = "on"                     -- syntax highlighting

-- misc
vim.o.showmatch = true                  -- highlight matching brackets
vim.o.hidden = true                     -- don't close buffers unnecessarily

-- signcolumn
-- commented for now because of a gitsigns bug
-- vim.wo.signcolumn = "yes"            -- always show the signcolumn

-- spacing
vim.bo.expandtab = true                 -- turn tabs into spaces
vim.bo.shiftwidth = 2                   -- 2 length spaces by default

-- search
vim.o.incsearch = true                  -- search while typing
vim.o.hlsearch = true                   -- highlight matches
vim.o.ignorecase = true                 -- ignore case
vim.o.smartcase = true                  -- except when the query has uppercase letters
map("<leader>l", "<cmd>nohlsearch<cr><c-l><cmd>lua vim.lsp.buf.clear_references()<cr>")
map("Y", "y$")                          -- should be a default

-- folding
vim.wo.foldenable = true                -- enable folding
vim.o.foldlevelstart = 1                -- default level to start folding at
vim.wo.foldmethod = "syntax"            -- method to fold on (treesitter?)

-- undo
vim.bo.undofile = true                  -- persistent undo

-- misc plugins
paq 'b3nj5m1n/kommentary'               -- comment plugin

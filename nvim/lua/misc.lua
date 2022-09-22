-- todo: reorg this into other files

-- basic keybinds
map("jk", "<esc>", "i") -- exit insert mode
map(";", ":") -- don't type shift
map(";", ":", "v")
map("\\", ",") -- we remapped , and ;
map("<c-\\>", ";")
map("Q", "gqip")

-- line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- filetype support
vim.o.filetype = "on"
vim.o.syntax = "on" -- syntax highlighting
vim.o.do_filetype_lua = true

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

-- mouse
vim.o.mouse = "a"

-- undo
vim.cmd("set undofile") -- persistent undo

-- surround
require("nvim-surround").setup({})

-- substitute
require("substitute").setup()

-- -- register replace TODO: do we like this
-- map("<leader>s", require("substitute").operator)
-- map("<leader>ss", require("substitute").line)
-- map("<leader>S", require("substitute").eol)
-- map("<leader>s", require("substitute").visual, "x")

-- exchange
map("cx", require("substitute.exchange").operator)
map("cxx", require("substitute.exchange").line)
map("X", require("substitute.exchange").visual, "x")
map("cxc", require("substitute.exchange").cancel)

-- pounce
map("s", "<cmd>Pounce<cr>")

-- autopairs
-- todo: fix
-- local Rule = require("nvim-autopairs.rule")
-- local npairs = require("nvim-autopairs")

-- npairs.add_rule(Rule("$", "$", "markdown"))

-- spell
-- todo: make spellchecker work well
map("z=", require("telescope.builtin").spell_suggest)

-- neogen
map("<localleader>d", require("neogen").generate)
require("neogen").setup({
	enabled = true,
	snippet_engine = "luasnip",
	languages = {
		python = {
			template = {
				annotation_convention = "numpydoc",
			},
		},
	},
})

-- true zen
require("true-zen").setup({
	modes = {
		ataraxis = {
			minimum_writing_area = {
				-- minimum size of main window
				-- not sure why this needs to be 82 instead of 80
				width = 82,
			},
			quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
			padding = { -- padding windows
				-- lots of padding, min width is the same as the markdown text wrap level
				left = 1000,
				right = 1000,
			},
		},
	},
	-- your config goes here
	-- or just leave it empty :)
})
map(leaders.ui .. "z", "<cmd>TZAtaraxis<cr>")
map(leaders.ui .. "m", "<cmd>TZMinimalist<cr>")

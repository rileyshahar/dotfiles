require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	ignore_install = {}, -- List of parsers to ignore installing
	highlight = {
		enable = true,
	},
})

-- TODO: do we like treesitter folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

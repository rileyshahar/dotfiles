require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	ignore_install = {}, -- List of parsers to ignore installing
	highlight = {
		enable = true,
	},
})

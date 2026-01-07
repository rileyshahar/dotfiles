return {
	-- quickfix
	{
		"kevinhwang91/nvim-bqf", -- better quickfix keybinds
		opts = {
			func_map = {
				drop = "<CR>",
				open = "o",
			},
		},
	},
	{
		"https://gitlab.com/yorickpeterse/nvim-pqf.git",
		config = true,
	},
}

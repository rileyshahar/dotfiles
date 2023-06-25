return {
	-- buffers
	{
		"jose-elias-alvarez/buftabline.nvim",
		lazy = false, -- never lazy load
		config = true,
		keys = {
			{ "H", "<cmd>BufPrev<cr>" },
			{ "L", "<cmd>BufNext<cr>" },
		},
	},

	-- file manager
	{
		"stevearc/oil.nvim",
		lazy = false, -- cant lazy load bc we need to be able to `nvim [dir]`
		config = true,
		keys = {
			{
				"|",
				function()
					require("oil").open()
				end,
			},
		},
	},
}

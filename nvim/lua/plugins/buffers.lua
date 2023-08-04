return {
	-- file manager
	{
		"stevearc/oil.nvim",
		lazy = false, -- cant lazy load bc we need to be able to `nvim [dir]`
		config = true,
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
			},
		},
	},
}

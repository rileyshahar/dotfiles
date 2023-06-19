return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neorg/neorg-telescope",
		},
		config = {
			load = {
				["core.defaults"] = {},
				["core.export"] = {},
				["core.export.markdown"] = {},
				["core.dirman"] = {
					config = {
						workspaces = {
							math = "~/notes/math",
						},
						index = "index.norg", -- The name of the main (root) .norg file
						use_popup = false,
					},
				},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.concealer"] = {},
				["core.keybinds"] = {
					config = {
						hook = function(keybinds)
							keybinds.map("norg", "n", "<localleader>t", "<cmd>Neorg tangle current-file<cr>")
							keybinds.map(
								"norg",
								"n",
								"<C-]>",
								"<cmd>Neorg keybind all core.looking-glass.magnify-code-block<cr>"
							)
						end,
					},
				},
				["core.integrations.telescope"] = {},
			},
		},
	},
}

return {
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = {
			load = {
				["core.defaults"] = {},
				["core.export"] = {},
				["core.export.markdown"] = {},
				["core.norg.dirman"] = {
					config = {
						workspaces = {
							math = "~/notes/math",
						},
						index = "index.norg", -- The name of the main (root) .norg file
						use_popup = false,
					},
				},
				["core.norg.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.norg.concealer"] = {
					config = {
						icons = {
							ordered = {
								level_1 = {
									-- don't use fancy unicode, just do this
									icon = tostring,
								},
							},
						},
					},
				},
			},
		},
	},
}

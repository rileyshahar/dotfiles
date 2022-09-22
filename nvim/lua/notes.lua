-- neorg config

require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {},
		["core.norg.dirman"] = {
			config = {
				workspaces = {
					reuna = "~/notes/dnd/reuna/notes",
				},
				autochdir = true,
				index = "index.norg", -- The name of the main (root) .norg file
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
})

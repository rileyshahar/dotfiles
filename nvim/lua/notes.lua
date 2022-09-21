-- neorg config

require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {},
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

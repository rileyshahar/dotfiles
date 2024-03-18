return {
	{
		"whonore/Coqtail",
		ft = "coq",
		config = function()
			vim.g.coqtail_map_prefix = "<localleader>"
		end,
		keys = {
			{
				"]c",
				"<cmd>CoqNext<cr><cmd>CoqJumpToEnd<cr>",
				desc = "coq: step forward",
				buffer = true,
			},
			{
				"[c",
				"<cmd>CoqUndo<cr><cmd>CoqJumpToEnd<cr>",
				desc = "coq: step back",
				buffer = true,
			},
			{
				"<localleader>/",
				":Coq Search ",
				desc = "coq search",
				buffer = true,
			}, -- have to use : to not need to close the cmd
		},
	},
}

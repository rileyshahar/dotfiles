return {
	"whonore/Coqtail",
	ft = "coq",
	config = function()
		vim.g.coqtail_map_prefix = "<localleader>"
	end,
	keys = {
		{
			"]c",
			"<cmd>CoqNext<cr><cmd>CoqJumpToEnd<cr>",
		},
		{
			"[c",
			"<cmd>CoqUndo<cr><cmd>CoqJumpToEnd<cr>",
		},
	},
}

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
			},
			{
				"[c",
				"<cmd>CoqUndo<cr><cmd>CoqJumpToEnd<cr>",
			},
			{ "<localleader>/", ":Coq Search " }, -- have to use : to not need to close the cmd
		},
	},
	-- {
	-- 	"tomtomjhj/coq-lsp.nvim",
	-- 	config = function()
	-- 		vim.g.loaded_coqtail = 1
	-- 		vim.g["coqtail#supported"] = 0
	-- 	end,
	-- },
}

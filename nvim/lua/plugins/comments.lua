return {
	{
		-- comment
		"numToStr/Comment.nvim",
		config = {
			ignore = "^$",
		},
	},
	{
		-- manage todo comments
		"Folke/todo-comments.nvim",
		config = {
			search = {
				pattern = [[\b(KEYWORDS)\b]],
			},
		},
		lazy = false,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
			},
			{ leaders.finder .. "t", "<cmd>TodoTelescope<cr>" },
		},
	},
}

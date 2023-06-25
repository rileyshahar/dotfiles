return {
	-- comment
	{
		"numToStr/Comment.nvim",
		opts = {
			ignore = "^$",
		},
	},

	-- manage todo comments
	{
		"Folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		opt = {
			search = {
				pattern = [[\b(KEYWORDS)\b]],
			},
		},
		keys = function()
			local tc = require("todo-comments")
			return {
				{ "]t",                  tc.jump_next,             desc = "todo" },
				{ "[t",                  tc.jump_prev,             desc = "todo" },
				{ leaders.finder .. "t", "<cmd>TodoTelescope<cr>", desc = "todos" },
			}
		end,
	},
}

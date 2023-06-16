return {
	-- pairs
	{
		-- autoclose paired characters
		"windwp/nvim-autopairs",
		config = true,
	},
	{
		-- quote manipulation
		"kylechui/nvim-surround",
		config = true,
	},

	-- editing
	{
		-- exchange plugin
		"gbprod/substitute.nvim",
		config = true,
		keys = {
			{
				"<leader>s",
				function()
					require("substitute").operator()
				end,
			},
			{
				"<leader>ss",
				function()
					require("substitute").line()
				end,
			},
			{
				"<leader>S",
				function()
					require("substitute").eol()
				end,
			},
			{
				"<leader>S",
				function()
					require("substitute").visua()
				end,
				mode = "x",
			},
			{
				"cx",
				function()
					require("substitute.exchange").operator()
				end,
			},
			{
				"cxx",
				function()
					require("substitute.exchange").line()
				end,
			},
			{
				"X",
				function()
					require("substitute.exchange").visual()
				end,
				mode = "x",
			},
			{
				"cxc",
				function()
					require("substitute.exchange").cancel()
				end,
			},
		},
	},
	"machakann/vim-highlightedyank", -- highlight yanked text

	-- navigation/movement
	"chaoren/vim-wordmotion", -- snake case word

	-- distraction-free writing
	{
		"Pocco81/true-zen.nvim",
		config = {
			modes = {
				ataraxis = {
					minimum_writing_area = {
						-- minimum size of main window
						-- not sure why this needs to be 82 instead of 80
						width = 82,
					},
					quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
					padding = { -- padding windows
						-- lots of padding, min width is the same as the markdown text wrap level
						left = 1000,
						right = 1000,
					},
				},
			},
		},
		keys = {
			{ leaders.ui .. "z", "<cmd>TZAtaraxis<cr>" },
			{ leaders.ui .. "m", "<cmd>TZMinimalist<cr>" },
		},
	},
}

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
			},
			{
				"[c",
				"<cmd>CoqUndo<cr><cmd>CoqJumpToEnd<cr>",
				desc = "coq: step back",
			},
			{ "<localleader>/", ":Coq Search ", desc = "coq search" }, -- have to use : to not need to close the cmd
		},
	},
	{
		"lervag/vimtex",
		ft = "tex"
	},
	{
		"dag/vim-fish",
		ft = "fish"
	},
	{
		"isovector/cornelis",
		ft = "agda"
	},
	"kmonad/kmonad-vim",
	{
		"akinsho/toggleterm.nvim",
		config = true,
		keys = {
			{
				leaders.terminal .. leaders.terminal,
				"<cmd>ToggleTerm<cr>",
				desc = "toggle terminal",
				mode = { "n", "t", "i", "v" },
			},
			{
				leaders.terminal .. "s",
				"<cmd>TermSelect<cr>",
				desc = "select terminal",
				mode = { "n", "t" },
			},
			{
				leaders.terminal .. "n",
				"<cmd>ToggleTermSetName<cr>",
				desc = "name terminal",
				mode = { "n", "t" },
			},
			{
				leaders.terminal .. "<cr>",
				"<cmd>ToggleTermSendCurrentLine<cr>",
				desc = "send current line to terminal",
				mode = { "n", "i" },
			},
			{
				leaders.terminal .. "<cr>",
				"<cmd>ToggleTermSendVisualSelection<cr>",
				desc = "send visual seleciton to terminal",
				mode = "x",
			},
			{
				"<esc>",
				"<c-\\><c-n>",
				desc = "exit insert mode",
				mode = "t",
			},
			{
				"jk",
				"<c-\\><c-n>",
				desc = "exit insert mode",
				mode = "t",
			},
			{
				"<c-h>",
				"<cmd>wincmd h<cR>",
				desc = "move to left window",
				mode = "t",
			},
			{
				"<c-j>",
				"<cmd>wincmd j<cR>",
				desc = "move to right window",
				mode = "t",
			},
			{
				"<c-k>",
				"<cmd>wincmd k<cR>",
				desc = "move to above window",
				mode = "t",
			},
			{
				"<c-l>",
				"<cmd>wincmd l<cR>",
				desc = "move to below window",
				mode = "t",
			},
			{
				"<c-w>",
				"<c-\\><c-n><c-w>",
				desc = "window",
				mode = "t",
			},
		}
	}
}

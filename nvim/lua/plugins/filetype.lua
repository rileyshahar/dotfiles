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
		ft = "tex",
	},

	{
		"dag/vim-fish",
		ft = "fish",
	},

	{
		"isovector/cornelis",
		ft = "agda",
	},

	"kmonad/kmonad-vim",

	"petRUShka/vim-sage",

	{
		"Julian/lean.nvim",
		ft = "lean",
		dependencies = {
			"neovim/nvim-lspconfig",
			"nvim-lua/plenary.nvim",
		},
		opts = {
			mappings = true,
			-- TODO: lsp on_attach?
		},
	},

	{
		"kentookura/forester.nvim",
		ft = "forester",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
			{ "nvim-lua/plenary.nvim" },
			{ "hrsh7th/nvim-cmp" },
		},
		config = true,
	},
}

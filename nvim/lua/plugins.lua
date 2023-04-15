-- keybinds
local function plugin_meta_map(lhs, rhs, mode, opts)
	map(leaders.plugin_meta .. lhs, rhs, mode, opts)
end

plugin_meta_map("i", "<cmd>Lazy install<cr>")
plugin_meta_map("u", "<cmd>Lazy update<cr>")
plugin_meta_map("s", "<cmd>Lazy sync<cr>")
plugin_meta_map("c", "<cmd>Lazy clean<cr>")

return {
	-- prereqs
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"tpope/vim-repeat", -- repeat plugin commands
	"rcarriga/nvim-notify", -- notification ui
	"elihunter173/dirbuf.nvim", -- directory buffer
	"lewis6991/gitsigns.nvim", -- git

	-- quickfix
	"kevinhwang91/nvim-bqf", -- better quickfix keybinds
	{
		"https://gitlab.com/yorickpeterse/nvim-pqf.git",
		config = {},
	},

	-- completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" } },
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-path",
			"ray-x/cmp-treesitter",
			"lukas-reineke/cmp-under-comparator",
		},
	},

	-- buffers
	{
		"jose-elias-alvarez/buftabline.nvim",
		lazy = false, -- never lazy load
		config = {},
		keys = {
			{ "H", "<cmd>BufPrev<cr>" },
			{ "L", "<cmd>BufNext<cr>" },
		},
	},
	{
		"ojroques/nvim-bufdel",
		keys = {
			{ "<leader>x", "<cmd>BufDel<cr>" },
		},
	},

	-- lsp
	"neovim/nvim-lspconfig",
	"ray-x/lsp_signature.nvim", -- signature while typing
	"jose-elias-alvarez/null-ls.nvim",
	{
		"j-hui/fidget.nvim",
		config = {},
	}, -- lsp status indicator

	-- appearance
	"ap/vim-css-color",

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		"lewis6991/spellsitter.nvim",
		config = {},
	},
	{
		"nvim-treesitter/playground",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	-- git

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "stevearc/dressing.nvim" },

	-- tex
	"lervag/vimtex",

	-- rust
	{
		"mhinz/vim-crates",
		dependencies = {
			"mattn/webapi-vim",
		},
	},
	"rust-lang/rust.vim",
	"cespare/vim-toml",
	"plasticboy/vim-markdown",
	"dag/vim-fish",
	"pest-parser/pest.vim",
	"NoahTheDuke/vim-just",
}

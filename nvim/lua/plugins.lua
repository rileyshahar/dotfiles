require("lazy").setup({
	-- prereqs
	"nvim-lua/popup.nvim",
	"nvim-lua/plenary.nvim",
	"tpope/vim-repeat", -- repeat plugin commands
	"rcarriga/nvim-notify", -- notification ui

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

	-- pairs
	{
		-- autoclose paired characters
		"windwp/nvim-autopairs",
		config = {},
	},
	{
		-- quote manipulation
		"kylechui/nvim-surround",
		config = {},
	},

	-- editing
	{
		-- exchange plugin
		"gbprod/substitute.nvim",
		config = {},
		keys = {
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
				"x",
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
	{
		-- motion
		"rlane/pounce.nvim",
		keys = {
			{ "<leader><leader>", "<cmd>Pounce<cr>" },
		},
	},
	"chaoren/vim-wordmotion", -- snake case word

	-- fs
	"elihunter173/dirbuf.nvim", -- directory buffer

	-- quickfix
	"kevinhwang91/nvim-bqf", -- better quickfix keybinds
	{
		"https://gitlab.com/yorickpeterse/nvim-pqf.git",
		config = {},
	},

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
			{ "X", "<cmd>BufDel<cr>" },
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

	-- neorg
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},

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
		-- TODO: setup
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = {
			enabled = true,
			snippet_engine = "luasnip",
			languages = {
				python = {
					template = {
						annotation_convention = "numpydoc",
					},
				},
			},
		},
		keys = {
			{
				"<localleader>d",
				function()
					require("neogen").generate()
				end,
			},
		},
	},
	{
		"nvim-treesitter/playground",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	-- git
	"lewis6991/gitsigns.nvim",

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
	"mhinz/vim-crates",
	"mattn/webapi-vim", -- dependency
	"rust-lang/rust.vim",

	-- toml
	"cespare/vim-toml",

	-- markdown
	-- "vim-pandoc/vim-pandoc",
	-- "vim-pandoc/vim-pandoc-syntax",
	"plasticboy/vim-markdown",
	-- use({
	-- 	"edluffy/hologram.nvim",
	-- 	config = function()
	-- 		require("hologram").setup({
	-- 			auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
	-- 		})
	-- 	end,
	-- })

	-- fish
	"dag/vim-fish",

	-- pest/peg
	"pest-parser/pest.vim",

	-- just
	"NoahTheDuke/vim-just",

	-- agda
	{
		"isovector/cornelis",
		dependencies = { "kana/vim-textobj-user", "neovimhaskell/nvim-hs.vim" },
		build = "stack build",
	},

	-- lean
	{ "Julian/lean.nvim", dependencies = "andrewradev/switch.vim" },

	-- coq
	{
		"whonore/Coqtail",
		config = function()
			vim.g.loaded_coqtail = 1
			vim.g["coqtail#supported"] = 0
		end,
	},
	"tomtomjhj/coq-lsp.nvim",

	-- mtg
	{
		"yoshi1123/vim-mtg",
		config = function()
			vim.g.mtg_preview_show_price = true
		end,
	},
})

-- keybinds
local function plugin_meta_map(lhs, rhs, mode, opts)
	map(leaders.plugin_meta .. lhs, rhs, mode, opts)
end

plugin_meta_map("i", "<cmd>Lazy install<cr>")
plugin_meta_map("u", "<cmd>Lazy update<cr>")
plugin_meta_map("s", "<cmd>Lazy sync<cr>")
plugin_meta_map("c", "<cmd>Lazy clean<cr>")

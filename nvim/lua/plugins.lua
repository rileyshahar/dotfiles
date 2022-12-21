--# selene: allow(undefined_variable)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- prereqs
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use("tpope/vim-repeat") -- repeat plugin commands
	use("rcarriga/nvim-notify") -- notification ui

	use({
		-- comment
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				ignore = "^$",
			})
		end,
	})
	use({
		-- manage todo comments
		"Folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup()
			map("]t", require("todo-comments").jump_next)
			map("[t", require("todo-comments").jump_prev)
			map(leaders.finder .. "t", "<cmd>TodoTelescope<cr>")
		end,
	})

	-- pairs
	use({
		-- autoclose paired characters
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use({
		-- quote manipulation
		"kylechui/nvim-surround",
		config = function()
			require("nvim-surround").setup()
		end,
	})

	-- editing
	use({
		-- exchange plugin
		"gbprod/substitute.nvim",
		config = function()
			require("substitute").setup()
			map("cx", require("substitute.exchange").operator)
			map("cxx", require("substitute.exchange").line)
			map("X", require("substitute.exchange").visual, "x")
			map("cxc", require("substitute.exchange").cancel)
		end,
	})
	use("machakann/vim-highlightedyank") -- highlight yanked text

	-- navigation/movement
	use({
		-- motion
		"rlane/pounce.nvim",
		config = function()
			map("<leader><leader>", "<cmd>Pounce<cr>")
		end,
	})
	use("chaoren/vim-wordmotion") -- snake case word

	-- fs
	use("elihunter173/dirbuf.nvim") -- directory buffer

	-- quickfix
	use("kevinhwang91/nvim-bqf") -- better quickfix keybinds
	use("https://gitlab.com/yorickpeterse/nvim-pqf.git")

	-- distraction-free writing
	use({
		"Pocco81/true-zen.nvim",
		config = function()
			require("true-zen").setup({
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
			})
			map(leaders.ui .. "z", "<cmd>TZAtaraxis<cr>")
			map(leaders.ui .. "m", "<cmd>TZMinimalist<cr>")
		end,
	})

	-- completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "saadparwaiz1/cmp_luasnip", requires = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" } },
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-path",
			"ray-x/cmp-treesitter",
			"lukas-reineke/cmp-under-comparator",
		},
	})

	-- buffers
	use("jose-elias-alvarez/buftabline.nvim")
	use("ojroques/nvim-bufdel") -- delete

	-- lsp
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim") -- signature while typing
	use("jose-elias-alvarez/null-ls.nvim")
	use("j-hui/fidget.nvim") -- lsp status indicator

	-- neorg
	use({
		"nvim-neorg/neorg",
		tag = "*",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	})

	-- appearance
	use("ap/vim-css-color")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			vim.cmd("TSUpdate")
		end,
		-- commit = "088dfbc5",
	})
	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	})
	use({
		-- TODO: setup
		"danymat/neogen",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			map("<localleader>d", require("neogen").generate)
			require("neogen").setup({
				enabled = true,
				snippet_engine = "luasnip",
				languages = {
					python = {
						template = {
							annotation_convention = "numpydoc",
						},
					},
				},
			})
		end,
	})
	use({
		"nvim-treesitter/playground",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- git
	use("lewis6991/gitsigns.nvim")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "stevearc/dressing.nvim" })

	-- tex
	use("lervag/vimtex")

	-- rust
	use("mhinz/vim-crates")
	use("mattn/webapi-vim") -- dependency
	use("rust-lang/rust.vim")

	-- toml
	use("cespare/vim-toml")

	-- markdown
	-- use("vim-pandoc/vim-pandoc")
	-- use("vim-pandoc/vim-pandoc-syntax")
	use("plasticboy/vim-markdown")
	-- use({
	-- 	"edluffy/hologram.nvim",
	-- 	config = function()
	-- 		require("hologram").setup({
	-- 			auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
	-- 		})
	-- 	end,
	-- })

	-- fish
	use("dag/vim-fish")

	-- pest/peg
	use("pest-parser/pest.vim")

	-- just
	use("NoahTheDuke/vim-just")

	-- aga
	use({
		"isovector/cornelis",
		requires = { "kana/vim-textobj-user", "neovimhaskell/nvim-hs.vim" },
		run = "stack build",
	})

	-- mtg
	use({
		"yoshi1123/vim-mtg",
		config = function()
			vim.g.mtg_preview_show_price = true
		end,
	})

	-- bootstrap
	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- keybinds
local function plugin_meta_map(lhs, rhs, mode, opts)
	map(leaders.plugin_meta .. lhs, rhs, mode, opts)
end

plugin_meta_map("i", "<cmd>PackerInstall<cr>")
plugin_meta_map("u", "<cmd>PackerUpdate<cr>")
plugin_meta_map("s", "<cmd>PackerSync<cr>")
plugin_meta_map("c", "<cmd>PackerClean<cr>")

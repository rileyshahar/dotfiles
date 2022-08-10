--# selene: allow(undefined_variable)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- prereqs
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")

	-- misc
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				ignore = "^$",
			})
		end,
	})
	use("tpope/vim-repeat") -- repeat plugin commands
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	}) -- autoclose paired characters
	use("kylechui/nvim-surround") -- quote manipulation
	use("tommcdo/vim-exchange") -- exchange text objects
	use("machakann/vim-highlightedyank") -- highlight yanked text
	use("christoomey/vim-sort-motion") -- sort easily
	use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" }) -- kitty/vim window keybinds
	use("rcarriga/nvim-notify") -- notification ui

	-- quickfix
	use("kevinhwang91/nvim-bqf") -- better quickfix keybinds
	use("https://gitlab.com/yorickpeterse/nvim-pqf.git")

	-- distraction-free writing
	use("Pocco81/true-zen.nvim")

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

	-- lsp
	use("neovim/nvim-lspconfig")
	use("ray-x/lsp_signature.nvim") -- signature while typing
	use("jose-elias-alvarez/null-ls.nvim")
	use("j-hui/fidget.nvim") -- lsp status indicator

	-- appearance
	use("ghifarit53/tokyonight-vim")
	use("ap/vim-css-color")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			vim.cmd("TSUpdate")
		end,
	})
	use({
		"lewis6991/spellsitter.nvim",
		config = function()
			require("spellsitter").setup()
		end,
	})
	use({
		-- todo: setup
		"danymat/neogen",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	-- use({
	-- 	-- dim non-current blocks
	-- 	-- TODO: toesn't work
	-- 	"folke/twilight.nvim",
	-- 	config = function()
	-- 		require("twilight").setup({})
	-- 	end,
	-- })

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

	-- fish
	use("dag/vim-fish")

	-- pest/peg
	use("pest-parser/pest.vim")

	-- just
	use("NoahTheDuke/vim-just")

	-- copilot
	use({
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup()
			end, 100)
		end,
	})
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua", "nvim-cmp" },
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

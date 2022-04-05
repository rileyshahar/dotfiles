-- setup packer
-- cmd "packadd packer.nvim" -- Load package
-- TODO: run simple setup commands from here
--# selene: allow(undefined_variable)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- prereqs
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")

	-- misc
	use({
		"numToStr/Comment.nvim",
		config = require("Comment").setup({
			ignore = "^$",
		}),
	})
	use("tpope/vim-repeat") -- repeat plugin commands
	use({
		"windwp/nvim-autopairs",
		config = require("nvim-autopairs").setup(),
	}) -- autoclose paired characters
	use("tpope/vim-surround") -- quote manipulation
	use("tommcdo/vim-exchange") -- exchange text objects
	use("machakann/vim-highlightedyank") -- highlight yanked text
	use("christoomey/vim-sort-motion") -- sort easily
	use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" }) -- kitty/vim window keybinds

	-- quickfix
	use("kevinhwang91/nvim-bqf") -- better quickfix keybinds
	use("https://gitlab.com/yorickpeterse/nvim-pqf.git")

	-- writing
	use("junegunn/goyo.vim") -- distraction-free writing

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
		},
	})

	-- buffers
	use("jose-elias-alvarez/buftabline.nvim")

	-- lsp
	use("neovim/nvim-lspconfig")
	use("nvim-lua/lsp_extensions.nvim") -- inlay hints
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
	-- 	TODO: toesn't work
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

	-- python
	use({ "heavenshell/vim-pydocstring", run = "make install" })

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
		event = "InsertEnter",
		config = function()
			vim.schedule(function()
				require("copilot")
			end)
		end,
	})
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua", "nvim-cmp" },
	})
end)

-- keybinds
local function plugin_meta_map(lhs, rhs, mode, opts)
	map(leaders.plugin_meta .. lhs, rhs, mode, opts)
end

plugin_meta_map("i", "<cmd>PackerInstall<cr>")
plugin_meta_map("u", "<cmd>PackerUpdate<cr>")
plugin_meta_map("s", "<cmd>PackerSync<cr>")
plugin_meta_map("c", "<cmd>PackerClean<cr>")

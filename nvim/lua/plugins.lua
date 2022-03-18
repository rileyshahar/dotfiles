-- setup packer
-- cmd "packadd packer.nvim" -- Load package
-- TODO: run simple setup commands from here
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- prereqs
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")

	-- misc
	use("b3nj5m1n/kommentary") -- comment plugin
	use("knubie/vim-kitty-navigator") -- tmux split navigation
	use("tpope/vim-repeat") -- repeat plugin commands
	use("jiangmiao/auto-pairs") -- autoclose brackets
	use("tpope/vim-surround") -- quote manipulation
	use("tommcdo/vim-exchange") -- exchange text objects
	use("simnalamburt/vim-mundo") -- undo tree viewer
	use("machakann/vim-highlightedyank") -- highlight yanked text
	use("christoomey/vim-sort-motion") -- sort easily

	-- quickfix
	use("kevinhwang91/nvim-bqf") -- better quickfix keybinds
	use("https://gitlab.com/yorickpeterse/nvim-pqf.git")

	-- writing
	use("junegunn/goyo.vim") -- distraction-free writing

	-- completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-vsnip", requires = { "hrsh7th/vim-vsnip", "rafamadriz/friendly-snippets" } },
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"f3fora/cmp-spell",
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
			cmd("TSUpdate")
		end,
	})
	use("lewis6991/spellsitter.nvim") -- spell check treesitter comments

	-- git
	use("lewis6991/gitsigns.nvim")

	-- telescope
	use("nvim-telescope/telescope.nvim")

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
	--[[ use "vim-pandoc/vim-pandoc"
        use "vim-pandoc/vim-pandoc-syntax" ]]
	use("plasticboy/vim-markdown")

	-- fish
	use("dag/vim-fish")

	-- pest/peg
	use("pest-parser/pest.vim")

	-- just
	use("NoahTheDuke/vim-just")

	-- copilot
	use("github/copilot.vim")
end)

-- copilot

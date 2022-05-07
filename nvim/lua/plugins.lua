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
	use("tpope/vim-surround") -- quote manipulation
	use("tommcdo/vim-exchange") -- exchange text objects
	use("machakann/vim-highlightedyank") -- highlight yanked text
	use("christoomey/vim-sort-motion") -- sort easily
	use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" }) -- kitty/vim window keybinds
	use("rcarriga/nvim-notify") -- notification ui

	-- quickfix
	use("kevinhwang91/nvim-bqf") -- better quickfix keybinds
	use("https://gitlab.com/yorickpeterse/nvim-pqf.git")

	-- writing
	use({
		"junegunn/goyo.vim",
		-- distraction-free writing
		config = function()
			map("<leader>z", "<cmd>Goyo<cr>")
		end,
	})

	-- buffers
	use("jose-elias-alvarez/buftabline.nvim")

	-- appearance
	use("ghifarit53/tokyonight-vim")
	use("ap/vim-css-color")

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

return {
	-- buffers
	{
		"jose-elias-alvarez/buftabline.nvim",
		lazy = false, -- never lazy load
		opts = {
			go_to_maps = false,
		},
		keys = {
			{ "<s-h>", "<cmd>BufPrev<cr>" },
			{ "<s-l>", "<cmd>BufNext<cr>" },
		},
	},

	-- file manager
	{
		"stevearc/oil.nvim",
		lazy = false, -- cant lazy load bc we need to be able to `nvim [dir]`
		config = true,
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
			},
		},
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		cmd = "Telescope",
		keys = function()
			local builtins = require("telescope.builtin")
			return {
				{ leaders.finder .. "f", builtins.find_files, desc = "files" },
				{ leaders.finder .. "g", builtins.live_grep,  desc = "in dir" },
				{
					leaders.finder .. "w",
					builtins.grep_string,
					desc =
					"word under cursor"
				},
				{ leaders.finder .. "b", builtins.buffers,   desc = "buffers" },
				{ leaders.finder .. "h", builtins.help_tags, desc = "help tags" },
				{ leaders.finder .. "R", builtins.registers, desc = "registers" },
				{ leaders.finder .. "k", builtins.keymaps,   desc = "keymaps" },
				{
					leaders.edit .. "n",
					function() builtins.find_files({ cwd = "$DOTFILES_DIR/nvim" }) end,
					desc =
					"neovim config"
				},
				{ leaders.edit .. "c", function() builtins.find_files({ cwd = "$DOTFILES_DIR" }) end, desc = "configs" },
			}
		end,
		opts = function()
			local actions = require("telescope.actions")
			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					mappings = {
						i = {
							["<c-down>"] = actions.cycle_history_next,
							["<c-up>"] = actions.cycle_history_prev,
							["<c-f>"] = actions.preview_scrolling_down,
							["<c-b>"] = actions.preview_scrolling_up,
						},
					},
					pickers = {
						lsp_code_actions = {
							theme = "cursor",
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
		end,
	},
}

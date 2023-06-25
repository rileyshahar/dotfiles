return {
	-- key viewer
	-- TODO: aesthetics
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			prefixes = {
				["g"] = { name = "goto" },
				["]"] = { name = "next" },
				["["] = { name = "prev" },
				["<leader>"] = {
					name = "leader",
					["m"] = { name = "make" },
					["f"] = { name = "find" },
					["g"] = { name = "git" },
					[","] = { name = "local" },
					["e"] = { name = "edit" },
					["p"] = { name = "plugin" },
					["r"] = { name = "refactor" },
				},
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.register(opts.prefixes)
		end,
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
				{ leaders.finder .. "f", builtins.find_files,  desc = "files" },
				{ leaders.finder .. "g", builtins.live_grep,   desc = "in dir" },
				{ leaders.finder .. "w", builtins.grep_string, desc = "word under cursor" },
				{ leaders.finder .. "b", builtins.buffers,     desc = "buffers" },
				{ leaders.finder .. "h", builtins.help_tags,   desc = "help tags" },
				{ leaders.finder .. "R", builtins.registers,   desc = "registers" },
				{ leaders.finder .. "k", builtins.keymaps,     desc = "keymaps" },
				{ leaders.edit .. "n",   "$DOTFILES_DIR/nvim", desc = "neovim config" },
				{ leaders.edit .. "c",   "$DOTFILES_DIR",      desc = "configs" },
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
	{
		"stevearc/dressing.nvim",
		opts = function()
			return {
				input = {
					enabled = true,
					win_options = {
						winhighlight = "FloatBorder:NormalFloat"
					}
				},
				select = {
					telescope = require("telescope.themes").get_cursor(),
				}
			}
		end
	},
}

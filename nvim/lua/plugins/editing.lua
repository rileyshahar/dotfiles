return {
	-- autoclose paired characters
	{
		"windwp/nvim-autopairs",
		config = true,
	},

	-- operators
	{
		"echasnovski/mini.operators",
		config = true,
		keys = {
			{ "g=", desc = "evaluate" },
			{ "g+", "g=$", desc = "evaluate to eol", remap = true },

			{ "gx", desc = "exchange" },
			{ "gX", "gx$", desc = "exchange to eol", remap = true },

			{ "gm", desc = "multiply" },
			{ "gM", "gm$", desc = "multiply to eol", remap = true },

			{ "gr", desc = "replace" },
			{ "gR", "gr$", desc = "replace to eol", remap = true },

			{ "gs", desc = "sort" },
			{ "gS", "gs$", desc = "sort to eol", remap = true },
		},
	},

	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			use_default_keymaps = false,
		},
		keys = function()
			local tsj = require("treesj")
			return {
				{ leaders.surround .. "t", tsj.toggle, desc = "toggle splitjoin" },
				{ leaders.surround .. "s", tsj.split, desc = "split brackets" },
				{ leaders.surround .. "j", tsj.join, desc = "join brackets" },
			}
		end,
	},

	"machakann/vim-highlightedyank", -- highlight yanked text

	"chaoren/vim-wordmotion", -- snake case w etc

	-- surround
	{
		"echasnovski/mini.surround",
		init = function()
			vim.keymap.del({ "n", "v" }, "s")
		end,
		opts = {
			search_method = "cover",
			n_lines = 500,
			mappings = {
				replace = leaders.surround .. "c",
			},
		},
		keys = {
			{ leaders.surround, desc = "surround", mode = { "n", "v" } },
			{ leaders.surround .. "a", desc = "add", mode = { "n", "v" } },
			{ leaders.surround .. "d", desc = "delete" },
			{ leaders.surround .. "f", desc = "find" },
			{ leaders.surround .. "F", desc = "find_left" },
			{ leaders.surround .. "h", desc = "highlight" },
			{ leaders.surround .. "c", desc = "change" },
			{ leaders.surround .. "n", desc = "update_n_lines" },
			-- since we use s for surround
			{ "S", "s", desc = "substitute", mode = { "n", "v" } },
		},
	},

	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				search_method = "cover",
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)

			-- register all text objects with which-key
			local keys = {
				[" "] = "whitespace",
				['"'] = "double quote",
				["'"] = "single quote",
				["`"] = "backtick",
				["("] = "parentheses",
				[")"] = "parentheses (ws)",
				["<lt>"] = "angle bracket",
				[">"] = "angle bracket (ws)",
				["["] = "square bracket",
				["]"] = "square bracket (ws)",
				["{"] = "curly brace",
				["}"] = "curly brace (ws)",
				["?"] = "prompt",
				_ = "underscore",
				a = "argument",
				B = "block",
				b = "brackets",
				c = "class",
				f = "function",
				o = "block, conditional, or loop",
				q = "quote",
				t = "tag",
				l = "last textobject",
				n = "next textobject",
				p = "paragraph",
				s = "sentence",
				w = "word",
				W = "WORD",
			}
			require("which-key").register({
				mode = { "o", "x" },
				i = keys,
				a = keys,
			})
		end,
	},
}

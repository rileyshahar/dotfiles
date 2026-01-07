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
			{ "gE", "ge$", desc = "exchange to eol", remap = true },

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

	-- surround
	{
		"echasnovski/mini.surround",
		init = function()
			-- vim.keymap.del({ "n", "v" }, "s")
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
				n_lines = 500,
				-- from https://github.com/LazyVim/LazyVim/blob/f94a0591b3e5838794b1c3897ec21491aeb080fe/lua/lazyvim/plugins/coding.lua
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					g = function(ai_type)
						local start_line, end_line = 1, vim.fn.line("$")
						if ai_type == "i" then
							-- Skip first and last blank lines for `i` textobject
							local first_nonblank, last_nonblank =
								vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
							-- Do nothing for buffer with all blanks
							if first_nonblank == 0 or last_nonblank == 0 then
								return { from = { line = start_line, col = 1 } }
							end
							start_line, end_line = first_nonblank, last_nonblank
						end

						local to_col = math.max(vim.fn.getline(end_line):len(), 1)
						return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
					end,
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)

			-- register all text objects with which-key
			-- from https://github.com/LazyVim/LazyVim/blob/f94a0591b3e5838794b1c3897ec21491aeb080fe/lua/lazyvim/util/mini.lua
			local objects = {
				{ " ", desc = "whitespace" },
				{ '"', desc = '" string' },
				{ "'", desc = "' string" },
				{ "(", desc = "() block" },
				{ ")", desc = "() block with ws" },
				{ "<", desc = "<> block" },
				{ ">", desc = "<> block with ws" },
				{ "?", desc = "user prompt" },
				{ "U", desc = "use/call without dot" },
				{ "[", desc = "[] block" },
				{ "]", desc = "[] block with ws" },
				{ "_", desc = "underscore" },
				{ "`", desc = "` string" },
				{ "a", desc = "argument" },
				{ "b", desc = ")]} block" },
				{ "c", desc = "class" },
				{ "d", desc = "digit(s)" },
				{ "f", desc = "function" },
				{ "g", desc = "entire file" },
				{ "o", desc = "block, conditional, loop" },
				{ "q", desc = "quote `\"'" },
				{ "t", desc = "tag" },
				{ "u", desc = "use/call" },
				{ "{", desc = "{} block" },
				{ "}", desc = "{} with ws" },
			}

			local ret = { mode = { "o", "x" } }
			local mappings = vim.tbl_extend("force", {}, {
				around = "a",
				inside = "i",
				around_next = "an",
				inside_next = "in",
				around_last = "al",
				inside_last = "il",
			}, opts.mappings or {})
			mappings.goto_left = nil
			mappings.goto_right = nil

			for name, prefix in pairs(mappings) do
				name = name:gsub("^around_", ""):gsub("^inside_", "")
				ret[#ret + 1] = { prefix, group = name }
				for _, obj in ipairs(objects) do
					local desc = obj.desc
					if prefix:sub(1, 1) == "i" then
						desc = desc:gsub(" with ws", "")
					end
					ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
				end
			end
			require("which-key").add(ret, { notify = false })
		end,
	},
}

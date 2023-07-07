local sel_char = "<space>"
local desel_char = "<c-space>"

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = "nvim-treesitter/nvim-treesitter-textobjects",
		build = ":TSUpdate",
		opts = {
			ensure_installed = "all",
			ignore_install = {}, -- list of parsers to ignore installing
			highlight = {
				enable = true,
			},
			textobjects = {
				select = {
					-- we use mini.ai for this TODO: actually do this
					enable = false,
				},
				swap = {
					enable = true,
					swap_next = {
						["]a"] = { query = "@parameter.inner", desc = "swap parameter" },
					},
					swap_previous = {
						["[a"] = { query = "@parameter.inner", desc = "swap parameter" },
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]f"] = { query = "@function.outer", desc = "function start" },
						["]c"] = { query = "@class.outer", desc = "class start" },
					},
					goto_previous_start = {
						["[f"] = { query = "@function.outer", desc = "function start" },
						["[c"] = { query = "@class.outer", desc = "class start" },
					},
					goto_next_end = {
						["]F"] = { query = "@function.outer", desc = "function end" },
						["]C"] = { query = "@class.outer", desc = "class end" },
					},
					goto_previous_end = {
						["[F"] = { query = "@function.outer", desc = "function end" },
						["[C"] = { query = "@class.outer", desc = "class end" },
					},
				},
			},
		},
		config = function(_, opts)
			-- fold with treesitter
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

			require("nvim-treesitter.configs").setup(opts)
		end
	},
	{
		"nvim-treesitter/playground",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
}

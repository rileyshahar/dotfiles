return {
	-- file manager
	{
		"stevearc/oil.nvim",
		lazy = false, -- cant lazy load bc we need to be able to `nvim [dir]`
		config = true,
		opts = {
			keymaps = {
				["<c-t>"] = "actions.open_terminal",
				["<C-l>"] = false, -- removing a command doesnt work unless the c is capitalized :/
				["q"] = "actions.close", -- probably dont need macros i hope
			},
		},
		keys = {
			{
				"-",
				function()
					require("oil").open()
				end,
				desc = "file browser",
			},
		},
	},

	-- projects
	{
		"ahmedkhalf/project.nvim",
		dev = true,
		lazy = false,
		opts = {
			manual_mode = true,
		},
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function(opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
		end,
		keys = {
			{
				leaders.finder .. "p",
				function()
					require("telescope").extensions.projects.projects({})
				end,
			},
		},
	},

	-- window movement
	{
		"sindrets/winshift.nvim",
		keys = {
			{ "<c-w>h", "<cmd>WinShift left<cr>", "move window left", "n" },
			{ "<c-w>j", "<cmd>WinShift down<cr>", "move window down", "n" },
			{ "<c-w>k", "<cmd>WinShift up<cr>", "move window up", "n" },
			{ "<c-w>l", "<cmd>WinShift right<cr>", "move window right", "n" },
		},
	},
}

local function dash_title()
	local cwd = vim.iter(vim.split(vim.fn.getcwd(), "/")):last()
	if cwd:len() > 12 then
		cwd = table.concat(vim.iter(vim.split(cwd, "[-_ ]"))
			:map(function(v)
				return v:sub(1, 1)
			end)
			:totable())
	end

	return vim.fn.systemlist({ "figlet", cwd })
end

local function alpha_opts()
	local dashboard = require("alpha.themes.dashboard")

	local header = dash_title()

	dashboard.section.header.val = header
	dashboard.section.buttons.val = {
		dashboard.button("f", "  files", "<cmd>Telescope find_files<cr>"),
		dashboard.button("e", "  scratchpad", "<cmd>ene | startinsert<cr>"),
		dashboard.button("g", "  grep", "<cmd>Telescope live_grep<cr>"),
		dashboard.button(
			"p",
			"  projects",
			'<cmd>lua require("telescope").extensions.projects.projects({ default_action = _dash })<cr>'
		),
		dashboard.button("t", "  terminal", "<cmd>terminal<cr>"),
		dashboard.button(
			"m",
			"  forest",
			'<cmd>lua require("telescope.builtin").find_files({ cwd = "~/notes/forest/trees" })<cr><cmd>cd ~/notes/forest<cr>'
		),
		dashboard.button(
			"c",
			"  configs",
			'<cmd>lua require("telescope.builtin").find_files({ cwd = "$DOTFILES_DIR" })<cr>'
		),
		dashboard.button(
			"n",
			"  neovim configs",
			'<cmd>lua require("telescope.builtin").find_files({ cwd = "$DOTFILES_DIR/nvim" })<cr>'
		),
		dashboard.button("q", "  quit", "<cmd>qa<cr>"),
	}

	for _, button in ipairs(dashboard.section.buttons.val) do
		button.opts.hl = "AlphaButtons"
		button.opts.hl_shortcut = "AlphaShortcut"
	end
	dashboard.section.header.opts.hl = "AlphaHeader"
	dashboard.section.buttons.opts.hl = "AlphaButtons"
	dashboard.section.footer.opts.hl = "AlphaFooter"
	dashboard.opts.layout[1].val = 0

	-- TODO: taskwarrior
	-- local task = vim.trim(
	-- 	vim.fn.system('task next -BLOCKED limit:1 2>/dev/null | tail -n +4 | head -n 1 | sed "s/^ //" | cut -d " " -f1')
	-- )

	-- local desc = vim.trim("Your most recent task is " .. vim.fn.system({ "task", "_get", task .. ".description" }))
	-- 	.. "."

	return dashboard
end

function _dash()
	require("alpha").setup(alpha_opts().opts)
	vim.cmd("AlphaRedraw")
end

return {
	"machakann/vim-highlightedyank", -- highlight yanked text

	-- key viewer
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			prefixes = {
				{ "<c-t>", group = "terminal" },
				{ "<leader>", group = "leader" },
				{ "<leader>,", group = "local" },
				{ "<leader>e", group = "edit" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>m", group = "make" },
				{ "<leader>n", group = "notify" },
				{ "<leader>p", group = "plugin" },
				{ "<leader>r", group = "refactor" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "s", group = "surround" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add(opts.prefixes)
		end,
	},

	-- vim.ui
	{
		"stevearc/dressing.nvim",
		opts = function()
			return {
				input = {
					enabled = true,
					win_options = {
						winhighlight = "FloatBorder:NormalFloat",
					},
				},
				select = {
					telescope = require("telescope.themes").get_cursor(),
				},
			}
		end,
	},

	-- notify
	{
		"rcarriga/nvim-notify",
		lazy = false,
		opts = {
			timeout = 3000,
		},
		keys = {
			{
				"<leader>n",
				desc = "notifications",
			},
			{
				"<leader>nd",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "dismiss notifications",
			},
			{
				"<leader>nh",
				"<cmd>Notifications<cr>",
				desc = "notification history",
			},
		},
		config = function(_, opts)
			vim.notify = require("notify")
			require("notify").setup(opts)
		end,
		priority = 60,
	},

	-- zen
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 82, -- add 2 for signcolumn
				height = 0.95,
				backdrop = 1,
				options = {
					number = false, -- disable number column
					relativenumber = false, -- disable relative numbers
					-- signcolumn = "no",    -- disable signcolumn
					-- cursorline = false, -- disable cursorline
					-- cursorcolumn = false, -- disable cursor column
					-- foldcolumn = "0", -- disable fold column
					-- list = false, -- disable whitespace characters
				},
			},
			plugins = {
				-- options = {
				--   scrolloff = 999,
				-- },
				gitsigns = { enabled = true },
			},
		},
		keys = {
			{ leaders.ui .. "m", "<cmd>ZenMode<cr>", desc = "minimalist ui" },
		},
		cmd = "ZenMode",
	},

	-- twilight
	-- {
	-- 	"folke/twilight.nvim",
	-- 	opts = {
	-- 		-- your configuration comes here
	-- 		-- or leave it empty to use the default settings
	-- 		-- refer to the configuration section below
	-- 	},
	-- 	keys = {
	-- 		{ leaders.ui .. "t", "<cmd>Twilight<cr>", desc = "twilight" },
	-- 	},
	-- },

	-- dashboard
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		enabled = true,
		init = false,
		opts = alpha_opts,
		-- from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/alpha.lua
		config = function(_, dashboard)
			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					once = true,
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				once = true,
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded "
						.. stats.loaded
						.. "/"
						.. stats.count
						.. " plugins in "
						.. ms
						.. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = true,
	},

	-- {
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	opts = {
	-- 		term_colors = true,
	-- 		custom_highlights = {
	-- 			["@markup.italic"] = { link = "Italic" },
	-- 		},
	-- 		-- color_overrides = {
	-- 		-- 	mocha = {
	-- 		-- 		base = "#1a1b26",
	-- 		-- 	},
	-- 		-- },
	-- 	},
	-- },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			theme = "tokyonight",
		},
	},
}

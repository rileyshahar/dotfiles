local telescope = require("telescope")
local builtins = require("telescope.builtin")

-- setup
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<c-s>"] = "preview_scrolling_up",
			},
		},
	},
	pickers = {
		lsp_code_actions = {
			theme = "cursor",
		},
	},
})

-- keybinds
local function find_map(lhs, rhs, mode, opts)
	map(leaders.finder .. lhs, rhs, mode, opts)
	-- version to set default options
	-- local fn = function()
	-- 	local opt = require("telescope.themes").get_ivy({..})
	-- 	rhs(opt)
	-- end
	-- map(leaders.finder .. lhs, fn, mode, opts)
end

find_map("f", builtins.find_files)
find_map("g", builtins.live_grep)
find_map("w", builtins.grep_string) -- find word
find_map("b", builtins.buffers)
find_map("h", builtins.help_tags)
find_map("R", builtins.registers)
find_map("k", builtins.keymaps)

local function edit_map(key, cwd)
	map(leaders.edit .. key, function()
		-- edit nvim
		builtins.find_files({ cwd = cwd })
	end)
end

edit_map("n", "$DOTFILES_DIR/nvim") -- edit nvim
edit_map("c", "$DOTFILES_DIR") -- edit config

-- extensions
telescope.load_extension("fzf")

-- todo: github cli addon
-- todo: make highlight clearer

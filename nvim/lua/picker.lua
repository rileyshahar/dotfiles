-- keybinds
local telescope = require("telescope.builtin")

local function find_map(lhs, rhs, mode, opts)
	map(leaders.finder .. lhs, rhs, mode, opts)
end

find_map("f", telescope.find_files)
find_map("g", telescope.live_grep)
find_map("w", telescope.grep_string) -- find word
find_map("b", telescope.buffers)
find_map("h", telescope.help_tags)
find_map("R", telescope.registers)
find_map("cc", telescope.git_commits) -- commits
find_map("cb", telescope.git_bcommits) -- commits buffer

-- todo: github cli addon
-- todo: make highlight clearer

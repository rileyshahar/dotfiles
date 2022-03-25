local gitsigns = require("gitsigns")

gitsigns.setup({
	preview_config = {
		-- Options passed to nvim_open_win
		border = "none",
	},
})

-- Navigation
map("]c", gitsigns.next_hunk)
map("[c", gitsigns.prev_hunk)

local function git_map(lhs, rhs, mode, opts)
	map(leaders.git .. lhs, rhs, mode, opts)
end

-- Actions
git_map("s", gitsigns.stage_hunk)
git_map("r", gitsigns.reset_hunk)
git_map("S", gitsigns.stage_buffer)
git_map("R", gitsigns.reset_buffer)
git_map("u", gitsigns.undo_stage_hunk)
git_map("p", gitsigns.preview_hunk)
git_map("b", function()
	gitsigns.blame_line({ full = true })
end)
git_map("d", gitsigns.diffthis)

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

-- Actions
map("<leader>hs", gitsigns.stage_hunk)
map("<leader>hr", gitsigns.reset_hunk)
map("<leader>hS", gitsigns.stage_buffer)
map("<leader>hR", gitsigns.reset_buffer)
map("<leader>hu", gitsigns.undo_stage_hunk)
map("<leader>hp", gitsigns.preview_hunk)
map("<leader>hb", function()
	gitsigns.blame_line({ full = true })
end)
map("<leader>hd", gitsigns.diffthis)

require("gitsigns").setup({
	preview_config = {
		-- Options passed to nvim_open_win
		border = "none",
	},
})

-- Navigation
map("]c", "<cmd>Gitsigns next_hunk<CR>")
map("[c", "<cmd>Gitsigns prev_hunk<CR>")

-- Actions
map("<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
map("<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
map("<leader>hS", "<cmd>Gitsigns stage_buffer<cr>")
map("<leader>hR", "<cmd>Gitsigns reset_buffer<cr>")
map("<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>")
map("<leader>hp", "<cmd>Gitsigns preview_hunk<cr>")
map("<leader>hb", "<cmd>Gitsigns blame_line<cr>")
map("<leader>hd", "<cmd>Gitsigns diffthis<cr>")

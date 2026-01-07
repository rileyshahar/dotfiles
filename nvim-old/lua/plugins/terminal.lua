return {
	{
		"willothy/flatten.nvim",
		opts = {
			window = {
				open = "current",
			},
			callback = {
				post_open = function(bufnr, winnr, ft, is_blocking)
					-- If the file is a git commit, create one-shot autocmd to delete its buffer on write
					if ft == "gitcommit" or ft == "gitrebase" then
						vim.api.nvim_create_autocmd("BufWritePost", {
							buffer = bufnr,
							once = true,
							callback = vim.schedule_wrap(function()
								vim.api.nvim_buf_delete(bufnr, {})
							end),
						})
					end
				end,
			},
		},
	},
}

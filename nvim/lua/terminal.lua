-- on open
local termopen = vim.api.nvim_create_augroup("termopen", {})
local cmd = vim.api.nvim_create_autocmd("TermOpen", {
	group = termopen,
	callback = function(_)
		vim.cmd("setlocal nonumber norelativenumber")
	end
})

-- on enter
local termenter = vim.api.nvim_create_augroup("termenter", {})
local cmd = vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	pattern = { "fish" },
	group = termenter,
	callback = function(_)
		vim.cmd("startinsert")
	end
})

-- keybinds

-- on open
local termopen = vim.api.nvim_create_augroup("termopen", {})
local cmd = vim.api.nvim_create_autocmd("TermOpen", {
	group = termopen,
	callback = function(_)
		vim.cmd("setlocal nonumber norelativenumber")
	end,
})

-- on enter
local termenter = vim.api.nvim_create_augroup("termenter", {})
local cmd = vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
	pattern = { "fish" },
	group = termenter,
	callback = function(_)
		vim.cmd("startinsert")
	end,
})

-- keybinds
map("<c-t>", "<cmd>term<cr>", "open terminal", { "i", "n", "v", "x" })
map("<c-t>", "<cmd>bprev<cr>", "previous buffer", "t")
map("<C-CR>", "<cmd>vert term<cr>", "terminal in split", { "i", "n", "t", "v", "x" })
-- map("<C-S-CR>", "<cmd>q<cr>", "close terminal split", { "t" })
-- map("<c-w>", "<c-\\><c-n><c-w>", "window", "t")

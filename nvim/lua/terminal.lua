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
map("<c-t>", "<cmd>b#<cr>", "previous buffer", "t")
map("<C-CR>", "<cmd>vert term<cr>", "terminal in split", { "i", "n", "t", "v", "x" })

-- make <c-r> work properly
map("<c-r>", function()
	-- TODO: whichkey registers
	local reg = vim.fn.nr2char(vim.fn.getchar())
	local text = vim.trim(vim.fn.getreg(reg))
	vim.api.nvim_chan_send(vim.o.channel, text)
end, "insert from register", "t")

map("<localleader>g", function()
	require("flash").jump({
		pattern = "[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]",
		action = function(match, state)
			local text = vim.api.nvim_buf_get_text(
				vim.api.nvim_win_get_buf(match.win),
				match.pos[1] - 1,
				match.pos[2],
				match.end_pos[1] - 1,
				match.end_pos[2] + 1,
				{}
			)
			vim.fn.setreg("0", text)
			state:restore()
		end,
	})
end, "copy git hash", "t")

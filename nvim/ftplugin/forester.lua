vim.bo.makeprg = "scripts/server.sh"

vim.o.commentstring = "% %s"

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

local forester_task
local task_window

-- todo: there should be a way to better integrate all this with overseer
-- e.g. to have `watch` built into overseer
local function make_forester()
	local overseer = require("overseer")

	local task = overseer.new_task({
		cmd = vim.fn.expandcmd("scripts/server.sh"),
		components = {
			"default",
		},
	})

	task:start()

	-- open in new window below current one
	local main_win = vim.api.nvim_get_current_win()
	local splitbelow = vim.o.splitbelow
	vim.o.splitbelow = true
	overseer.run_action(task, "open hsplit")
	task_win = vim.api.nvim_get_current_win()
	vim.o.splitbelow = splitbelow
	vim.api.nvim_win_set_height(0, 8)
	vim.api.nvim_set_current_win(main_win)

	forester_task = task
end

local function stop_forester()
	local overseer = require("overseer")

	if forester_task then
		overseer.run_action(forester_task, "stop")
	end

	if task_win then
		vim.api.nvim_win_close(task_win, true)
	else
		vim.notify("forester: no server active", vim.log.levels.WARN)
	end

	forester_task = nil
	task_win = nil
end

map("<localleader>s", make_forester, "start forester server")
map("<localleader>c", stop_forester, "stop forester server")
map("<localleader>n", "<cmd>terminal note<cr>")

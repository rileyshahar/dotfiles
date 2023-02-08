-- modified from
-- https://phelipetls.github.io/posts/async-make-in-nvim-with-lua/
function async_run(prg_getter)
	local lines = { "" }
	local winnr = vim.fn.win_getid()
	local bufnr = vim.api.nvim_win_get_buf(winnr)

	local prg = prg_getter(bufnr)

	if not prg then
		return
	end

	local cmd = vim.fn.expandcmd(prg)

	local function on_write(_, data, _)
		if data then
			vim.list_extend(lines, data)
		end
	end

	local function on_exit(_, status, _)
		if status ~= 0 then
			local message = table.concat(lines, "\\n")
			vim.cmd('echo "' .. message .. '"')
		else
			vim.cmd('echo "made successfully"')
		end
	end

	local _ = vim.fn.jobstart(cmd, {
		on_stderr = on_write,
		on_stdout = on_write,
		on_exit = on_exit,
		stdout_buffered = true,
		stderr_buffered = true,
	})
end

vim.bo.makeprg = "make"

map("<leader>m", function()
	async_run(function(bufnr)
		return vim.api.nvim_buf_get_option(bufnr, "makeprg")
	end)
end)

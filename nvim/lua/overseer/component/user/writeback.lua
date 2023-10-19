return {
	desc = "run a task and write its output to the original buffer",
	-- Define parameters that can be passed in to the component
	-- params = {
	-- 	name = "command",
	-- },
	constructor = function(params)
		return {
			on_init = function(self, task)
				self.buf = vim.api.nvim_get_current_buf()
				self.lineno = vim.api.nvim_win_get_cursor(0)[1]
			end,

			on_output_lines = function(self, task, lines)
				local it = vim.iter(lines)
				it:map(function(v)
					return vim.fn.trim(v)
				end)
				lines = it:totable()

				vim.api.nvim_buf_set_lines(self.buf, self.lineno - 1, self.lineno, false, lines)
				self.lineno = self.lineno + #lines
			end,

			-- on_output = function(self, task, data)
			-- 	-- Called when there is output from the task
			-- end,
		}
	end,
}

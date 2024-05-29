-- TODO: templates or something
function make_async_run(cmd)
	-- -- local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
	-- if num_subs == 0 then
	-- 	cmd = cmd .. " " .. params.args
	-- end
	return function()
		local task = require("overseer").new_task({
			cmd = vim.fn.expandcmd(cmd),
			components = {
				{ "on_output_quickfix", open = true, open_height = 8 },
				"default",
			},
		})
		task:start()
	end
end

return {
	{
		"stevearc/overseer.nvim",
		keys = {
			{
				leaders.make .. "t",
				function()
					make_async_run(vim.bo.makeprg)()
				end,
				desc = "temporarily",
			},

			{ leaders.make .. "m", make_async_run("make"), desc = "default" },

			{ leaders.make .. "c", make_async_run("make clean"), desc = "clean" },

			{ leaders.make .. "v", "<cmd>!open /tmp/%<.pdf<cr> &", desc = "view" },
		},
		cmd = "Overseer",
		config = true,
		-- 	config = function(opts)
		-- 		require("overseer").setup(opts)
		-- 		vim.api.nvim_create_user_command("Make", function(params)
		-- 			-- Insert args at the '$*' in the makeprg
		-- 		end, {
		-- 			desc = "Run your makeprg as an Overseer task",
		-- 			nargs = "*",
		-- 			bang = true,
		-- 		})
		-- 	end,
	},

	{
		"chrishrb/gx.nvim",
		keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
		cmd = { "Browse" },
		init = function()
			vim.g.netrw_nogx = 1 -- disable netrw gx
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default settings
	},
}

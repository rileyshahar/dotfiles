-- from https://github.com/kylechui/nvim-surround/discussions/53
-- automatically insert markdown links
-- TODO: there's a buffer_setup that we really want here, but just isn't working for some reason
require("nvim-surround").setup({
	delimiters = {
		pairs = {
			["l"] = function()
				return {
					"[",
					"](" .. string.gmatch(vim.fn.getreg("+"), "[^\n]+")() .. ")",
				}
			end,
		},
	},
})

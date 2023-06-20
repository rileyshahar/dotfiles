vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

require("nvim-surround").setup({
	surrounds = {
		["l"] = {
			add = function()
				local clipboard = string.gmatch(vim.fn.getreg("+"), "[^\n]+")()
				return {
					{ "[" },
					{ "]{" .. clipboard .. "}" },
				}
			end,
			change = {
				target = "^()()%b{}%((.-)()%)$",
				replacement = function()
					local clipboard = vim.fn.getreg("+"):gsub("\n", "")
					return {
						{ "" },
						{ clipboard },
					}
				end,
			},
		},
	},
})

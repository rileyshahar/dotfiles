-- from https://github.com/kylechui/nvim-surround/discussions/53
-- automatically insert markdown links
-- TODO: there's a buffer_setup that we really want here, but just isn't working for some reason
vim.bo.makeprg = "pandoc -d default % -o /tmp/%<.pdf"

require("nvim-surround").setup({
	surrounds = {
		["l"] = {
			add = function()
				local clipboard = string.gmatch(vim.fn.getreg("+"), "[^\n]+")()
				return {
					{ "[" },
					{ "](" .. clipboard .. ")" },
				}
			end,
			find = "%b[]%b()",
			delete = "^(%[)().-(%]%b())()$",
			change = {
				target = "^()()%b[]%((.-)()%)$",
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

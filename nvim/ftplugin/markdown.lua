-- from https://github.com/kylechui/nvim-surround/discussions/53
-- automatically insert markdown links
-- TODO: there's a buffer_setup that we really want here, but just isn't working for some reason

vim.bo.makeprg = "pandoc -d default % -o /tmp/%<.pdf"
vim.wo.linebreak = true
vim.bo.textwidth = 80

require("nvim-surround").buffer_setup({
	surrounds = {
		["l"] = {
			add = function()
				local clipboard = vim.fn.getreg("+"):gsub("\n", "")
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

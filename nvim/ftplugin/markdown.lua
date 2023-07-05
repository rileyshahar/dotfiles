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
				local cfg = require("nvim-surround.config")
				local text = cfg.get_input("Enter the link target: ")
				-- local clipboard = vim.fn.getreg("+"):gsub("\n", "")
				if text then
					return {
						{ "[" },
						{ "](" .. text .. ")" },
					}
				end
			end,
			find = "%b[]%b()",
			delete = "^(%[)().-(%]%b())()$",
			change = {
				target = "^()()%b[]%((.-)()%)$",
				replacement = function()
					local cfg = require("nvim-surround.config")
					local text = cfg.get_input("Enter the link target: ")
					if text then
						return {
							{ "" },
							{ text },
						}
					end
				end,
			},
		},
	},
})

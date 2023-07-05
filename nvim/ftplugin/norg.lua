vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

require("nvim-surround").buffer_setup({
	surrounds = {
		["l"] = {
			add = function()
				local cfg = require("nvim-surround.config")
				local text = cfg.get_input("Enter the link target: ")
				if text then
					return {
						{ "[" },
						{ "]{" .. text .. "}" },
					}
				end
			end,
			find = "%b[]%b{}",
			delete = "^(%[)().-(%]%b{})()$",
			change = {
				target = "^()()%b[]%{(.-)()%}$",
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

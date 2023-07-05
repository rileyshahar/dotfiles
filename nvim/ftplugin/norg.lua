vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

require("nvim-surround").buffer_setup({
	surrounds = {
		["l"] = {
			add = function()
				local clipboard = vim.fn.getreg("+"):gsub("\n", "")
				local text = vim.fn.input({ prompt = "link: ", default = clipboard })
				return {
					{ "[" },
					{ "]{" .. text .. "}" },
				}
			end,
			find = "%b[]%b{}",
			delete = "^(%[)().-(%]%b{})()$",
			change = {
				target = "^()()%b[]%{(.-)()%}$",
				replacement = function()
					local clipboard = vim.fn.getreg("+"):gsub("\n", "")
					local text = vim.fn.input({ prompt = "link: ", default = clipboard })
					return {
						{ "" },
						{ text },
					}
				end,
			},
		},
	},
})

vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

require("nvim-surround").buffer_setup({
	surrounds = {
		["L"] = {
			add = function()
				local clipboard = vim.fn.getreg("+"):gsub("\n", "")
				if clipboard then
					return {
						{ "[" },
						{ "]{" .. clipboard .. "}" },
					}
				end
			end,
			find = "%b[]%b{}",
			delete = "^(%[)().-(%]%b{})()$",
			change = {
				target = "^()()%b[]%{(.-)()%}$",
				replacement = function()
					local clipboard = vim.fn.getreg("+"):gsub("\n", "")
					if clipboard then
						return {
							{ "" },
							{ clipboard },
						}
					end
				end,
			},
		},
		["l"] = {
			add = function()
				local text = vim.fn.input({ prompt = "Link: " })
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
					local text = vim.fn.input({ prompt = "Link: " })
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

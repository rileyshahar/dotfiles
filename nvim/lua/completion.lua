vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local ls = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "spell" },
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-s>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ select = true })
			elseif ls.expandable() then
				ls.expand()
			elseif ls.jumpable() then
				ls.jump(1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif ls.jumpable(-1) then
				ls.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<C-e>"] = cmp.mapping.abort(),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- from https://github.com/LunarVim/LunarVim/blob/5c0ccff78f199c46aea47fa756e7c748477e5c65/lua/lvim/core/cmp.lua
			local source_names = {
				luasnip = "(Snippet)",
				nvim_lsp = "(LSP)",
				treesitter = "(TS)",
				buffer = "(Buffer)",
				path = "(Path)",
				spell = "(Spell)",
			}
			local kind_icons = {
				Class = " ",
				Color = " ",
				Constant = "ﲀ ",
				Constructor = " ",
				Enum = "練",
				EnumMember = " ",
				Event = " ",
				Field = " ",
				File = "",
				Folder = " ",
				Function = " ",
				Interface = "ﰮ ",
				Keyword = " ",
				Method = " ",
				Module = " ",
				Operator = "",
				Property = " ",
				Reference = " ",
				Snippet = " ",
				Struct = " ",
				Text = " ",
				TypeParameter = " ",
				Unit = "塞",
				Value = " ",
				Variable = " ",
			}
			-- don't want duplicates unless it's a snippet
			local duplicates = {
				"luasnip",
			}
			vim_item.kind = kind_icons[vim_item.kind]
			vim_item.menu = source_names[entry.source.name]
			vim_item.dup = duplicates[entry.source.name] or 0
			return vim_item
		end,
	},
})

cmp.setup.cmdline(":", {
	sources = {
		{ name = "cmdline" },
	},
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" },
	}, {
		{ name = "buffer" },
	}),
})

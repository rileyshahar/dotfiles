vim.o.completeopt = "menu,menuone,noselect"

local cmp = require("cmp")
local ls = require("luasnip")

-- todo: normal tab doesn't work inside snippet, maybe need to turn off history
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	experimental = {
		ghost_text = { hl_group = "Conceal" },
	},
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "buffer", keyword_length = 3 },
		{ name = "path" },
		{ name = "spell", keyword_length = 3 },
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
		fields = { "abbr", "menu", "kind" },
		format = function(entry, vim_item)
			local source_names = {
				luasnip = "[snip]",
				nvim_lsp = "[lsp]",
				treesitter = "[ts]",
				buffer = "[buf]",
				path = "[path]",
				spell = "[spell]",
			}
			vim_item.menu = source_names[entry.source.name]
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

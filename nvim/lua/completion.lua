vim.opt.completeopt = { "menu", "menuone", "noselect" }

local cmp = require("cmp")
local ls = require("luasnip")
local compare = cmp.config.compare

-- TODO: normal tab doesn't work inside snippet, maybe need to turn off history
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
		{ name = "neorg" },
		{ name = "cmp_git" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		-- { name = "treesitter" },
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
				-- treesitter = "[ts]",
				buffer = "[buf]",
				path = "[path]",
				spell = "[spell]",
			}
			vim_item.menu = source_names[entry.source.name]
			return vim_item
		end,
	},
	-- TODO: is this order right / what do these all do? (just taken from reddit)
	sorters = {
		compare.offset,
		compare.exact,
		compare.score,
		require("cmp-under-comparator").under,
		compare.recently_used,
		compare.locality,
		compare.kind,
		compare.sort_text,
		compare.length,
		compare.order,
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "cmdline" },
		{ name = "path" },
	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

require("cmp_git").setup({
	filetypes = { "gitcommit", "github" },
})

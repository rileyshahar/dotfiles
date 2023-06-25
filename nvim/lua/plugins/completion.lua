return {
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_lua").load()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		keys = {
			-- jumping is mapped in cmp
			"<tab>",
			"<s-tab>",

			-- TODO: choice selectors?
		},
	},

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"petertriho/cmp-git",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-path",
			"ray-x/cmp-treesitter",
			"lukas-reineke/cmp-under-comparator",
		},
		opts = function()
			local cmp = require("cmp")
			local ls = require("luasnip")
			local compare = cmp.config.compare

			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<c-n>"] = cmp.mapping.select_next_item(),
					["<c-p>"] = cmp.mapping.select_prev_item(),
					["<c-b>"] = cmp.mapping.scroll_docs(-4),
					["<c-f>"] = cmp.mapping.scroll_docs(4),
					["<c-e>"] = cmp.mapping.abort(),
					["<c-space>"] = cmp.mapping.complete(),
					["<tab>"] = cmp.mapping(function(fallback)
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
					["<s-tab>"] = cmp.mapping(function(fallback)
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
				}),
				sources = {
					{ name = "neorg" },
					-- { name = "cmp_git" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					-- { name = "treesitter" },
					{ name = "buffer",  keyword_length = 3 },
					{ name = "path" },
					{ name = "spell",   keyword_length = 3 },
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
				experimental = {
					ghost_text = {
						hl_group = "Conceal",
					},
				},
			}
		end,
		config = function(_, opts)
			local cmp = require("cmp")

			cmp.setup(opts)
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
		end,
	},
}

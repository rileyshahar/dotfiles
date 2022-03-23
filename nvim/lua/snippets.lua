require("luasnip.loaders.from_vscode").lazy_load()

local ls = require("luasnip")

ls.config.set_config({
	history = true, -- jump back into snippets after leaving
	updateevents = "TextChanged,TextChangedI",
})

require("luasnip.loaders.from_vscode").lazy_load()

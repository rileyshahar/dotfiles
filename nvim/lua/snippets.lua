local ls = require("luasnip")

ls.config.set_config({
	history = true, -- jump back into snippets after leaving
	updateevents = "TextChanged,TextChangedI",
})

require("luasnip.loaders.from_lua").load()
require("luasnip.loaders.from_vscode").lazy_load()

map("<c-d>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { "i", "s" })

map("<c-s>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, { "i", "s" })

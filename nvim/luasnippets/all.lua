local ls = require("luasnip")

return {
	-- todo
	s("td", t("TODO: ")),

	-- todo with name
	s("tdn", fmt("TODO ({}): ", i(1))),

	-- date month
	s("dm", p(os.date, "%d-%m")),

	-- month date
	s("md", p(os.date, "%m/%d")),

	-- year month date
	s("ymd", p(os.date, "%Y-%m-%d")),
}

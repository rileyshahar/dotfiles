-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	s({ trig = "td", name = "TODO", dscr = "A simple TODO." }, t("TODO: ")),
	s({ trig = "atd", name = "assigned TODO", dscr = "An assigned TODO." }, fmt("TODO ({}): ", i(1))),
	s({ trig = "dm", name = "date-month", dscr = "The date and the month." }, p(os.date, "%d-%m")),
	s({ trig = "md", name = "month/date", dscr = "The month and the date." }, p(os.date, "%m/%d")),
	s({ trig = "ymd", name = "year-month-date", dscr = "The year, month, and date." }, p(os.date, "%Y-%m-%d")),
}

-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	s(
		{ trig = "template", name = "note template", dscr = "A note template." },
		fmt(
			[[
       \title{{{}}}
       \date{{{}}}
       \taxon{{{}}}
       \author{{rileyshahar}}

       \texpackage{{preamble}}
       \texpackage{{quiver}}
       \import{{macros01}}
       {}
      ]],
			{ i(1, "title"), p(os.date, "%Y-%m-%d"), c(2, { t("definition"), t("reference"), t("theorem") }), i(0) }
		)
	),

	s(
		{ trig = "ref", name = "reference", dscr = "A reference." },
		fmt(
			[[
			\meta{{ref-in}}{{{}}}
			\meta{{ref-at}}{{{}}}
			\meta{{ref-note}}{{{}}}
			{}
			]],
			{ i(1, "reference"), i(2, "label"), i(3, "note"), i(0) }
		)
	),
}

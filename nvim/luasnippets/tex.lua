-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	s(
		{ trig = "tcp", name = "2-column proof", dscr = "A two-column proof." },
		fmt(
			[[
      \begin{{align*}}
      {} &= {} &&\text{{{}}}  \\
         &= {} &&\text{{{}}}  \\
         &= {} &&\text{{{}}}
      \end{{align*}}
      ]],
			{ i(1), i(2), i(3), i(4), i(5), i(6), i(7) }
		)
	),
	s(
		{ trig = "doc", name = "document", dscr = "A document." },
		fmt(
			[[
      \input{{~/.config/tex/header-include.tex}}
      \title{{ {} }}
      \author{{Riley Shahar}}
      {}

      \begin{{document}}
      \maketitle

      {}

      \end{{document}}
      ]],
			{ i(1), c(2, { t("\\date{\\today}"), t("") }), i(0) }
		)
	),
	s(
		{ trig = "toc", name = "table of contents", dscr = "The table of contents." },
		t({
			"\\setcounter{tocdepth}{2}",
			"\\tableofcontents",
		})
	),
}

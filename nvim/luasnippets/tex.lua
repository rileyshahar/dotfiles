-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	s(
		{ trig = "beg", name = "environment", dscr = "Enclose an environment." },
		fmt(
			[[
      \begin{{{}}}
        {}
      \end{{{}}}
      ]],
			{ i(1), i(0), rep(1) }
		)
	),
	s(
		{ trig = "cas", name = "cases", dscr = "Cases in math." },
		fmt(
			[[
      \begin{{cases}}
        {} & \text{{ if }}{} \\
        {} & \text{{ if }}{}
      \end{{cases}}
      {}
      ]],
			{
				i(1),
				i(2),
				i(3),
				i(4),
				i(0),
			}
		)
	),
	s(
		{ trig = "tcp", name = "2-column proof", dscr = "A two-column proof." },
		fmt(
			[[
      \begin{{align*}}
      {} &= {} &&\text{{{}}}  \\
         &= {} &&\text{{{}}}  \\
         &= {} &&\text{{{}}}
      \end{{align*}}
			{}
      ]],
			{ i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(0) }
		)
	),
	s(
		{ trig = "toc", name = "table of contents", dscr = "The table of contents." },
		t({
			"\\setcounter{tocdepth}{2}",
			"\\tableofcontents",
		})
	),
	s({ trig = "lab", name = "label", dscr = "A label." }, fmt("\\label{{{}}}", i(1))),
	s({ trig = "ref", name = "reference", dscr = "A reference." }, fmt("\\ref{{{}}}", i(1))),
	s(
		{ trig = "prob", name = "problem", dscr = "A problem." },
		fmt(
			[[
		  \begin{{prob}}
		    {}
		  \end{{prob}}
		  {}
		  ]],
			{ i(1), i(0) }
		)
	),
	s(
		{ trig = "thm", name = "theorem", dscr = "A theorem." },
		fmt(
			[[
			\begin{{{}}}\label{{{}}}
		    {}
		  \end{{{}}}
		  {}
		  ]],
			{ c(1, {
				t("thm"),
				t("prop"),
				t("cor"),
			}), i(2), i(3), rep(1), i(0) }
		)
	),
	s(
		{ trig = "dfn", name = "definition", dscr = "A definition." },
		fmt(
			[[
		  \begin{{dfn}}[{}]
		    {}
		  \end{{dfn}}
		  {}
		  ]],
			{ i(1), i(2), i(0) }
		)
	),
	s(
		{ trig = "prf", name = "proof", dscr = "A proof.", priority = 2000 },
		fmt(
			[[
		  \begin{{proof}}
		    {}
		  \end{{proof}}
		  {}
		  ]],
			{ i(1), i(0) }
		)
	),
	s(
		{ trig = "sfn", name = "small function", dscr = "A small block function definition." },
		fmt(
			[[ $${} \colon {} \to {};\quad {} \mapsto {}$$ {}]],
			{ i(1, "f"), i(2, "X"), i(3, "Y"), i(4, "x"), i(5, "y"), i(0) }
		)
	),

	s(
		{ trig = "fn", name = "function", dscr = "A block function definition." },
		fmt(
			[[
      \begin{{align*}}
				{} \colon {} &\to {}\\
				{} &\mapsto {}
      \end{{align*}}
      {}
      ]],
			{ i(1, "f"), i(2, "X"), i(3, "Y"), i(4, "x"), i(5, "y"), i(0) }
		)
	),
}

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
	s({ trig = "ref", name = "reference", dscr = "A reference." }, fmt("\\Cref{{{}}}", i(1))),
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
			\begin{{{}}}\label{{thm:{}}}
		    {}
		  \end{{{}}}
		  ]],
			{ c(1, {
				t("thm"),
				t("prop"),
				t("cor"),
			}), i(2), i(0), rep(1) }
		)
	),
	s(
		{ trig = "dfn", name = "definition", dscr = "A definition." },
		fmt(
			[[
			\begin{{dfn}}[{}]\label{{def:{}}}
        {}
	    \end{{dfn}}
		  ]],
			{ i(1), rep(1), i(0) }
		)
	),
	s(
		{ trig = "con", name = "construction", dscr = "A construction." },
		fmt(
			[[
			\begin{{con}}[{}]\label{{con:{}}}
        {}
	    \end{{con}}
		  ]],
			{ i(1), rep(1), i(0) }
		)
	),
	s(
		{ trig = "ex", name = "example", dscr = "An example." },
		fmt(
			[[
			\begin{{ex}}[{}]\label{{ex:{}}}
        {}
	    \end{{ex}}
		  ]],
			{ i(1), rep(1), i(0) }
		)
	),
	s(
		{ trig = "prf", name = "proof", dscr = "A proof.", priority = 2000 },
		fmt(
			[[
		  \begin{{proof}}
		    {}
		  \end{{proof}}
		  ]],
			{ i(0) }
		)
	),
	s(
		{ trig = "fig", name = "figure", dscr = "A figure." },
		fmt(
			[[
    \begin{{figure}}[H]
      \centering
      {}
    \end{{figure}}
    ]],
			{ i(0) }
		)
	),
	s(
		{ trig = "tikzcd", name = "tikz commutative diagram", dscr = "A commutative diagram in TikZ." },
		fmt(
			[[
    \begin{{tikzcd}}
      {}
      X & Y & Z & W
      \arrow["f", from=1-1, to=1-2]
      \arrow["g", from=1-2, to=1-3]
      \arrow["h", from=1-3, to=1-4]
      \arrow["gf"', curve={{height=18pt}}, from=1-1, to=1-3]
      \arrow["hg", curve={{height=-18pt}}, from=1-2, to=1-4]
    \end{{tikzcd}}
    ]],
			{ i(0) }
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
	-- zettlekasten snippets
	s(
		{ trig = "znote", name = "zettle note", dscr = "A zettlekasten note." },
		fmt(
			[[
        \input{{resources/_preamble.tex}}

        \tag{{{}}}

        {}

        \input{{resources/_postamble.tex}}
      ]],
			{ i(1), i(0) }
		)
	),
	s(
		{ trig = "zdef", name = "zettle definition", dscr = "A zettlekasten definition note." },
		fmt(
			[[
        \input{{resources/_preamble.tex}}

        \tag{{{}}}

        \begin{{dfn*}}[{}]
          {}
        \end{{dfn*}}

        \input{{resources/_postamble.tex}}
      ]],
			{ i(1), i(2), i(0) }
		)
	),
}

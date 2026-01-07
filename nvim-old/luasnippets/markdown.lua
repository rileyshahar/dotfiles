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
		{ trig = "ip", name = "braket inner product", dscr = "Braket notation inner product." },
		fmt("\\braket{{{}, {}}}", { i(1), i(2) })
	)
}

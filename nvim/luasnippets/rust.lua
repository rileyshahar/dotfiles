-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	-- test
	s(
		{ trig = "test", name = "test", dscr = "A test case." },
		fmt(
			[[
			#[test]
			fn {}() {{
				{}
			}}
			]],
			{ i(1, "it_works"), i(2, "assert!(true);") }
		)
	),

	-- test module
	s(
		{ trig = "tm", name = "test module", dscr = "A test module." },
		fmt(
			[[
			#[cfg(test)]
			mod {} {{
				use super::*;

				{}
			}}
			]],
			{ i(1, "tests"), i(2) }
		)
	),
}

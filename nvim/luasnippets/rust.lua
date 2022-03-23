local ls = require("luasnip")

-- local arg = sn(nil, { i(1, "bar"), t(": "), i(2, "i32") })

-- empty or " -> {$pos:i32} "
local function ret(pos) end

-- "{$1:foo}: {$2:i32}"
local function typed(pos)
	return sn(pos, fmt("{}: {}", { i(1, "foo"), i(2, "i32") }))
end

-- expands to an arbitary number of separated typed identifiers
local function separated_typed(_, _, _, pos, sep, newl)
	local recursive
	if newl then
		-- need to do this because we can't put newlines in the sep, it gives some low-level nvim/luasnip error
		recursive = sn(
			1,
			-- note the intent on the second row, this is needed because recursive calls lose indent info
			fmt(
				[[
		{}{}
			{}
		]],
				{ d(1, separated_typed, {}, { user_args = { nil, sep, newl } }), t(sep), typed(2) }
			)
		)
	else
		-- recursively calling this snippet, separated by the separator
		recursive = sn(1, { d(1, separated_typed, {}, { user_args = { nil, sep, newl } }), t(sep), typed(2) })
	end

	return sn(
		-- set the jump position
		pos,

		c(1, {
			-- no args
			t(""),

			-- recursive call
			recursive,

			-- one arg (or the final arg)
			typed(2),
		})
	)
end

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

	-- function
	s(
		{
			trig = "fn",
			name = "function",
			dscr = { "A function.", "Cycle number of parameters or yes/no return value." },
		},
		fmt(
			[[
		fn {}({}){}{{
			{}
		}}
		]],
			{
				-- fn name
				i(1, "foo"),

				-- params
				separated_typed(nil, nil, nil, 2, ", ", false),

				-- return value
				c(3, {
					sn(nil, { t(" -> "), i(1, "i32"), t(" ") }),
					t(" "),
				}),

				-- body
				i(4, "todo!();"),
			}
		)
	),

	s(
		{ trig = "struct", name = "struct", dscr = { "A struct.", "Cycle number of fields." } },
		fmt(
			[[
	struct {} {{
		{}
	}}
	]],
			{ i(1, "Foo"), separated_typed(nil, nil, nil, 2, ",", true) }
		)
	),
}

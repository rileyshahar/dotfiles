local ls = require("luasnip")

-- local arg = sn(nil, { i(1, "bar"), t(": "), i(2, "i32") })

-- empty or " -> {$pos:i32} "
local function ret(pos) end

-- "{$1:foo}: {$2:i32}"
local function typed(pos)
	return sn(pos, fmt("{}: {}", { i(1, "foo"), i(2, "i32") }))
end

-- expands to an arbitary number of comma-separated parameters
local function params(pos)
	return sn(
		-- set the jump position
		pos,

		c(1, {
			-- no args
			t(""),

			-- recursively calling this snippet, separated by commas
			sn(1, { d(1, params, {}), t(", "), typed(2) }),

			-- one arg (or the final arg)
			typed(2),
		})
	)
end

return {
	-- test
	s(
		"test",
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
		"tm",
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
		"fn",
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
				params(2),

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
}

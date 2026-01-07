-- selene: allow(unused_variable)
local ls = require("luasnip")

return {
	s(
		{ trig = "main", name = "main", desc = "A main function." },
		fmt(
			[[
      def _main():
          {}


      if __name__ == "__main__":
          _main()
      ]],
			{ i(1, 'print("Hello, world!")') }
		)
	),
}

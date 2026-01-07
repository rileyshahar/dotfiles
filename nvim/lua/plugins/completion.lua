return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      local ok_ls, ls = pcall(require, "luasnip")

      opts.snippets = opts.snippets or {}
      opts.snippets.preset = "luasnip"

      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }

      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "super-tab"

      opts.keymap["<Tab>"] = {
        "snippet_forward",
        "select_and_accept",
        function()
          if ok_ls and ls.expandable() then
            ls.expand()
            return true
          end
        end,
        "fallback",
      }

      opts.keymap["<S-Tab>"] = {
        "snippet_backward",
        "select_prev",
        "fallback",
      }

      opts.keymap["<C-n>"] = { "select_next", "fallback_to_mappings" }
      opts.keymap["<C-p>"] = { "select_prev", "fallback_to_mappings" }

      opts.keymap["<C-b>"] = { "scroll_documentation_up", "fallback" }
      opts.keymap["<C-f>"] = { "scroll_documentation_down", "fallback" }

      opts.keymap["<C-e>"] = {
        function(cmp)
          if ok_ls and ls.locally_jumpable and ls.locally_jumpable(1) then
            ls.unlink_current()
            return true
          end
          return cmp.cancel()
        end,
        "fallback",
      }

      opts.keymap["<C-Space>"] = { "show", "show_documentation", "hide_documentation" }
      opts.keymap["<C-q>"] = { "select_and_accept", "fallback" }

      -- LuaSnip choice-node cycling
      opts.keymap["<C-s>"] = {
        function()
          if ok_ls and ls.choice_active and ls.choice_active() then
            ls.change_choice(1)
            return true
          end
        end,
        "fallback",
      }

      opts.keymap["<C-d>"] = {
        function()
          if ok_ls and ls.choice_active and ls.choice_active() then
            ls.change_choice(-1)
            return true
          end
        end,
        "fallback",
      }
    end,
  },
}

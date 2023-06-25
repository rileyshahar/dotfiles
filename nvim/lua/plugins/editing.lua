return {
  -- autoclose paired characters
  {
    "windwp/nvim-autopairs",
    config = true,
  },

  -- exchange
  {
    "gbprod/substitute.nvim",
    config = true,
    keys = function()
      local sub = require("substitute")
      local exc = require("substitute.exchange")
      return {
        { "<leader>s",  sub.operator, desc = "substitute" },
        { "<leader>ss", sub.line,     desc = "substitute line" },
        { "<leader>S",  sub.eol,      desc = "substitute to eol" },
        { "<leader>S",  sub.visual,   desc = "substitute selection", mode = "x" },
        { "cx",         exc.operator, desc = "exchange" },
        { "cxx",        exc.line,     desc = "exchange line" },
        { "X",          exc.visual,   desc = "exchange selection",   mode = "x" },
        { "cxc",        exc.cancel,   desc = "cancel exchange" },
      }
    end,
  },

  "machakann/vim-highlightedyank", -- highlight yanked text

  -- surround
  {
    "echasnovski/mini.surround",
    init = function()
      vim.keymap.del({ "n", "v" }, "s")
      map("S", "s", "substitute")
    end,
    opts = {
      search_method = "cover",
      n_lines = 500,
    },
    keys = {
      { "s",  desc = "surround",      mode = { "n", "v" } },
      { "sa", desc = "add",           mode = { "n", "v" } },
      { "sd", desc = "delete" },
      { "sf", desc = "find" },
      { "sF", desc = "find_left" },
      { "sh", desc = "highlight" },
      { "sr", desc = "replace" },
      { "sn", desc = "update_n_lines" },
    }
  },

  -- navigation/movement
  "chaoren/vim-wordmotion", -- snake case word

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        search_method = "cover",
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)

      -- register all text objects with which-key
      local keys = {
        [" "] = "whitespace",
        ['"'] = 'double quote',
        ["'"] = "single quote",
        ["`"] = "backtick",
        ["("] = "parentheses",
        [")"] = "parentheses (ws)",
        ["<lt>"] = "angle bracket",
        [">"] = "angle bracket (ws)",
        ["["] = "square bracket",
        ["]"] = "square bracket (ws)",
        ["{"] = "curly brace",
        ["}"] = "curly brace (ws)",
        ["?"] = "prompt",
        _ = "underscore",
        a = "argument",
        B = "block",
        b = "brackets",
        c = "class",
        f = "function",
        o = "block, conditional, or loop",
        q = "quote",
        t = "tag",
        l = "last textobject",
        n = "next textobject",
        p = "paragraph",
        s = "sentence",
        w = "word",
        W = "WORD",
      }
      require("which-key").register({
        mode = { "o", "x" },
        i = keys,
        a = keys,
      })
    end,
  },
}

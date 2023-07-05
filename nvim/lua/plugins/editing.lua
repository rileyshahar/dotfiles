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

  "chaoren/vim-wordmotion",        -- snake case w etc

  {
    "Wansmer/treesj",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false
    },
    keys = function()
      local tsj = require("treesj")
      return {
        { leaders.surround .. "t", tsj.toggle, desc = "toggle splitjoin" },
        { leaders.surround .. "s", tsj.split,  desc = "split brackets" },
        { leaders.surround .. "j", tsj.join,   desc = "join brackets" },
      }
    end
  },

  -- surround
  {
    "kylechui/nvim-surround",
    init = function()
      -- since we use s for surround
      map("S", "s", "substitute", { "n", "v" })
    end,
    lazy = false, -- we need this for some reason
    opts = {
      keymaps = {
        normal = leaders.surround .. "a",
        normal_cur = leaders.surround .. "aa",
        normal_line = leaders.surround .. "A",
        normal_cur_line = leaders.surround .. "AA",
        visual = leaders.surround .. "a",
        visual_line = leaders.surround .. "A",
        delete = leaders.surround .. "d",
        change = leaders.surround .. "c",
      }
    },
    keys = {
      { leaders.surround,         desc = "surround",                    mode = { "n", "v" } },
      { leaders.surround .. "a",  desc = "add",                         mode = { "n", "v" } },
      { leaders.surround .. "aa", desc = "add around line", },
      { leaders.surround .. "A",  desc = "add (w newline)",             mode = { "n", "v" } },
      { leaders.surround .. "AA", desc = "add around line (w newline)", },
      { leaders.surround .. "d",  desc = "delete" },
      { leaders.surround .. "c",  desc = "change" },
    }
  },

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

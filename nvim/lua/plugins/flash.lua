return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      search = {
        -- only find beginnings of words
        mode = function(str)
          return "\\<" .. str
        end,
      },
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
          highlight = { backdrop = false },
        },
      },
    },
    keys = function()
      local flash = require("flash")
      return {
        { "<space>", flash.jump, desc = "flash", mode = { "n", "x" } },
        { "<c-space>", flash.treesitter, desc = "flash treesitter", mode = { "n", "x", "o" } },
        { "<space>", flash.remote, desc = "flash remote", mode = "o" },
        { "<c-s>", flash.toggle, desc = "toggle flash search", mode = "c" },
      }
    end,
  },
}

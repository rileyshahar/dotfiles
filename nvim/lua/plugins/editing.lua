return {
  {
    "nvim-mini/mini.surround",
    init = function()
      -- vim.keymap.del({ "n", "v" }, "s")
    end,
    opts = {
      search_method = "cover",
      n_lines = 500,
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sc",
        update_n_lines = "sn",
      },
    },
    keys = {
      -- since we use s for surround
      { "S", "s", desc = "substitute", mode = { "n", "v" } },
    },
  },

  {
    "nvim-mini/mini.operators",
    config = true,
    keys = {
      { "g=", desc = "evaluate" },
      { "g+", "g=$", desc = "evaluate to eol", remap = true },

      { "gx", desc = "exchange" },
      { "gE", "ge$", desc = "exchange to eol", remap = true },

      { "gm", desc = "multiply" },
      { "gM", "gm$", desc = "multiply to eol", remap = true },

      -- todo: overriding references
      { "gr", desc = "replace" },
      { "gR", "gr$", desc = "replace to eol", remap = true },

      { "gs", desc = "sort" },
      { "gS", "gs$", desc = "sort to eol", remap = true },
    },
  },
}

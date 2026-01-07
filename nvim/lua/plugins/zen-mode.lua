return {
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 82, -- add 2 for signcolumn
        height = 0.95,
        backdrop = 1,
        options = {
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          -- signcolumn = "no",    -- disable signcolumn
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- options = {
        --   scrolloff = 999,
        -- },
        gitsigns = { enabled = true },
      },
    },
    keys = {
      { Leaders.ui .. "z", "<cmd>ZenMode<cr>", desc = "zen mode" },
    },
    cmd = "ZenMode",
  },
}

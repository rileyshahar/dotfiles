return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  {
    "nvim-mini/mini.files",
    opts = function(_, opts)
      opts.options.use_as_default_explorer = true
    end,

    keys = {
      -- add your own key to open at cwd
      {
        "-",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "file explorer",
      },
    },
  },
}

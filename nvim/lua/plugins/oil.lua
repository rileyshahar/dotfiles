return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "nvim-mini/mini.files", enabled = false },

  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
    },

    keys = {
      {
        "-",
        function()
          require("oil").open(vim.uv.cwd())
        end,
        desc = "file explorer",
      },
      {
        "<leader>e",
        function()
          require("oil").open(LazyVim.root())
        end,
        desc = "Explorer Oil (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("oil").open(vim.uv.cwd())
        end,
        desc = "Explorer Oil (cwd)",
      },
      {
        "<leader>fe",
        function()
          require("oil").open(LazyVim.root())
        end,
        desc = "Explorer Oil (Root Dir)",
      },
      {
        "<leader>fE",
        function()
          require("oil").open(vim.uv.cwd())
        end,
        desc = "Explorer Oil (cwd)",
      },
    },
  },
}

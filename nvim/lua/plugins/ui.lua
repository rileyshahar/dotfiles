return {
  -- key viewer
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      prefixes = {
        ["g"] = { name = "goto" },
        ["]"] = { name = "next" },
        ["["] = { name = "prev" },
        ["s"] = { name = "surround" },
        ["<leader>"] = {
          name = "leader",
          ["m"] = { name = "make" },
          ["f"] = { name = "find" },
          ["g"] = { name = "git" },
          [","] = { name = "local" },
          ["e"] = { name = "edit" },
          ["p"] = { name = "plugin" },
          ["r"] = { name = "refactor" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.prefixes)
    end,
  },

  -- vim.ui
  {
    "stevearc/dressing.nvim",
    opts = function()
      return {
        input = {
          enabled = true,
          win_options = {
            winhighlight = "FloatBorder:NormalFloat"
          }
        },
        select = {
          telescope = require("telescope.themes").get_cursor(),
        }
      }
    end
  },

  -- notify
  {
    "rcarriga/nvim-notify",
    lazy = false,
    opts = {
      timeout = 3000,
    },
    keys = {
      {
        "<leader>n",
        desc = "notifications",
      },
      {
        "<leader>nd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "dismiss notifications",
      },
      {
        "<leader>nh",
        "<cmd>Notifications<cr>",
        desc = "notification history",
      },
    },
    config = function(_, opts)
      vim.notify = require("notify")
      require("notify").setup(opts)
    end,
    priority = 60,
  }
}

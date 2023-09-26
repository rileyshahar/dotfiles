return {
  "machakann/vim-highlightedyank", -- highlight yanked text

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
        ["<c-t>"] = { name = "terminal" },
        ["<leader>"] = {
          name = "leader",
          ["m"] = { name = "make" },
          ["f"] = { name = "find" },
          ["g"] = { name = "git" },
          [","] = { name = "local" },
          ["e"] = { name = "edit" },
          ["p"] = { name = "plugin" },
          ["r"] = { name = "refactor" },
          ["n"] = { name = "notify" },
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
  },

  -- zen
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        width = 82, -- add 2 for signcolumn
        height = 0.95,
        backdrop = 1,
        options = {
          number = false,         -- disable number column
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
      }
    },
    keys = {
      { leaders.ui .. "m", "<cmd>ZenMode<cr>", desc = "minimalist ui" }
    },
    cmd = "ZenMode"
  },

  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      { leaders.ui .. "t", "<cmd>Twilight<cr>", desc = "twilight" }
    },
  }
}

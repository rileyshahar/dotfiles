return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}

      local Snacks = require("snacks")

      local function dash_title()
        local cwd = vim.iter(vim.split(vim.fn.getcwd(), "/")):last()
        if cwd:len() > 12 then
          cwd = table.concat(vim
            .iter(vim.split(cwd, "[-_ ]"))
            :map(function(v)
              return v:sub(1, 1)
            end)
            :totable())
        end

        if vim.fn.executable("figlet") == 0 then
          return { cwd }
        end

        return vim.fn.systemlist({ "figlet", cwd })
      end

      local function envpath(name, fallback)
        local v = vim.fn.expand("$" .. name)
        if v == "$" .. name or v == "" then
          return vim.fn.expand(fallback)
        end
        return v
      end

      local dotfiles = envpath("DOTFILES_DIR", "~/.dotfiles")
      local forest = vim.fn.expand("~/notes/forest")
      local forest_trees = forest .. "/trees"

      -- Route dashboard pick actions through LazyVim's picker abstraction
      opts.dashboard.preset.pick = function(cmd, pick_opts)
        return LazyVim.pick(cmd, pick_opts)()
      end

      -- Header (string)
      opts.dashboard.preset.header = table.concat(dash_title(), "\n")

      -- Buttons / keys
      -- stylua: ignore
      opts.dashboard.preset.keys = {
        { icon = " ", key = "f", desc = "files",          action = LazyVim.pick('files') },
        { icon = " ", key = "e", desc = "scratchpad",     action = ":ene | startinsert" },
        { icon = " ", key = "g", desc = "grep",           action = LazyVim.pick('live_grep') },
        { icon = " ", key = "p", desc = "projects",       action = LazyVim.pick('projects') },

        { icon = " ", key = "t", desc = "terminal",       action = ":terminal" },

        { icon = " ", key = "c", desc = "configs",        action = LazyVim.pick("files", { cwd = dotfiles }) },

        { icon = " ", key = "n", desc = "neovim configs", action = LazyVim.pick("files", { cwd = dotfiles .. "/nvim" }) },

        { icon = " ", key = "q", desc = "quit",           action = ":qa" },
      }
    end,
  },
}

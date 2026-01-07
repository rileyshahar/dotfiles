Leaders = {
  edit = "<leader>e",
  finder = "<leader>f",
  git = "<leader>g",
  go = "g",
  make = "<leader>m",
  notify = "<leader>n",
  plugin_meta = "<leader>p",
  surround = "s",
  terminal = "<c-t>",
  -- terminal_local = "<C-'>",
  ui = "<leader>u",
}

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local pp = require("config.project_patterns")
vim.g.root_spec = { "lsp", pp.patterns, "cwd" }

require("utils")
require("config.neovide")
require("config.terminal")

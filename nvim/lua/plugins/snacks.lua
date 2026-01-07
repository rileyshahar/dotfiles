local pp = require("config.project_patterns")

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            patterns = pp.patterns,
            dev = { "~/dotfiles", "~/notes", "~/code" },
            recent = true,
          },
        },
      },
    },
  },
}

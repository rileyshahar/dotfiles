local pp = require("config.project_patterns")

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          projects = {
            patterns = pp.patterns,
            dev = { "~/dotfiles", "~/notes", "~/code", "~/notes/writing", "~/notes/writing/math" },
            recent = true,
          },
        },
      },
    },
  },
}

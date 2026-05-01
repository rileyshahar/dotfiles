-- lua/plugins/conform.lua
return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.tex = { "latexindent" }
      opts.formatters_by_ft.plaintex = { "latexindent" }

      opts.formatters = opts.formatters or {}
      opts.formatters.latexindent = vim.tbl_deep_extend("force", opts.formatters.latexindent or {}, {
        prepend_args = { "-m", "-l=" .. vim.fn.stdpath("config") .. "/latexindent.yaml" },
      })
      opts.formatters.prettier = vim.tbl_deep_extend("force", opts.formatters.prettier or {}, {
        prepend_args = { "--prose-wrap", "always", "--print-width", "80" },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, "latexindent") then
        table.insert(opts.ensure_installed, "latexindent")
      end
    end,
  },
}

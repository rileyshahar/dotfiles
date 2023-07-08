local diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim", -- signature while typing
    },
    opts = {
      -- options for :h vim.diagnostic.config()
      diagnostics = {
        underline = false,
        virtual_text = {
          spacing = 4,
          source = true,

          -- dynamically set prefix
          prefix = function(diagnostic)
            for d, icon in pairs(diagnostic_icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
            return "●"
          end,
        },
        severity_sort = true,
      },
      autoformat = true,
      servers = {
        clangd = {},
        texlab = {
          -- filetypes = { "tex", "plaintex", "bib", "markdown" },
          settings = {
            latex = {
              lint = {
                onSave = true,
              },
            },
          },
        },
        lua_ls = {},
        taplo = {},
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pydocstyle = {
                  enabled = true,
                },
              },
            },
          },
        },
        rust_analyzer = {
          cmd = { "rustup", "run", "stable", "rust-analyzer" },
          settings = {
            ["rust-analyzer"] = {
              check = {
                overrideCommand = {
                  "cargo",
                  "clippy",
                  "--all-targets",
                  "--all-features",
                  "--message-format=json",
                  "--",
                  "-W",
                  "clippy::nursery",
                  "-W",
                  "clippy::pedantic",
                  "--verbose",
                },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope.builtin")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttach", { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local group = vim.api.nvim_create_augroup("LspFormat", { clear = true })

          -- keys
          local action
          if client.server_capabilities.codeActionProvider then
            action = vim.lsp.buf.code_action
          else
            action = function()
              vim.notify("no code action provider", vim.diagnostic.severity.W)
            end
          end

          local rename
          if client.server_capabilities.renameProvider then
            rename = vim.lsp.buf.rename
          else
            rename = function()
              vim.notify("no rename provider", vim.diagnostic.severity.W)
            end
          end

          local keys = {
            -- gotos
            {
              leaders.go .. "D",
              vim.lsp.buf.declaration,
              desc =
              "declaration"
            },
            {
              leaders.go .. "d",
              telescope.lsp_definitions,
              desc =
              "definitions"
            },
            {
              leaders.go .. "i",
              telescope.lsp_implementations,
              desc =
              "implementations"
            },
            {
              leaders.go .. "t",
              telescope.lsp_type_definitions,
              desc =
              "type definitions"
            },

            -- finders
            {
              leaders.finder .. "S",
              telescope.lsp_workspace_symbols,
              desc =
              "workspace symbols"
            },
            {
              leaders.finder .. "s",
              telescope.lsp_document_symbols,
              desc =
              "document symbols"
            },
            {
              leaders.finder .. "r",
              telescope.lsp_references,
              desc =
              "references"
            },
            {
              leaders.finder .. "d",
              telescope.diagnostics,
              desc =
              "diagnostics"
            },
            -- TODO: errors?

            -- actions
            {
              "<leader>c",
              vim.lsp.codelens.run,
              desc =
              "run codelens"
            },
            {
              "<leader>a",
              action,
              desc =
              "code actions"
            },
            { "<leader>rn", rename, desc = "rename" },

            -- documentation
            {
              "K",
              vim.lsp.buf.hover,
              desc =
              "float docs"
            },
            {
              "<leader>k",
              vim.lsp.buf.signature_help,
              desc =
              "float signature"
            },

            -- diagnostics
            {
              "<leader>d",
              vim.diagnostic.open_float,
              desc =
              "float diagnostics"
            },
            {
              "[d",
              function()
                vim.diagnostic.goto_prev({ wrap = true })
              end,
              desc = "diagnostic",
            },
            {
              "]d",
              function()
                vim.diagnostic.goto_next({ wrap = true })
              end,
              desc = "diagnostic",
            },
            {
              "[e",
              function()
                vim.diagnostic.goto_prev({
                  wrap = true,
                  severity = vim.diagnostic.severity.ERROR
                })
              end,
              desc = "error",
            },
            {
              "]e",
              function()
                vim.diagnostic.goto_next({
                  wrap = true,
                  severity = vim.diagnostic.severity.ERROR
                })
              end,
              desc = "error",
            },
          }

          for _, key in ipairs(keys) do
            map(key[1], key[2], key.desc)
          end

          -- setup code lens
          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_augroup("CodeLens", { clear = true })
            vim.api.nvim_create_autocmd(
              { "BufEnter", "CursorHold", "InsertLeave", "TextChanged" }, {
                group = "CodeLens",
                callback = vim.lsp.codelens.refresh,
              })
          end

          -- formatting
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end

          -- inlay hints
          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint(bufnr, true)
          end

          -- lsp signature
          require("lsp_signature").on_attach({
            bind = true,
            hint_enable = false
          })
        end,
      })

      -- configure diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
      for name, icon in pairs(diagnostic_icons) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = "", numhl = name })
      end

      -- setup servers
      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          setup(server)
        end
      end
    end,
  },

  -- inject other software into lsp
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json",
          "Makefile", ".git"),
        sources = {
          -- prose
          nls.builtins.code_actions.proselint.with({
            filetypes = { "markdown", "tex", "norg" }
          }),
          nls.builtins.diagnostics.proselint.with({
            filetypes = { "markdown", "tex", "norg" }
          }),

          -- fish
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,

          -- bash
          nls.builtins.formatting.shellharden,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.shellcheck,

          -- make
          nls.builtins.diagnostics.checkmake,

          -- tex
          nls.builtins.diagnostics.chktex,

          -- c
          nls.builtins.diagnostics.cppcheck,

          -- general
          nls.builtins.formatting.trim_newlines,
          nls.builtins.formatting.trim_whitespace,
        },
      }
    end,
  },

  -- status indicator
  {
    "j-hui/fidget.nvim",
    config = true,
  },
}

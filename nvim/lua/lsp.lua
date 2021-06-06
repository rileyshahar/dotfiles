local nvim_lsp = require("lspconfig")

-- modified from https://github.com/neovim/nvim-lspconfig
local on_attach = function(client, bufnr)
    require "lsp_signature".on_attach()

    local opts = {noremap = true, silent = false}
    local function lsp_map(lhs, rhs, mode)
        mode = mode or "n"
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, "<cmd>lua " .. rhs .. "<cr>", opts)
    end

    lsp_map("ga", "vim.lsp.buf.code_action()")
    lsp_map("ga", "vim.lsp.buf.range_code_action()", "v")
    lsp_map("gD", "vim.lsp.buf.declaration()")
    lsp_map("gd", "vim.lsp.buf.definition()")
    lsp_map("K", "vim.lsp.buf.hover()")
    lsp_map("gi", "vim.lsp.buf.implementation()")
    lsp_map("<leader>k", "vim.lsp.buf.signature_help()")
    lsp_map("gt", "vim.lsp.buf.type_definition()")
    lsp_map("gw", "vim.lsp.buf.workspace_symbol()") -- this doesn't work with telescope for some reason

    lsp_map("<leader>d", "vim.lsp.diagnostic.show_line_diagnostics()")
    lsp_map("[d", "vim.lsp.diagnostic.goto_prev({ wrap = true })")
    lsp_map("]d", "vim.lsp.diagnostic.goto_next({ wrap = true })")
    lsp_map("<leader>q", "vim.lsp.diagnostic.set_loclist()")

    lsp_map("g0", 'require("telescope.builtin").lsp_document_symbols()')
    lsp_map("gr", 'require("telescope.builtin").lsp_references()')

    -- rust-anayzer
    -- todo: make this only a thing for rust
    lsp_map("<leader>t", 'require("lsp_extensions").inlay_hints()')

    -- rename if we have the capability
    -- todo: make sure this is the right name
    if client.resolved_capabilities.rename then
        lsp_map("<leader>rn", "vim.lsp.buf.rename()")
    end

    -- bind formatting if we have the capability
    if client.resolved_capabilities.document_formatting then
        vim.cmd [[augroup Format]]
        vim.cmd [[autocmd! * <buffer>]]
        vim.cmd [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
        vim.cmd [[augroup END]]
    end
end

-- generic settings
nvim_lsp.util.default_config =
    vim.tbl_extend(
    "force",
    nvim_lsp.util.default_config,
    {
        handlers = {
            ["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    -- disable virtual text
                    virtual_text = false
                }
            )
        },
        on_attach = on_attach
    }
)

fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

-- specific language servers
nvim_lsp.pyls.setup {}
nvim_lsp.clangd.setup {}
nvim_lsp.texlab.setup {
    settings = {
        latex = {
            lint = {
                onSave = true
            }
        }
    }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require "lspconfig".html.setup {
    capabilities = capabilities
}

nvim_lsp.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                overrideCommand = {
                    "cargo",
                    "clippy",
                    "--tests",
                    "--message-format=json",
                    "--",
                    "-W",
                    "clippy::nursery",
                    "-W",
                    "clippy::pedantic",
                    "--verbose"
                }
            }
        }
    }
}

local luafmt = require "efm/luafmt"
local prettier = require "efm/prettier"
local remove_whitespace = require "efm/remove-whitespace"
-- https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/lsp.lua
nvim_lsp.efm.setup {
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            -- todo: luacheck
            lua = {luafmt},
            yaml = {prettier},
            json = {prettier},
            html = {prettier},
            scss = {prettier},
            css = {prettier},
            markdown = {prettier},
            ["="] = {remove_whitespace}
        }
    }
}

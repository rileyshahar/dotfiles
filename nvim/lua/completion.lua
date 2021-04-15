paq "hrsh7th/nvim-compe"

vim.o.completeopt = "menuone,noselect"

require "compe".setup {
    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        spell = true
    }
}

require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = {}, -- List of parsers to ignore installing
    highlight = {
        enable = true,
        disable = {} -- list of language that will be disabled
    },
}

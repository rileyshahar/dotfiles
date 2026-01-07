-- keybinds
map("<leader>pi", "<cmd>Lazy install<cr>", "install")
map("<leader>pu", "<cmd>Lazy update<cr>", "update")
map("<leader>ps", "<cmd>Lazy sync<cr>", "sync")
map("<leader>pc", "<cmd>Lazy clean<cr>", "clean")

return {
  -- prereqs
  "nvim-lua/plenary.nvim",
  "tpope/vim-repeat", -- repeat plugin commands
}

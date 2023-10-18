-- vim.bo.makeprg = "pandoc -d default % -f markdown -o /tmp/%<.pdf"

vim.bo.shiftwidth = 2
map("<localleader>v", "<cmd>!open /tmp/%<.pdf<cr><cr>")

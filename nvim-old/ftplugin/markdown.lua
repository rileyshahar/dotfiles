-- from https://github.com/kylechui/nvim-surround/discussions/53
-- automatically insert markdown links
-- TODO: there's a buffer_setup that we really want here, but just isn't working for some reason

vim.bo.makeprg = "pandoc -d default % -o /tmp/%<.pdf"
vim.wo.linebreak = true
vim.bo.textwidth = 80

vim.o.textwidth = 80

-- compile to a pdf using pandoc
vim.bo.makeprg = "norg2pdf % /tmp/%<.pdf"

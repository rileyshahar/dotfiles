
-- useful aliases
cmd = vim.cmd
fn = vim.fn
g = vim.g

-- install paq
cmd 'packadd paq-nvim'              -- Load package
paq = require'paq-nvim'.paq             -- Import module and bind `paq` function
paq{'savq/paq-nvim', opt=true}          -- Let Paq manage itself

-- shell out to modules
require('appearance.lua')

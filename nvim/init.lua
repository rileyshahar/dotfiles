-- useful aliases
cmd = vim.cmd
fn = vim.fn
g = vim.g

-- map function
function map(lhs, rhs, mode, opts)
  mode = mode or "n"
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function map_lua(lhs, rhs, mode, opts)
  map(lhs, "<cmd>lua "..rhs.."<cr>", mode, opts)
end

-- set basics
g.mapleader = ","

-- install paq
cmd 'packadd paq-nvim'                  -- Load package
paq = require'paq-nvim'.paq             -- Import module and bind `paq` function
paq{'savq/paq-nvim', opt=true}          -- Let Paq manage itself

-- common dependencies
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'

-- shell out to modules
require('appearance.lua')
require('buffers.lua')
require('git.lua')
require('misc.lua')
require('telescope.lua')

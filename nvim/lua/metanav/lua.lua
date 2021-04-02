-- buffer tabbar
paq 'romgrk/barbar.nvim'
-- todo: figure out config in lua
cmd 'let g:bufferline = {}'
cmd 'let g:bufferline.icons = v:false'

-- MAPPINGS
-- change buffer
map('H', '<cmd>BufferPrevious<cr>')
map('L', '<cmd>BufferNext<cr>') 

-- reorder bufer
-- todo: improve key choice
map('<a-h>', '<cmd>BufferMovePrevious<cr>')
map('<a-l>', '<cmd>BufferMoveNext<cr>')

-- close buffer
map('X', '<cmd>BufferClose<cr>')

-- buffer select
map('<c-f>', '<cmd>BufferPick<cr>')

-- autosort
-- todo: improve key choice
map('<leader>bd', '<cmd>BufferOrderByDirectory<cr>')
map('<leader>bl', '<cmd>BufferOrderByLanguage<cr>')


-- tmux navigation integratoin
paq 'christoomey/vim-tmux-navigator'

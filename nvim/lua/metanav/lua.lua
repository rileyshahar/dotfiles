-- buffer tabbar
paq 'romgrk/barbar.nvim'
-- todo: figure out config in lua
cmd 'let g:bufferline = {}'
cmd 'let g:bufferline.icons = v:false'

-- MAPPINGS
-- change buffer
map('n', 'H', '<cmd>BufferPrevious<cr>')
map('n', 'L', '<cmd>BufferNext<cr>') 

-- reorder bufer
-- todo: improve key choice
map('n', '<a-h>', '<cmd>BufferMovePrevious<cr>')
map('n', '<a-l>', '<cmd>BufferMoveNext<cr>')

-- close buffer
map('n', 'X', '<cmd>BufferClose<cr>')

-- buffer select
map('n', '<c-f>', '<cmd>BufferPick<cr>')

-- autosort
-- todo: improve key choice
map('n', '<leader>bd', '<cmd>BufferOrderByDirectory<cr>')
map('n', '<leader>bl', '<cmd>BufferOrderByLanguage<cr>')


-- tmux navigation integratoin
paq 'christoomey/vim-tmux-navigator'

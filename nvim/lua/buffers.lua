-- icon dependency
-- todo: this doesn't work
paq 'kyazdani42/nvim-web-devicons' -- todo: is this significantly slower
require 'nvim-web-devicons'.setup { default = true }

-- install plugin
paq 'akinsho/nvim-bufferline.lua'

-- config
require 'bufferline'.setup{
  view = 'multiwindow',
}

-- change buffer
map("H", "<cmd>BufferLineCyclePrev<cr>")
map("L", "<cmd>BufferLineCycleNext<cr>") 

-- reorder bufer
-- todo: improve key choice
map("<a-h>", "<cmd>BufferLineMovePrev<cr>")
map("<a-l>", "<cmd>BufferLineMoveNext<cr>")

-- buffer select
map("<c-f>", "<cmd>BufferLinePick<cr>")

-- autosort
-- todo: improve key choice
map("<leader>bd", "<cmd>BufferLineSortByDirectory<cr>")
map("<leader>bl", "<cmd>BufferLineSortByLanguage<cr>")


-- todo: byebye.vim or equivalent
-- see https://github.com/neovim/neovim/issues/2434#issuecomment-565577489 for a possible soln

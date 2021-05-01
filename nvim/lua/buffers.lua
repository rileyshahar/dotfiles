-- config
require("buftabline").setup {}

-- change buffer
map("H", "<cmd>BufPrev<cr>")
map("L", "<cmd>BufNext<cr>")

-- todo: byebye.vim or equivalent
-- see https://github.com/neovim/neovim/issues/2434#issuecomment-565577489 for a possible soln

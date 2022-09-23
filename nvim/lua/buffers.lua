-- config
require("buftabline").setup({})

-- change buffer
map("H", "<cmd>BufPrev<cr>")
map("L", "<cmd>BufNext<cr>")

-- delete buffer
map("X", "<cmd>BufDel<cr>")

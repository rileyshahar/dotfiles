Map("jk", "<c-\\><c-n>", "exit insert mode", { "i", "t" }) -- exit insert mode
Map(";", ":", "command mode", { "n", "v" }) -- don't type shift

-- find
Map("<C-;>", LazyVim.pick("files"), "find files")

-- jerminal
Map("<C-CR>", "<cmd>vert term<cr>", "terminal in split", { "i", "n", "t", "v", "x" })
Map("<c-r>", function()
  -- TODO: whichkey registers
  local reg = vim.fn.nr2char(vim.fn.getchar())
  local text = vim.trim(vim.fn.getreg(reg))
  vim.api.nvim_chan_send(vim.o.channel, text)
end, "insert from register", "t")

-- splits
Map("<c-q>", "<cmd>q<cr>", "close split", { "i", "n", "t", "v", "x" })
Map("<c-h>", "<cmd>wincmd h<cr>", "move to left window", { "n", "t" })
Map("<c-j>", "<cmd>wincmd j<cr>", "move to right window", { "n", "t" })
Map("<c-k>", "<cmd>wincmd k<cr>", "move to above window", { "n", "t" })
Map("<c-l>", "<cmd>wincmd l<cr>", "move to below window", { "n", "t" })

-- search
Map("<leader>l", "<cmd>nohlsearch<cr><c-l><cmd>lua vim.lsp.buf.clear_references()<cr>", "clear highlights")

if vim.g.neovide then
  -- Keymaps
  Map("<C-+>", function()
    ResizeGuiFont(1)
  end, "increase font size", { "n", "i", "t" })

  Map("<C-->", function()
    ResizeGuiFont(-1)
  end, "decrease font size", { "n", "i", "t" })

  Map("<C-=>", function()
    ResetGuiFont()
  end, "reset font size", { "n", "i", "t" })

  Map(Leaders.ui .. "c", function()
    ToggleLight()
  end, "toggle light/dark mode")
end

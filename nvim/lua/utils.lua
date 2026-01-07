function Map(lhs, rhs, desc, mode, opts)
  mode = mode or "n"

  local options = { noremap = true, desc = desc }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

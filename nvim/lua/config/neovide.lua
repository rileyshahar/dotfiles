if not vim.g.neovide then
  return
end

vim.g.neovide_frame = "none"
vim.g.neovide_opacity = 1.0
vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_size = 0.0
-- vim.o.guifont = "JetBrainsMono Nerd Font:h10" -- text below applies for VimScript
vim.g.neovide_scroll_animation_length = 0.0

local colorscheme = "night"

vim.g.gui_font_default_size = 11
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "JetBrainsMono Nerd Font"

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

ToggleLight = function()
  if colorscheme == "day" then
    colorscheme = "night"
    vim.cmd("colorscheme tokyonight-night")
  else
    colorscheme = "day"
    vim.cmd("colorscheme tokyonight-day")
  end
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()

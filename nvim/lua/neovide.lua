vim.g.neovide_transparency = 0.8
vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_size = 0.0
-- vim.o.guifont = "JetBrainsMono Nerd Font:h10" -- text below applies for VimScript
vim.g.neovide_scroll_animation_length = 0.0

vim.g.gui_font_default_size = 10
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
	if vim.g.neovide_transparency == 1.0 then
		vim.cmd("colorscheme tokyonight-night")
		vim.g.neovide_transparency = 0.8
	else
		vim.cmd("colorscheme tokyonight-day")
		vim.g.neovide_transparency = 1.0
	end
	vim.g.gui_font_size = vim.g.gui_font_default_size
	RefreshGuiFont()
end
-- Call function on startup to set default value
ResetGuiFont()

-- Keymaps
map("<C-+>", function()
	ResizeGuiFont(1)
end, "increase font size", { "n", "i", "t" })

map("<C-->", function()
	ResizeGuiFont(-1)
end, "decrease font size", { "n", "i", "t" })

map("<C-=>", function()
	ResetGuiFont()
end, "reset font size", { "n", "i", "t" })

map(leaders.ui .. "c", function()
	ToggleLight()
end, "toggle light/dark mode")

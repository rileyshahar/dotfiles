-- package
-- todo: this package takes a long time to load, maybe not worth it
paq 'nvim-telescope/telescope.nvim'

-- keybinds
map_lua("<leader>ff", "require('telescope.builtin').find_files()")
map_lua("<leader>fg", "require('telescope.builtin').live_grep()")
map_lua("<leader>fs", "require('telescope.builtin').grep_string()")
map_lua("<leader>fb", "require('telescope.builtin').buffers()")
map_lua("<leader>fh", "require('telescope.builtin').help_tags()")
map_lua("<leader>fr", "require('telescope.builtin').registers()")
map_lua("<leader>fc", "require('telescope.builtin').git_bcommits()")

-- todo: github cli addon

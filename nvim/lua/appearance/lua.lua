-- line numbers
cmd 'set number relativenumber'

-- prettier colors
cmd 'set termguicolors'

-- colorscheme
paq 'ghifarit53/tokyonight-vim'
cmd 'colorscheme tokyonight'
cmd 'highlight Comment guifg=#f6bdff'        -- better comment color

-- syntax highlighting
cmd 'syntax enable'

-- tmux background highlighting
cmd 'highlight Normal guibg=None'
cmd 'highlight EndOfBuffer guibg=None'
cmd 'highlight NormalNC guibg=#232433'
cmd 'highlight EndOfBufferNC guibg=#232433'

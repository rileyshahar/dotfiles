-- setup paq
cmd "packadd paq-nvim" -- Load package
paq = require "paq-nvim".paq -- Import module and bind `paq` function
paq {"savq/paq-nvim", opt = true} -- Let Paq manage itself

-- prereqs
paq "nvim-lua/popup.nvim"
paq "nvim-lua/plenary.nvim"

-- misc
paq "b3nj5m1n/kommentary" -- comment plugin
paq "christoomey/vim-tmux-navigator" -- tmux split navigation
paq "tpope/vim-repeat" -- repeat plugin commands
paq "jiangmiao/auto-pairs" -- autoclose brackets
paq "tpope/vim-surround" -- quote manipulation
paq "tommcdo/vim-exchange" -- exchange text objects
paq "simnalamburt/vim-mundo" -- undo tree viewer
paq "machakann/vim-highlightedyank" -- highlight yanked text
paq "christoomey/vim-sort-motion" -- sort easily
paq "unblevable/quick-scope" -- easier inline navigation

-- completion
paq "hrsh7th/nvim-compe"

-- buffers
paq "jose-elias-alvarez/buftabline.nvim"

-- snippets
paq "hrsh7th/vim-vsnip"
paq "rafamadriz/friendly-snippets"

-- lsp
paq "neovim/nvim-lspconfig"
paq "nvim-lua/lsp_extensions.nvim"
paq "ray-x/lsp_signature.nvim"

-- appearance
paq "ghifarit53/tokyonight-vim"

-- git
paq "lewis6991/gitsigns.nvim"

-- telescope
paq "nvim-telescope/telescope.nvim"

-- tex
paq "lervag/vimtex"

-- rust
paq "mhinz/vim-crates"
paq "mattn/webapi-vim" -- dependency
paq "rust-lang/rust.vim"

-- toml
paq "cespare/vim-toml"

-- markdown
paq "plasticboy/vim-markdown"

-- fish
paq "dag/vim-fish"

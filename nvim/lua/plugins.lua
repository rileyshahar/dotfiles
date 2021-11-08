-- setup paq
cmd "packadd paq-nvim" -- Load package
paq = require "paq-nvim".paq -- Import module and bind `paq` function
paq {"savq/paq-nvim", opt = true} -- Let Paq manage itself

-- prereqs
paq "nvim-lua/popup.nvim"
paq "nvim-lua/plenary.nvim"

-- misc
paq "b3nj5m1n/kommentary" -- comment plugin
paq "knubie/vim-kitty-navigator" -- tmux split navigation
paq "tpope/vim-repeat" -- repeat plugin commands
paq "jiangmiao/auto-pairs" -- autoclose brackets
paq "tpope/vim-surround" -- quote manipulation
paq "tommcdo/vim-exchange" -- exchange text objects
paq "simnalamburt/vim-mundo" -- undo tree viewer
paq "machakann/vim-highlightedyank" -- highlight yanked text
paq "christoomey/vim-sort-motion" -- sort easily

-- writing
paq "junegunn/goyo.vim" -- distraction-free writing

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
paq "ap/vim-css-color"

-- treesitter
paq {
    "nvim-treesitter/nvim-treesitter",
    run = function()
        cmd "TSUpdate"
    end
}

-- git
paq "lewis6991/gitsigns.nvim"

-- telescope
paq "nvim-telescope/telescope.nvim"

-- tex
paq "lervag/vimtex"

-- python
paq {"heavenshell/vim-pydocstring", run = "make install"}

-- rust
paq "mhinz/vim-crates"
paq "mattn/webapi-vim" -- dependency
paq "rust-lang/rust.vim"

-- toml
paq "cespare/vim-toml"

-- markdown
--[[ paq "vim-pandoc/vim-pandoc"
paq "vim-pandoc/vim-pandoc-syntax" ]]
paq "plasticboy/vim-markdown"

-- fish
paq "dag/vim-fish"

-- pest/peg
paq "pest-parser/pest.vim"

-- copilot
-- paq "github/copilot.vim"

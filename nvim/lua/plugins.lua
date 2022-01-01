-- setup paq
-- cmd "packadd packer.nvim" -- Load package
require "packer".startup(
    function()
        use "wbthomason/packer.nvim"

        -- prereqs
        use "nvim-lua/popup.nvim"
        use "nvim-lua/plenary.nvim"

        -- misc
        use "b3nj5m1n/kommentary" -- comment plugin
        use "knubie/vim-kitty-navigator" -- tmux split navigation
        use "tpope/vim-repeat" -- repeat plugin commands
        use "jiangmiao/auto-pairs" -- autoclose brackets
        use "tpope/vim-surround" -- quote manipulation
        use "tommcdo/vim-exchange" -- exchange text objects
        use "simnalamburt/vim-mundo" -- undo tree viewer
        use "machakann/vim-highlightedyank" -- highlight yanked text
        use "christoomey/vim-sort-motion" -- sort easily

        -- writing
        use "junegunn/goyo.vim" -- distraction-free writing

        -- completion
        use "hrsh7th/nvim-compe"

        -- buffers
        use "jose-elias-alvarez/buftabline.nvim"

        -- snippets
        use "hrsh7th/vim-vsnip"
        use "rafamadriz/friendly-snippets"

        -- lsp
        use "neovim/nvim-lspconfig"
        use "nvim-lua/lsp_extensions.nvim"
        use "ray-x/lsp_signature.nvim"

        -- appearance
        use "ghifarit53/tokyonight-vim"
        use "ap/vim-css-color"

        -- treesitter
        use {
            "nvim-treesitter/nvim-treesitter",
            run = function()
                cmd "TSUpdate"
            end
        }

        -- git
        use "lewis6991/gitsigns.nvim"

        -- telescope
        use "nvim-telescope/telescope.nvim"

        -- tex
        use "lervag/vimtex"

        -- python
        use {"heavenshell/vim-pydocstring", run = "make install"}

        -- rust
        use "mhinz/vim-crates"
        use "mattn/webapi-vim" -- dependency
        use "rust-lang/rust.vim"

        -- toml
        use "cespare/vim-toml"

        -- markdown
        --[[ paq "vim-pandoc/vim-pandoc"
	paq "vim-pandoc/vim-pandoc-syntax" ]]
        use "plasticboy/vim-markdown"

        -- fish
        use "dag/vim-fish"

        -- pest/peg
        use "pest-parser/pest.vim"

        -- just
        use "NoahTheDuke/vim-just"
    end
)

-- copilot
-- paq "github/copilot.vim"

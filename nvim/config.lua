maps = {}
function map(lhs, rhs, desc, mode, opts)
  table.insert(maps, {
    lhs = lhs,
    rhs = rhs,
    desc = desc,
    mode = mode,
    opts = opts,
  })
end

function alias(clos)
  local function unwrap(clos)
    if type(clos) == "string" then
      return function() return require(clos) end
    else
      return clos
    end
  end

  local clos = unwrap(clos)

  local mt = {
    __index = function(table, key)
      -- handle indexing into a lazy module
      return alias(function() return clos()[key] end)
    end
  }

  local ret = {
    _alias = true,
    clos = clos,
  }
  setmetatable(ret, mt)
  return ret
end
vim.g.mapleader = ","
vim.g.maplocalleader = ",,"
map("<space>", "<nop>", "n")
map("<space>", "<nop>", "v")
local lazypath = vim.fn.stdpath("data") .. "/test/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  vim.notify("installed lazy", "warning")
end
vim.opt.rtp:prepend(lazypath)
map("<leader>pi", "<cmd>Lazy install<cr>", "install plugins")
map("<leader>pu", "<cmd>Lazy update<cr>", "update plugins")
map("<leader>ps", "<cmd>Lazy sync<cr>", "sync plugins")
map("<leader>pc", "<cmd>Lazy clean<cr>", "clean plugins")
plugins = {}
function install(plugin) table.insert(plugins, plugin) end
install(
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  }
)
vim.o.termguicolors = true
vim.cmd("colorscheme theme")
vim.o.fillchars = "vert: ,vertleft: ,vertright: ,verthoriz: ,horiz: ,horizup: ,horizdown: "
vim.o.conceallevel = 2
vim.o.concealcursor = "n"
vim.wo.signcolumn = "yes"
vim.o.cmdheight = 1
install("lewis6991/gitsigns.nvim")
local gitsigns = alias("gitsigns")
map("]g", gitsigns.next_hunk, "next hunk")
map("[g", gitsigns.prev_hunk, "previous hunk")
map("<leader>gs", gitsigns.stage_hunk, "stage the current hunk")
map("<leader>gr", gitsigns.reset_hunk, "reset the current hunk")
map("<leader>gS", gitsigns.stage_buffer, "stage the current buffer")
map("<leader>gR", gitsigns.reset_buffer, "reset the current buffer")
map("<leader>gu", gitsigns.undo_stage_hunk, "unstage the current hunk")
map("<leader>gp", gitsigns.preview_hunk, "view changes in the current hunk")
map("<leader>gb", function()
  gitsigns.blame_line({ full = true })
end, "show blame for the current line " )
map("<leader>gd", gitsigns.diffthis, "open diff in buffer")
-- TODO: get telescope
-- map("C", require("telescope.builtin").git_commits, "search commits to this repo")
-- map("c", require("telescope.builtin").git_bcommits, "search commits to this buffer")
install({
  "hrsh7th/nvim-cmp",
  dependencies = {
    { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "petertriho/cmp-git",
    "f3fora/cmp-spell",
    "hrsh7th/cmp-path",
    "ray-x/cmp-treesitter",
    "lukas-reineke/cmp-under-comparator",
  },
})

local cmp = alias("cmp")
local ls = alias("luasnip")
local compare = cmp.config.compare
require("lazy").setup(plugins, {
  -- use a different root for now
  root = vim.fn.stdpath("data") .. "/test"
})
local function do_map(lhs, rhs, desc, mode, opts)
  mode = mode or "n"
  local options = { noremap = true }

  if opts then
    options = vim.tbl_extend("force", options, opts)
  end

  if type(rhs) == "table" and rhs._alias ~= nil then
    -- hopefully now we can evaluate the closure
    rhs = rhs.clos()
  end

  options = vim.tbl_extend("force", options, { desc = desc })

  vim.keymap.set(mode, lhs, rhs, options)
end

for _, m in pairs(maps) do
  -- print(vim.inspect(m))
  do_map(m.lhs, m.rhs, m.desc, m.mode, m.opts)
end
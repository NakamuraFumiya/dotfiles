-- https://zenn.dev/takuya/articles/4472285edbc132
-- https://zenn.dev/ymgn____/scraps/13b28214ebd19f
-- https://zenn.dev/acro5piano/articles/c764669236eb0f
-- https://qiita.com/delphinus/items/8160d884d415d7425fcc
-- https://zenn.dev/malan/scraps/c258e77a616e98
-- https://zenn.dev/hisasann/articles/neovim-settings-to-lua
vim.cmd.packadd "packer.nvim"

require("packer").startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- LSP
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  -- Syntax Highlight
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Complement
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }
  -- Fuzzy Finder
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  -- Filer
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup {}
    end
  }
  -- Color Scheme
  use 'Mofiqul/dracula.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use 'folke/tokyonight.nvim'
  -- Status Line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  -- Buffer Line
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  -- Golang
  use 'mattn/vim-goimports'
  -- Golang(go.nvim)
  -- use 'ray-x/go.nvim'
  -- use 'ray-x/guihua.lua' -- recommended if need floating window support
end)

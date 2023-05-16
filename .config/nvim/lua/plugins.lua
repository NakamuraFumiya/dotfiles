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
  -- Terminal
  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}
  -- Comment
  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }
  -- QuickFix
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
  -- Neotest
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go"
    },
    config = function()
      local ok, neotest = pcall(require, 'neotest')
      local ok_go, neotest_go = pcall(require, 'neotest-go')

      if ok and ok_go then 

        -- unit
        vim.keymap.set('n', '<Leader>tn', function() 
          neotest.run.run()
          neotest.output_panel.open()
          neotest.summary.open()
        end, { noremap = true, silent = true })

        -- file
        vim.keymap.set('n', '<Leader>tf', function()
          neotest.run.run(vim.fn.expand("%"))
          neotest.output_panel.open()
          neotest.summary.open()
        end, { noremap = true, silent = true })

        -- package
        vim.keymap.set('n', '<Leader>tp', function()
          neotest.run.run(vim.fn.expand("%:h"))
          neotest.output_panel.open()
          neotest.summary.open()
        end, { noremap = true, silent = true })

        -- close
        vim.keymap.set('n', '<Leader>tc', function()
          neotest.output_panel.close()
          neotest.summary.close()
        end, { noremap = true, silent = true })

        -- quit test
        vim.keymap.set('n', '<Leader>tq', function()
          neotest.run.stop()
        end, { noremap = true, silent = true })

        -- get neotest namespace (api call creates or returns namespace)
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
          virtual_text = {
            format = function(diagnostic)
              local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
              return message
            end,
          },
        }, neotest_ns)
        neotest.setup({
          -- your neotest config here
          adapters = {
            neotest_go({
              args = { "-count=1" }
            }),
          },
        })
      end
    end
  }
  -- GoTest
  use {
    'buoto/gotests-vim',
    config = function()
      vim.g.gotests_template_dir = vim.fs.normalize('~/.config/gotests')
    end
  }
  -- Golang
  -- use 'mattn/vim-goimports'
end)

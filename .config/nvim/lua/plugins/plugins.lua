return {
  -- LSP
  {
   { "mason-org/mason.nvim", version = "^1.0.0" },
   { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
    -- "williamboman/mason.nvim",
    -- "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  -- LSP progress
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  -- Syntax Highlight
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate'
  },
  -- Complement
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      require("configs/comp")
    end
  },
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    config = function() 
      require("nvim-autopairs").setup {}
    end
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,          -- タグの自動閉じ
          enable_rename = true,         -- ペアタグ名の自動リネーム
          enable_close_on_slash = false -- </ での自動閉じ無効
        },
      })
    end
  },
  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require("configs/finder")
    end
  },
  -- Filer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("configs/tree")
    end
  },
  -- Color Scheme
  'Mofiqul/dracula.nvim',
  'folke/tokyonight.nvim',
  {
    "catppuccin/nvim",
    config = function()
      require("configs/color")
    end
  },
  -- Status Line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require("configs/lualine")
    end
  },
  -- Buffer Line
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
  },
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({})
    end
  },
  -- Comment
  {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  },
  -- QuickFix
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        auto_open = false,
      }
    end
  },
  -- Code Action
  {
    'kosayoda/nvim-lightbulb',
    dependencies = 'antoinemadec/FixCursorHold.nvim',
    config = function()
      require('nvim-lightbulb').setup({autocmd = {enabled = true}})
      require("configs/lightbulb")
    end
  },
  -- LSP saga
  {
    'nvimdev/lspsaga.nvim',
    lazy = true,
    event = "LspAttach",
    config = function()
      require("configs/lspsaga")
    end
  },
  -- Neotest
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "nvim-neotest/nvim-nio"
    },
    -- tag = "v5.0.1",
    config = function()
      require("configs/neotest")
    end
  },
  -- GoTest
  -- https://github.com/buoto/gotests-vim
  {
    'buoto/gotests-vim',
    config = function()
      vim.g.gotests_template_dir = vim.fs.normalize('~/.config/gotests')
    end
  },
  -- Golang
  {
    'mattn/vim-goimports',
  },
  -- Debug Adapter Protocol(Go)
  {
      "leoluz/nvim-dap-go",
      ft = "go",
      dependencies = {
          "rcarriga/nvim-dap-ui",
          "theHamsta/nvim-dap-virtual-text",
          "mfussenegger/nvim-dap",
      },
      config = function()
        require("configs/dap")
      end
  },
  -- Git Link
  {
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require"gitlinker".setup()
    end
  },
  -- VS Code's Git Lens
  {
    'APZelos/blamer.nvim',
    config = function()
      require("configs/blamer")
    end
  },
  -- Git
  {
    'tpope/vim-fugitive',
  },
  -- Slim
  {
    'slim-template/vim-slim',
  },
  -- Copilot
  {
    "github/copilot.vim",
    lazy=false,
    config = function()
      require("configs/copilot")
    end
  },
  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
    },
  },
}

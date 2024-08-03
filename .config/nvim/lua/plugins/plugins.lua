return {
  -- LSP
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
    keys = {
      { "gh", "<cmd>Lspsaga finder<CR>",          silent = true },
      { "gi", "<cmd>Lspsaga finder imp<CR>",      silent = true },
      { "gr", "<cmd>Lspsaga finder ref<CR>",      silent = true },
      { "gd", "<cmd>Lspsaga goto_definition<CR>", silent = true },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", silent = true },
      {
        "gv",
        function()
          vim.cmd [[vsp]]
          vim.cmd [[Lspsaga goto_definition]]
        end,
        silent = true,
      },
      {
        "gs",
        function()
          vim.cmd [[sp]]
          vim.cmd [[Lspsaga goto_definition]]
        end,
        silent = true,
      },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", silent = true },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", silent = true },
      {
        "[e",
        function()
          require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        silent = true,
      },
      {
        "]e",
        function()
          require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        silent = true,
      },
      { "<leader>e",  "<cmd>Lspsaga show_cursor_diagnostics<CR>", silent = true },
      { "<leader>o",  "<cmd>Lspsaga outline<CR>",                 silent = true },
      { "<leader>rn", "<cmd>Lspsaga rename<CR>",                  silent = true },
      { "K",          "<cmd>Lspsaga hover_doc<CR>",               silent = true },
    },
    config = function()
      require("lspsaga").setup({lightbulb={enable = false}})
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
      local ok, neotest = pcall(require, 'neotest')
      if not ok then
        print("Failed to load neotest: " .. neotest) -- デバッグ用
      end

      local ok_go, neotest_go = pcall(require, 'neotest-go')
      if not ok_go then
        print("Failed to load neotest-go: " .. neotest_go) -- デバッグ用
      end

      if ok and ok_go then 

        -- unit
        vim.keymap.set('n', '<Leader>tn', function() 
          neotest.run.run()
          neotest.output_panel.open()
          neotest.summary.open()
        end, { noremap = true, silent = true })

        -- debug
        vim.keymap.set('n', '<Leader>td', function() 
          neotest.run.run({strategy = "dap"})
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
  },
  -- GoTest
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
  -- {
  --   "github/copilot.vim",
  --   lazy=false,
  -- },
}

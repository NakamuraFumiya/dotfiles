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
  {'hrsh7th/nvim-cmp',
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
    config = function() require("nvim-autopairs").setup {} end
  },
  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
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
      require("nvim-tree").setup {
        view = {
          width = 50,
        },
      }
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
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 
            {
              'diagnostics',
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },

            },
          },
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  -- Buffer Line
  {'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
  -- Terminal
  {"akinsho/toggleterm.nvim", config = function()
    require("toggleterm").setup({})
  end},
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
        -- your configuration comes here
        -- or leave it empty to the default settings
        -- refer to the configuration section below
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
  },
  -- GoTest
  {
    'buoto/gotests-vim',
    config = function()
      vim.g.gotests_template_dir = vim.fs.normalize('~/.config/gotests')
    end
  },
  -- Golang
  'mattn/vim-goimports',
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
  },
}

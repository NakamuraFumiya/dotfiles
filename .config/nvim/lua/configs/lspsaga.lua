local lspsaga = require('lspsaga')

lspsaga.setup({ lightbulb = { enable = false } })

local keymaps = {
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
}

for _, map in pairs(keymaps) do
  vim.keymap.set('n', map[1], map[2], { silent = map.silent })
end


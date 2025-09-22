-- https://zenn.dev/fukakusa_kadoma/articles/99e8f3ab855a56
local set = vim.keymap.set
  set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
  set('n', 'to', "<cmd>Telescope oldfiles<CR>")

local on_attach = function(client, bufnr)
end

-- 補完プラグインであるcmp_nvim_lspをLSPと連携させています（後述）
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- (2022/11/1追記):cmp-nvim-lspに破壊的変更が加えられ、
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(
--  vim.lsp.protocol.make_client_capabilities()
-- )
-- ⇑上記のupdate_capabilities(...)の関数は非推奨となり、代わりにdefault_capabilities()関数が採用されました。日本語情報が少ないため、念の為併記してメモしておきます。

-- この一連の記述で、mason.nvimでインストールしたLanguage Serverが自動的に個別にセットアップされ、利用可能になります
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
  -- function (server_name) -- default handler (optional)
  --   vim.lsp.config(server_name, {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --   })
  --   -- require("lspconfig")[server_name].setup {
  --   --   on_attach = on_attach, --keyバインドなどの設定を登録
  --   --   capabilities = capabilities, --cmpを連携
  --   -- }
  -- end,
}


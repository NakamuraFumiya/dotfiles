-- GitHub Copilotのキーマッピング
-- Copilot有効化を <leader>ce に割り当て
vim.keymap.set('n', '<leader>ce', ':Copilot enable<CR>', { noremap = true, silent = true })

-- Copilot無効化を <leader>cd に割り当て
vim.keymap.set('n', '<leader>cd', ':Copilot disable<CR>', { noremap = true, silent = true })

-- 認証/セットアップを <leader>cs に割り当て
vim.keymap.set('n', '<leader>cs', ':Copilot setup<CR>', { noremap = true, silent = true })

-- サインアウトを <leader>co に割り当て
vim.keymap.set('n', '<leader>co', ':Copilot signout<CR>', { noremap = true, silent = true })

-- ステータス確認を <leader>ct に割り当て
vim.keymap.set('n', '<leader>ct', ':Copilot status<CR>', { noremap = true, silent = true })

-- パネルを <leader>cp に割り当て
vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>', { noremap = true, silent = true })


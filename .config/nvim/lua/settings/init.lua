vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.guifont = 'JetBrainsMono Nerd Font:h12'
-- vim.o.guifont = 'HackGen35 Console NFJ'
-- vim.o.guicursor = 'n-v-c:block,i:ver1'
-- マルチコードに対応
vim.o.encoding = 'utf-8'
vim.o.fileencoding = 'utf-8'
vim.o.fileencodings = 'utf-8'

--vim.cmd('set mouse=')
vim.o.mouse = ''
-- nerdtree上で入力を受け付けるように変更
vim.o.modifiable = true
vim.o.write = true
-- 行番号を表示
vim.o.number = true
-- 行を強調表示
vim.o.cursorline = true
-- TABキーを押した際にタブ文字の代わりにスペースを入れる
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- mute beep sound
vim.o.visualbell = true
-- 検索結果をハイライト
vim.o.hlsearch = true
-- インクリメントサーチ有効
vim.o.incsearch = true
-- 折り畳みが嫌いなので無効化
vim.o.foldenable = false
-- backspaceが効かないのへ対応
vim.o.backspace = 'indent,eol,start'

-- ファイルを右側で開く
vim.o.splitright = true

-- 検索時に小文字入力では大小区別しない
-- 大文字入力時には区別する
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
-- ビープ音を消す
vim.o.visualbell = false
-- yankをクリップボードに
vim.o.clipboard = 'unnamed'

-- キーシーケンスによる待ち時間を短縮してリピート中断を防ぐ
vim.o.timeout = true
vim.o.ttimeout = true
vim.o.timeoutlen = 300
vim.o.ttimeoutlen = 10

vim.keymap.set('v', 'x', [["_x]], { noremap = true})
vim.keymap.set('n', 'x', [["_x]], { noremap = true})

-- 背景透過設定
vim.o.termguicolors = true -- True color サポート
vim.o.background = 'dark'

-- 透過背景を有効にする関数
local function enable_transparency()
  -- 基本的な背景を透過
  vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight Folded guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE ctermbg=NONE
    highlight StatusLine guibg=NONE ctermbg=NONE
    highlight StatusLineNC guibg=NONE ctermbg=NONE
    highlight TabLine guibg=NONE ctermbg=NONE
    highlight TabLineFill guibg=NONE ctermbg=NONE
    highlight TabLineSel guibg=NONE ctermbg=NONE
  ]])
end

-- カラースキーム読み込み後に透過設定を適用
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = enable_transparency
})
-- 検索のハイライトを解除
vim.keymap.set('n', '<Esc><Esc>', [[:noh<CR>]], { noremap = true })

-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- leader keyをスペースキーに設定する
-- example: <leader>ceとキーマッピングした場合は、「スペース → c → e」と打つことでそのコマンドが実行される
vim.g.mapleader = ' '
vim.cmd('filetype on')
vim.cmd([[
  augroup my_common
  autocmd!
  augroup END
]])

-- 改行文字やスペースを可視化する
vim.opt.list = true
vim.opt.listchars = {
  tab = '│·',
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  eol = '↴',
  nbsp = '%'
}

vim.o.cmdheight = 0

vim.o.undofile = true
vim.o.undodir = vim.fn.expand('~/.vim/undodir')

-- ターミナルのinsertモードをescで抜け出せるようにする
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]],{noremap=true})
-- toggleterm上でCtrl-tを押すと閉じる設定
vim.api.nvim_create_autocmd({ 'TermEnter' }, {
  pattern = { 'term://*toggleterm#*' },
  command = 'tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>',
})
-- Ctrl-tを押すとtoggletermを開く設定
-- vim.keymap.set('n', '<C-t>', '<Cmd>exe v:count1 . "ToggleTerm size=30 direction=horizontal"<CR>',{noremap=true})
vim.keymap.set('n', '<C-t>', '<Cmd>exe v:count1 . "ToggleTerm direction=float"<CR>',{ noremap=true })

-- 特定のファイルタイプの場合、qでファイルを閉じられるようにする
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'toggleterm, NvimTree, help' },
  command = 'nnoremap <buffer><silent> q :q<CR>',
})

-- NvimTreeFindFile を <leader>f にマップ
vim.api.nvim_set_keymap('n', '<C-f>', ':NvimTreeFindFile<CR>', { noremap = true })

-- MySQLのデバッグログを出力する
-- vim.fn.setenv("MYSQL_DEBUG", "1")

-- コマンドラインで 'chat' と入力すると CopilotChat が実行されるように設定
-- ref: https://zenn.dev/kawarimidoll/books/6064bf6f193b51/viewer/90a5be#copilotc-nvim%2Fcopilotchat.nvim
vim.keymap.set('ca', 'cc', 'CopilotChat', { desc = 'Ask CopilotChat' })

-- フルパスをクリップボードにコピー
vim.keymap.set('n', '<leader>yf', function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)  -- システムクリップボード
  vim.fn.setreg('"', path)  -- デフォルトレジスタ
  print('Copied: ' .. path)
end, { desc = 'Copy full path' })

-- 相対パスをコピー
vim.keymap.set('n', '<leader>yr', function()
  local path = vim.fn.expand('%')
  vim.fn.setreg('+', path)
  vim.fn.setreg('"', path)
  print('Copied: ' .. path)
end, { desc = 'Copy relative path' })

-- 相対ディレクトリパスをコピー
vim.keymap.set('n', '<leader>yd', function()
  local dir_path = vim.fn.expand('%:h')
  vim.fn.setreg('+', dir_path)
  vim.fn.setreg('"', dir_path)
  print('Copied directory: ' .. dir_path)
end, { desc = 'Copy relative directory path' })


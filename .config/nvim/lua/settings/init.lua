vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.o.guifont = 'JetBrainsMono Nerd Font'
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
vim.o.t_vb = ''
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

vim.keymap.set('v', 'x', [["_x]], { noremap = true})
vim.keymap.set('n', 'x', [["_x]], { noremap = true})
-- 検索のハイライトを解除
vim.keymap.set('n', '<Esc><Esc>', [[:noh<CR>]], { noremap = true })

-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

vim.g.mapleader = ' '
vim.cmd('filetype on')
vim.cmd([[
  augroup my_common
  autocmd!
  augroup END
]])

-- 改行文字やスペースを可視化する
-- https://zenn.dev/hiroms/scraps/588edcf2a031a1
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

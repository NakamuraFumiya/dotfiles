vim.api.nvim_create_user_command('NippoAppend', function(opts)
  if opts.args ~= "" then
    -- 新しいGoプログラムを使用
    local nippo_bin = vim.fn.expand("~/dotfiles/scripts/nippo-go/nippo")
    local cmd = string.format("'%s' '%s'", nippo_bin, opts.args)
    local result = os.execute(cmd)
    if result == 0 then
      print("日報に追記しました！")
    else
      print("日報の追記に失敗しました")
    end
  else
    print("内容を入力してください")
  end
end, { nargs = "*" })

-- Vimノーマルモードで <leader>na で新規追記プロンプト
vim.keymap.set("n", "<leader>na", function()
  local input = vim.fn.input("日報に追記: ")
  if input ~= "" then
    vim.cmd("NippoAppend " .. input)
  end
end, { noremap = true, silent = true })

-- 日報完成機能を読み込み
require('nippo.finalize')

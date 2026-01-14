vim.api.nvim_create_user_command('NippoAppend', function(opts)
  if opts.args ~= "" then
    -- 外部nippo_append.shを使い、引数を渡して実行
    local cmd = string.format("bash ~/dotfiles/scripts/nippo_append.sh '%s'", opts.args)
    os.execute(cmd)
    print("日報に追記しました！")
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

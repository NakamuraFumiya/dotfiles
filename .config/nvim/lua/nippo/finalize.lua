-- 日報完成用のCopilotChatコマンド
local M = {}

-- 現在の日付から日報ファイルのパスを取得
local function get_nippo_path()
  local date = os.date("%Y-%m-%d")
  return vim.fn.expand("~/dotfiles/nippos/nippo." .. date .. ".md")
end

-- 日報完成プロンプトを読み込み
local function get_finalize_prompt()
  local prompt_file = vim.fn.expand("~/dotfiles/scripts/nippo-go/NIPPO_FINALIZE_AI.md")
  local file = io.open(prompt_file, "r")
  if not file then
    vim.notify("プロンプトファイルが見つかりません: " .. prompt_file, vim.log.levels.ERROR)
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content
end

-- 日報ファイルを読み込み
local function get_nippo_content()
  local nippo_path = get_nippo_path()
  local file = io.open(nippo_path, "r")
  if not file then
    vim.notify("日報ファイルが見つかりません: " .. nippo_path, vim.log.levels.ERROR)
    return nil
  end
  local content = file:read("*a")
  file:close()
  return content
end

-- 日報完成コマンド
function M.finalize_nippo()
  local nippo_content = get_nippo_content()
  local prompt = get_finalize_prompt()
  
  if not nippo_content or not prompt then
    return
  end
  
  -- CopilotChatを開いて日報完成プロンプトを実行
  local full_prompt = prompt .. "\n\n## 分析対象の日報ファイル:\n```markdown\n" .. nippo_content .. "\n```\n\n上記の日報を分析して完成させてください。"
  
  -- CopilotChatを開く方法を修正
  vim.cmd("CopilotChat")
  
  -- 少し待ってからプロンプトを設定
  vim.defer_fn(function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.split(full_prompt, '\n')
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end, 100)
end

-- CopilotChatの結果を日報ファイルに適用する関数
function M.apply_copilot_result()
  local nippo_path = get_nippo_path()
  
  -- CopilotChatのバッファを探す
  local copilot_bufnr = nil
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(bufnr)
    if buf_name:match("copilot%-chat") or buf_name:match("CopilotChat") then
      copilot_bufnr = bufnr
      break
    end
  end
  
  if not copilot_bufnr then
    vim.notify("CopilotChatのバッファが見つかりません", vim.log.levels.ERROR)
    return
  end
  
  -- CopilotChatの内容を取得
  local lines = vim.api.nvim_buf_get_lines(copilot_bufnr, 0, -1, false)
  local content = table.concat(lines, '\n')
  
  -- markdownコードブロックから日報部分を抽出
  local nippo_pattern = "```markdown.-path=/.-nippo%..-%.md.-\n(.-)\n```"
  local extracted_nippo = content:match(nippo_pattern)
  
  if not extracted_nippo then
    -- 別のパターンも試す
    nippo_pattern = "```markdown\n(# 日報 .-)\n```"
    extracted_nippo = content:match(nippo_pattern)
  end
  
  if extracted_nippo then
    -- 日報ファイルに書き込み
    local file = io.open(nippo_path, "w")
    if file then
      file:write(extracted_nippo)
      file:close()
      vim.notify("日報ファイルを更新しました: " .. nippo_path, vim.log.levels.INFO)
      
      -- 日報ファイルを開き直す
      vim.cmd("edit " .. nippo_path)
    else
      vim.notify("日報ファイルの書き込みに失敗しました", vim.log.levels.ERROR)
    end
  else
    vim.notify("CopilotChatの結果から日報を抽出できませんでした。手動で確認してください。", vim.log.levels.WARN)
  end
end

-- 日報完成プロンプトをクリップボードにコピー
function M.copy_finalize_prompt()
  local nippo_content = get_nippo_content()
  local prompt = get_finalize_prompt()
  
  if not nippo_content or not prompt then
    return
  end
  
  local full_prompt = prompt .. "\n\n## 分析対象の日報ファイル:\n```markdown\n" .. nippo_content .. "\n```\n\n上記の日報を分析して完成させてください。"
  
  vim.fn.setreg('+', full_prompt)
  vim.notify("日報完成プロンプトをクリップボードにコピーしました。CopilotChatで Cmd+V して使用してください。", vim.log.levels.INFO)
end

-- 今日の日報を開くコマンド
function M.open_nippo()
  local nippo_path = get_nippo_path()
  
  -- ファイルが存在しない場合、テンプレートを作成
  local file = io.open(nippo_path, "r")
  if not file then
    -- 新しいGoプログラムを呼び出してテンプレートを作成
    local nippo_bin = vim.fn.expand("~/dotfiles/scripts/nippo-go/nippo")
    local cmd = string.format("'%s' '初回起動'", nippo_bin)
    local result = os.execute(cmd)
    if result == 0 then
      vim.notify("新しい日報ファイルを作成しました: " .. nippo_path, vim.log.levels.INFO)
    else
      vim.notify("日報ファイルの作成に失敗しました", vim.log.levels.ERROR)
    end
  else
    file:close()
  end
  
  vim.cmd("edit " .. nippo_path)
end

-- コマンドを登録
vim.api.nvim_create_user_command('NippoOpen', function()
  M.open_nippo()
end, { desc = 'Open today\'s nippo file' })

vim.api.nvim_create_user_command('NippoCopy', function()
  M.copy_finalize_prompt()
end, { desc = 'Copy nippo finalization prompt to clipboard' })

vim.api.nvim_create_user_command('NippoApplyResult', function()
  M.apply_copilot_result()
end, { desc = 'Apply CopilotChat result to nippo file' })

-- キーマッピング
vim.keymap.set("n", "<leader>no", function()
  M.open_nippo()
end, { noremap = true, silent = true, desc = "Open today's nippo" })

vim.keymap.set("n", "<leader>nc", function()
  M.copy_finalize_prompt()
end, { noremap = true, silent = true, desc = "Copy nippo finalization prompt" })

vim.keymap.set("n", "<leader>nr", function()
  M.apply_copilot_result()
end, { noremap = true, silent = true, desc = "Apply CopilotChat result to nippo" })

return M
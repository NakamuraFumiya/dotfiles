local wezterm = require("wezterm")
local act = wezterm.action

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

return {
  keys = {
    -- 画面フルスクリーン切り替え
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
  },
}

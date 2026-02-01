-- ref: https://zenn.dev/mozumasu/articles/mozumasu-wezterm-customization
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true

-- 背景透過設定
config.window_background_opacity = 0.6
config.macos_window_background_blur = 20

-- タブバー上部のタイトルバー削除
config.window_decorations = "RESIZE"
-- タブが1つしかない時に非表示
config.hide_tab_bar_if_only_one_tab = true

-- タブバーを透明にする
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景と同じ色にする
config.window_background_gradient = {
  colors = { "#000000" },
}

return config


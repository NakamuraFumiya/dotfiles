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

return config


local wezterm = require 'wezterm'

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true

-- 背景透過設定
config.window_background_opacity = 0.85

return config


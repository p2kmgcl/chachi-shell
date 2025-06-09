local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("ZedMono Nerd Font", { weight = 500, italic = false })
config.font_size = 16
config.line_height = 1.3

local color_scheme = "Dark"
if wezterm.gui then
  color_scheme = wezterm.gui.get_appearance()
end
if color_scheme:find("Dark") then
  config.color_scheme = "Catppuccin Mocha"
  config.window_background_opacity = 1.0
else
  config.color_scheme = "Catppuccin Latte"
  config.window_background_opacity = 1.0
end

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.adjust_window_size_when_changing_font_size = false
config.enable_scroll_bar = false
config.macos_window_background_blur = 50
config.win32_system_backdrop = "Acrylic"
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }

return config

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("ZedMono Nerd Font", { weight = 500, italic = false })
config.font_size = 16
config.line_height = 1.2

local color_scheme = "Dark"
if wezterm.gui then
  color_scheme = wezterm.gui.get_appearance()
end
if color_scheme:find("Dark") then
  config.color_scheme = "Catppuccin Mocha"
else
  config.color_scheme = "Catppuccin Latte"
end

config.enable_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }

return config

return function()
  local catppuccin = require("catppuccin")
  local flavour = catppuccin.options.background.light
  if vim.api.nvim_get_option_value("background", { scope = "global" }) == "dark" then
    flavour = catppuccin.options.background.dark
  end

  local palette = require("catppuccin.palettes." .. flavour)
  local get_theme = require("catppuccin.utils.lualine")
  local theme = get_theme(flavour)

  theme.normal.c.bg = palette.surface0
  theme.inactive.a.bg = palette.surface0
  theme.inactive.b.bg = palette.surface0
  theme.inactive.c.bg = palette.surface0
  theme.inactive.a.fg = palette.text
  theme.inactive.b.fg = palette.text
  theme.inactive.c.fg = palette.text

  return theme
end

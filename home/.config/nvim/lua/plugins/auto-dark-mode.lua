return {
  "f-person/auto-dark-mode.nvim",
  config = function()
    require("auto-dark-mode").setup({
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        local lualine = require("lualine")
        local get_lualine_theme = require("utils.get_lualine_theme")
        lualine.setup({ theme = get_lualine_theme() })
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        local lualine = require("lualine")
        local get_lualine_theme = require("utils.get_lualine_theme")
        lualine.setup({ theme = get_lualine_theme() })
      end,
    })
  end,
}

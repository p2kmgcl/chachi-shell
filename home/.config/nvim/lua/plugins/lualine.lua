return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "catppuccin/nvim" },
    event = "VimEnter",
    priority = 900,
    opts = function()
      return {
        options = {
          theme = require("utils.get_lualine_theme"),
          icons_enabled = false,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = true,
              path = 1,

              symbols = {
                modified = "*️",
                readonly = "🔒",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
          },
          lualine_x = { "filetype" },
          lualine_y = { "diff", "diagnostics" },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = { "mode" },
          lualine_b = {},
          lualine_c = {
            {
              "filename",
              file_status = true,
              newfile_status = true,
              path = 1,

              symbols = {
                modified = "*️",
                readonly = "🔒",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
          },
          lualine_x = {
            {
              require("nvim-possession").status,
              cond = function()
                return require("nvim-possession").status() ~= nil
              end,
            },
            "filetype",
          },
          lualine_y = { "diff", "diagnostics" },
          lualine_z = {},
        },
      }
    end,
  },
}

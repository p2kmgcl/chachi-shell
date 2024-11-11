return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "catppuccin/nvim", version = "1.9.0" },
    event = "VimEnter",
    priority = 900,
    opts = function()
      return {
        options = {
          theme = "catppuccin",
          icons_enabled = true,
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
          lualine_a = {},
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
      }
    end,
  },
}

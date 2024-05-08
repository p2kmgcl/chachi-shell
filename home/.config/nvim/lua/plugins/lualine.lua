return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        options = {
          theme = "auto",
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

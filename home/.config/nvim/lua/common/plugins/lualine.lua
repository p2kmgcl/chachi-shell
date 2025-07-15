return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          "diff",
          symbols = {
            added = "+",
            modified = "~",
            removed = "-",
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        "diagnostics",
      },
      lualine_c = {
        {
          function()
            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name == "" then
              return ""
            end

            local icon = require("common.helpers.get-package-icon")(buf_name)
            local name = require("common.helpers.get-package-name")(buf_name)

            if icon ~= "" and name ~= "" then
              return icon .. " " .. name
            elseif icon ~= "" then
              return icon
            elseif name ~= "" then
              return name
            end

            return ""
          end,
          color = { fg = "#9d7cd8", gui = "italic" },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { "filename" },
      },
      lualine_x = { "encoding", "fileformat" },
      lualine_y = { { "location", padding = { left = 0, right = 1 } } },
      lualine_z = { "branch" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  },
}

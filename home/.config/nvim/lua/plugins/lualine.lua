return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(str)
            local mode_map = {
              ["NORMAL"] = "",
              ["INSERT"] = "󰏫",
              ["VISUAL"] = "󰒉",
              ["V-LINE"] = "󰒉",
              ["V-BLOCK"] = "󰒉",
              ["SELECT"] = "󰒉",
              ["S-LINE"] = "󰒉",
              ["S-BLOCK"] = "󰒉",
              ["COMMAND"] = "󰅂",
              ["REPLACE"] = "󰛔",
              ["V-REPLACE"] = "󰛔",
              ["TERMINAL"] = "",
              ["EX"] = "󰅂",
              ["MORE"] = "󰝶",
              ["CONFIRM"] = "󰋗",
            }
            return mode_map[str] or str:sub(1, 1)
          end,
        },
      },
      lualine_b = {
        {
          function()
            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name == "" then
              return ""
            end

            local icon = require("helpers.get-package-icon")(buf_name)
            local name = require("helpers.get-package-name")(buf_name)

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
        { "filename", padding = { left = 0 } },
      },
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          function()
            local tracker = require("helpers.lsp-status-tracker")
            return tracker.format_for_lualine()
          end,
          cond = function()
            local tracker = require("helpers.lsp-status-tracker")
            return tracker.has_buffer_clients()
          end,
        },
        "diagnostics",
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
      },
      lualine_z = {},
    },
    inactive_sections = {
      lualine_a = {
        {
          function()
            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name == "" then
              return ""
            end

            local icon = require("helpers.get-package-icon")(buf_name)
            local name = require("helpers.get-package-name")(buf_name)

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
        { "filename", padding = { left = 0 } },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}

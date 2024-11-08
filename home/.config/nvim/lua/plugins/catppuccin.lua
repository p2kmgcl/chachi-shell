return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "latte",
      transparent_background = false,
      show_end_of_buffer = false,
      default_integrations = false,
      background = {
        light = "latte",
        dark = "mocha",
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.1,
      },
      integrations = {
        cmp = true,
        diffview = true,
        fidget = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        mini = { enabled = true, indentscope_color = "" },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
            ok = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
            ok = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        neotree = true,
        neogit = true,
        neotest = true,
        noice = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
      color_overrides = {},
      custom_highlights = function(colors)
        return {
          GitSignsAdd = { fg = colors.green },
          GitSignsChange = { fg = colors.blue },
          GitSignsDelete = { fg = colors.red },
        }
      end,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}

return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      show_end_of_buffer = false,
      default_integrations = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
      },
      integrations = {
        cmp = true,
        fidget = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
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

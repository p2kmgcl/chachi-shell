return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "VimEnter",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = false,
      show_end_of_buffer = false,
      dim_inactive = {
        enabled = true,
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
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}

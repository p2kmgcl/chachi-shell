return {
  "f-person/auto-dark-mode.nvim",
  dependencies = {
    "projekt0n/github-nvim-theme",
  },
  opts = {
    set_dark_mode = function()
      vim.cmd("colorscheme github_dark_colorblind")
    end,
    set_light_mode = function()
      vim.cmd("colorscheme github_light_colorblind")
    end,
    update_interval = 3000,
    fallback = "dark",
  },
}

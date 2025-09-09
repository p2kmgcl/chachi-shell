return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  opts = {
    options = {
      styles = {
        comments = "italic",
        keywords = "bold",
        types = "italic,bold",
      },
    },
  },
  config = function(_, options)
    require("github-theme").setup(options)

    pcall(function()
      vim.cmd("colorscheme github_light_colorblind")
    end)
  end,
}

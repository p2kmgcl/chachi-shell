return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "LazyVim", words = { "LazyVim" } },
      { path = "wezterm-types", mods = { "wezterm" } },
    },
    enabled = function(root_dir)
      return string.find(root_dir, 'chachi')
    end,
  },
}

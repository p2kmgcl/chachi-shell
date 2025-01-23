return {
  "aserowy/tmux.nvim",
  event = "VeryLazy",
  opts = {
    copy_sync = {
      enable = false,
    },
    navigation = {
      cycle_navigation = true,
      enable_default_keybindings = true,
      persist_zoom = false,
    },
    resize = {
      enable_default_keybindings = true,
      resize_step_x = 8,
      resize_step_y = 4,
    },
  },
}

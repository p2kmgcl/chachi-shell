return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = false,
        },
      },
    },
  },
}

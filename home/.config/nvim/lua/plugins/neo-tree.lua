return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      buffers = {
        group_empty_dirs = true,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      filesystem = {
        group_empty_dirs = true,
        scan_mode = "deep",
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = false,
        },
      },
      git_status = {
        group_empty_dirs = true,
      },
      default_component_configs = {
        file_size = { enabled = false },
        type = { enabled = false },
        last_modified = { enabled = false },
        created = { enabled = false },
      },
      window = {
        auto_expand_width = "fit_content",
        position = "right",
      },
    },
  },
}

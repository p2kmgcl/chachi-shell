return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  cmd = "Neotree",
  opts = {
    close_if_last_window = false,
    enable_git_status = false,
    enable_diagnostics = false,
    hide_root_node = true,
    open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy", "sidebar_buffers", "sidebar_git", "neo-tree" },
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = true },
      use_libuv_file_watcher = true,
      filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
    },
    window = {
      position = "right",
      width = 50,
      mappings = {
        ["<CR>"] = "open",
        ["l"] = "open",
        ["h"] = "close_node",
        ["<C-v>"] = "open_vsplit",
        ["<C-x>"] = "open_split",
      },
    },
    default_component_configs = {
      indent = { indent_size = 2, with_markers = true },
      icon = { folder_closed = "󰉋", folder_open = "󰝰", folder_empty = "󰉖", default = "󰈔" },
    },
  },
}

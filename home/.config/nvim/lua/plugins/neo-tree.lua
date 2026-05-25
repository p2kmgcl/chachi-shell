return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = false,
    window = {
      position = "right",
      width = 30,
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    default_component_configs = {
      indent = {
        with_markers = false,
      },
      file_size = {
        enabled = false,
      },
      last_modified = {
        enabled = false,
      },
      created = {
        enabled = false,
      },
    },
  },
  keys = {
    { "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Explorer: toggle" },
    { "<leader>ef", "<cmd>Neotree source=filesystem<cr>", desc = "Explorer: files" },
    { "<leader>eb", "<cmd>Neotree source=buffers<cr>", desc = "Explorer: buffers" },
  },
}

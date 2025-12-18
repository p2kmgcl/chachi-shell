return {
  "nvim-mini/mini.files",
  opts = {
    windows = {
      preview = true,
      width_focus = 60,
      width_nofocus = 40,
      width_preview = 60,
    },
    options = {
      use_as_default_explorer = false,
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (project root)",
    },
    { "<leader>fm", false },
    { "<leader>fM", false },
  },
  config = function(_, opts)
    local mini_files = require("mini.files")
    mini_files.setup(opts)

    local map_split = function(buf_id, lhs, direction)
      local rhs = function()
        local entry_path = mini_files.get_fs_entry().path
        local is_at_file = vim.fn.filereadable(entry_path) == 1
        mini_files.close()
        vim.cmd(direction .. " " .. vim.fn.fnameescape(entry_path))
      end

      vim.keymap.set("n", lhs, rhs, {
        buffer = buf_id,
        desc = "Open in " .. direction,
      })
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        map_split(args.data.buf_id, "<C-s>", "split")
        map_split(args.data.buf_id, "<C-v>", "vsplit")
      end,
    })
  end,
}

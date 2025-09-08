return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    need = 1,
    branch = true,
  },
  keys = {
    {
      "<leader>qs",
      function()
        require("persistence").load()
      end,
      desc = "Restore session from current dir",
    },
    {
      "<leader>ql",
      function()
        require("persistence").select()
      end,
      desc = "List sessions",
    },
  },
  init = function(_, opts)
    local persistence = require("persistence")
    persistence.setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      desc = "Update cwd when session loads",
      group = vim.api.nvim_create_augroup("persistence-load-cwd", { clear = true }),
      callback = function()
        local cwd = vim.fn.getcwd(-1, -1)
        vim.api.nvim_set_current_dir(cwd)
        vim.api.nvim_exec_autocmds("DirChanged", {
          modeline = false,
          data = { scope = "global", cwd = cwd },
        })
      end,
    })
  end,
}

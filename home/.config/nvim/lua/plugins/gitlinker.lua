return {
  {
    "linrongbin16/gitlinker.nvim",
    version = "4.13.2",
    keys = {
      {
        "<leader>gl",
        function()
          local gitlinker = require("gitlinker")

          gitlinker.setup({
            callbacks = {
              ["gitlab.protontech.ch"] = gitlinker.hosts.get_gitlab_type_url,
            },
          })

          local mode = vim.api.nvim_get_mode()["mode"]

          if mode == "V" then
            mode = "v"
          elseif mode == "^V" then
            mode = "v"
          end

          if mode ~= "v" and mode ~= "n" then
            return 1
          end

          gitlinker.get_buf_range_url(mode, {
            action_callback = gitlinker.actions.copy_to_clipboard,
          })
        end,
        mode = { "n", "v" },
        desc = "[G]it [l]ink",
      },
    },
    options = {
      mappings = nil,
    },
  },
}

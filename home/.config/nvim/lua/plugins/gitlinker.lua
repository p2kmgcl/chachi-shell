return {
  {
    "linrongbin16/gitlinker.nvim",
    keys = {
      {
        "<leader>gl",
        function()
          local gitlinker = require("gitlinker")
          local routers = require("gitlinker.routers")
          local actions = require("gitlinker.actions")

          gitlinker.setup({
            callbacks = {
              ["gitlab.protontech.ch"] = routers.gitlab_browse,
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
            action_callback = actions.clipboard,
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

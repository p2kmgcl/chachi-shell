return {
  "rachartier/tiny-code-action.nvim",
  dependencies = { { "nvim-lua/plenary.nvim" } },
  event = "LspAttach",
  opts = {
    picker = {
      "buffer",
      opts = {
        hotkeys = true,
        hotkeys_mode = "text_based",
        auto_preview = false,
      },
    },
  },
}

return {
  "Exafunction/windsurf.nvim",
  enabled = false,
  event = "InsertEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("codeium").setup({
      enable_cmp_source = false,
      virtual_text = { enabled = true, map_keys = true },
      workspace_root = { use_lsp = true, find_root = nil },
    })
  end,
}

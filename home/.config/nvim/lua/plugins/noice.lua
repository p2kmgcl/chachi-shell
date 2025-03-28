return {
  "folke/noice.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      command_palette = true, -- position the cmdline and popupmenu together
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
  },
}

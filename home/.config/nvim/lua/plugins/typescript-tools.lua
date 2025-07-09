return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("typescript-tools").setup({
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = false,
          includeInlayFunctionLikeReturnTypeHints = false,
          includeInlayEnumMemberValueHints = false,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
        tsserver_max_memory = 30720,
        complete_function_calls = false,
        include_completions_with_insert_text = false,
        code_lens = "off",
        disable_member_code_lens = true,
      },
    })
  end,
}

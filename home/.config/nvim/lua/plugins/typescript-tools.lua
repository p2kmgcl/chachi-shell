return {
  "pmizio/typescript-tools.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    -- Get total system memory and calculate half of it in MB
    local function get_half_memory()
      local handle = io.popen("sysctl -n hw.memsize")
      if handle then
        local total_bytes = handle:read("*n")
        handle:close()
        if total_bytes then
          -- Convert bytes to MB and return half
          return math.floor(total_bytes / 1024 / 1024 / 2)
        end
      end
      -- Fallback to auto if we can't determine memory
      return "auto"
    end

    require("typescript-tools").setup({
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_max_memory = get_half_memory(),
        code_lens = "off",
        disable_member_code_lens = true,
        complete_function_calls = false,
        include_completions_with_insert_text = false,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
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
      },
    })
  end,
}

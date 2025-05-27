return {
  "saghen/blink.cmp",
  enabled = false,
  opts = {
    completion = {
      autocomplete = false,
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      ghost_text = {
        enabled = false,
      },
    },
    sources = {
      providers = {
        lsp = {},
        path = {},
        buffer = {},
        snippets = {},
      },
    },
  },
}

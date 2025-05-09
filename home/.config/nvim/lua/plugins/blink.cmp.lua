return {
  "saghen/blink.cmp",
  opts = {
    completion = {
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
        lsp = {
          max_items = 10,
        },
        path = {
          max_items = 10,
        },
        buffer = {
          max_items = 10,
        },
        snippets = {
          max_items = 10,
        },
      },
    },
  },
}

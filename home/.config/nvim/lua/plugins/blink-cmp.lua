return {
  "saghen/blink.cmp",
  version = "*",
  event = "InsertEnter",
  build = {
    cmd = "cargo build --release",
    timeout_ms = 900000,
  },
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      trigger = {
        prefetch_on_insert = false,
        show_on_insert_on_trigger_character = false,
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      ghost_text = {
        enabled = false,
      },
      menu = {
        auto_show = true,
        draw = { treesitter = { "lsp" } },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
      },
      providers = {
        lsp = { async = true, timeout_ms = 200, max_items = 20 },
        buffer = { async = true, max_items = 10 },
        path = { async = true, max_items = 10 },
      },
    },
  },
}

return {
  "saghen/blink.cmp",
  version = "*",
  build = "cargo build --release",
  opts = {
    keymap = {
      preset = "default",
      ["<CR>"] = { "fallback" },
    },
    completion = {
      trigger = {
        prefetch_on_insert = false,
        show_on_insert_on_trigger_character = false,
        show_on_keyword = true,
        show_on_trigger_character = true,
        keyword_length = 3,
        keyword_regex = "[%w_%-%.]+",
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
        max_items = 30,
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
      providers = {
        lsp = {
          async = true,
          timeout_ms = 200,
          max_items = 20,
        },
        path = {
          async = true,
          max_items = 10,
        },
        buffer = {
          async = true,
          max_items = 10,
        },
      },
    },
  },
}

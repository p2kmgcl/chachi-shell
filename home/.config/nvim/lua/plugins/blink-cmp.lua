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
      ["<C-y>"] = { "accept" },
      ["<CR>"] = { "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      keyword = {
        range = "prefix",
      },
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
        enabled = true,
      },
      menu = {
        auto_show = true,
        draw = { treesitter = { "lsp" } },
        border = "rounded",
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
    },
    sources = {
      default = {
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
      providers = {
        lsp = { async = true, timeout_ms = 200, max_items = 20 },
        buffer = { async = true, max_items = 10 },
        path = { async = true, max_items = 10 },
        snippets = { async = true, max_items = 10 },
      },
    },
  },
  config = function(_, opts)
    local blink = require("blink.cmp")
    blink.setup(opts)
    vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
  end,
}

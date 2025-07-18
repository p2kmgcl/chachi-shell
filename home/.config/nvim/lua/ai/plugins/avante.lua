return {
  "yetone/avante.nvim",
  enabled = false,
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  build = "make",
  opts = {
    provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
  },
}

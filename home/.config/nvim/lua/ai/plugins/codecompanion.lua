return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "j-hui/fidget.nvim",
    {
      "ravitemer/mcphub.nvim",
      build = "bundled_build.lua",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "echasnovski/mini.diff",
      config = function()
        local diff = require("mini.diff")
        diff.setup({ source = diff.gen_source.none() })
      end,
    },
  },
  config = function()
    local codecompanion = require("codecompanion")
    local adapters = require("codecompanion.adapters")
    local mcphub = require("mcphub")

    mcphub.setup({
      use_bundled_binary = true,
      auto_approve = false,
      auto_toggle_mcp_servers = true,
    })

    codecompanion.setup({
      strategies = {
        inline = {
          adapter = "anthropic",
        },
        chat = {
          adapter = "anthropic",
        },
      },
      adapters = {
        anthropic = function()
          return adapters.extend("anthropic", {
            env = {
              api_key = "cmd:op read 'op://Employee/Anthropic API Key/password' --no-newline",
            },
          })
        end,
      },
      display = {
        action_palette = {
          provider = "snacks",
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true,
            show_server_tools_in_chat = true,
            add_mcp_prefix_to_tool_names = false,
            show_result_in_chat = true,
            format_tool = nil,
            make_vars = true,
            make_slash_commands = true,
          },
        },
      },
    })
  end,
  init = function()
    require("ai.setup.codecompanion-fidget-spinner"):init()
  end,
}

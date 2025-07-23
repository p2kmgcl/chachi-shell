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
    -- https://github.com/olimorris/codecompanion.nvim/discussions/813
    -- lua/plugins/codecompanion/fidget-spinner.lua
    local progress = require("fidget.progress")
    local handles = {}

    local function store_progress_handle(id, handle)
      handles[id] = handle
    end

    local function pop_progress_handle(id)
      local handle = handles[id]
      handles[id] = nil
      return handle
    end

    local function llm_role_title(adapter)
      local parts = {}
      table.insert(parts, adapter.formatted_name)
      if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
      end
      return table.concat(parts, " ")
    end

    local function create_progress_handle(request)
      return progress.handle.create({
        title = " Requesting assistance (" .. request.data.strategy .. ")",
        message = "In progress...",
        lsp_client = {
          name = llm_role_title(request.data.adapter),
        },
      })
    end

    local function report_exit_status(handle, request)
      if request.data.status == "success" then
        handle.message = "Completed"
      elseif request.data.status == "error" then
        handle.message = " Error"
      else
        handle.message = "󰜺 Cancelled"
      end
    end

    local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequestStarted",
      group = group,
      callback = function(request)
        local handle = create_progress_handle(request)
        store_progress_handle(request.data.id, handle)
      end,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequestFinished",
      group = group,
      callback = function(request)
        local handle = pop_progress_handle(request.data.id)
        if handle then
          report_exit_status(handle, request)
          handle:finish()
        end
      end,
    })
  end,
}

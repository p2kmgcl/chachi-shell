-- LSP Configuration & Plugins
return {
  "neovim/nvim-lspconfig",
  event = "BufReadPost",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- WARN: Must be loaded before dependants
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    -- Useful status updates for LSP.
    { "j-hui/fidget.nvim", opts = {} },
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    local lsp_attach_autogroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
    local lsp_detach_autogroup = vim.api.nvim_create_augroup("lsp-detach", { clear = true })
    local lsp_highlight_autogroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = lsp_attach_autogroup,
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
        end

        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = lsp_highlight_autogroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = lsp_highlight_autogroup,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        -- This may be unwanted, since they displace some of your code
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = lsp_detach_autogroup,
      callback = function(event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = lsp_highlight_autogroup, buffer = event.buf })
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local nvim_lsp = require("lspconfig")

    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    local servers = {
      bashls = {},
      denols = {
        root_dir = nvim_lsp.util.root_pattern("deno.json"),
        init_options = {
          lint = true,
          unstable = false,
          suggest = {
            imports = {
              hosts = {
                ["https://deno.land"] = true,
              },
            },
          },
        },
      },
      clangd = {},
      cssls = {},
      docker_compose_language_service = {},
      dockerls = {},
      eslint = {
        root_dir = nvim_lsp.util.root_pattern(
          "eslint.config.js",
          "eslint.config.ts",
          "eslint.config.mjs",
          "eslint.config.mts",
          "eslint.config.json",
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.ts",
          ".eslintrc.json"
        ),
      },
      html = {},
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      prettierd = {},
      rust_analyzer = {},
      stylelint = {},
      stylua = {},
      tailwindcss = {
        root_dir = nvim_lsp.util.root_pattern("tailwind.config.js", "tailwind.config.ts"),
      },
      taplo = {},
      ts_ls = {
        single_file_support = false,
        root_dir = nvim_lsp.util.root_pattern(".git", "jsconfig.json", "tsconfig.json", "package.json"),
        init_options = { maxTsServerMemory = 32000 },
      },
      yamlls = {},
    }

    -- Ensure the servers and tools above are installed
    require("mason").setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {})
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
    })

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}

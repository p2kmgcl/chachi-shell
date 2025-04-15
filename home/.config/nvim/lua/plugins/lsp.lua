return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          format = {
            enable = false,
          },
          codeActionOnSave = {
            enable = false,
          },
        },
      },
      vtsls = {
        init_options = { hostInfo = "neovim" },
        settings = {
          javascript = {
            format = {
              enable = false,
            },
          },
          typescript = {
            preferences = {
              importModuleSpecifier = "non-relative",
            },
            tsserver = {
              maxTsServerMemory = 20480,
              nodePath = "node",
              watchOptions = {
                excludeFiles = { ".pnp.cjs" },
                excludeDirectories = { "**/node_modules", "**/.yarn" },
              },
            },
            tsdk = "~/go/src/github.com/DataDog/web-ui/.yarn/sdks/typescript/lib",
            files = {
              maxMemoryForLargeFilesMB = 12288,
            },
            format = {
              enable = false,
            },
          },
        },
      },
    },
  },
}

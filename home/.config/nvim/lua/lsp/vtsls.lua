return {
  init_options = {
    hostInfo = "neovim",
  },
  settings = {
    rootMarkers = {
      "package.json",
      "package-lock.json",
      "tsconfig.json",
      "yarn.lock",
    },
    javascript = {
      format = {
        enable = false,
      },
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
      },
    },
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "none",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = false,
        enumMemberValues = false,
        functionLikeReturnTypes = false,
        parameterNames = false,
        parameterTypes = false,
        propertyDeclarationTypes = false,
        variableTypes = false,
      },
      preferences = {
        importModuleSpecifier = "non-relative",
      },
      tsserver = {
        maxTsServerMemory = 30720,
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
}

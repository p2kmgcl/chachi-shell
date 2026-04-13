return {
  cmd = { "gopls" },
  root_markers = { "go.mod" },
  filetypes = {
    "go",
    "gomod",
  },
  settings = {
    gopls = {
      gofumpt = true,
      ["build.directoryFilters"] = {
        "-",
        "+libs/go",
        "+domains/sci",
        "+domains/ci-app",
      },
    },
  },
}

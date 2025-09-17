return {
  cmd = { "gopls" },
  root_markers = { "go.mod" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      gofumpt = true,
    },
  },
}

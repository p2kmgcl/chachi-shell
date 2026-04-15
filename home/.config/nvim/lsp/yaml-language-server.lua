return {
  cmd = {
    "yaml-language-server",
    "--stdio",
  },
  filetypes = { "yaml" },
  on_init = function(client)
    client.settings = {
      yaml = {
        schemastore = { enable = false, url = "" },
        schemas = require("schemastore").yaml.schemas(),
      },
    }

    client:notify("workspace/didChangeConfiguration", {
      settings = client.settings,
    })
  end,
}

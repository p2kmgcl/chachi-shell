return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  on_init = function(client)
    client.settings = {
      json = {
        validate = { enable = true },
        schemas = require("schemastore").json.schemas(),
      },
    }

    client:notify("workspace/didChangeConfiguration", {
      settings = client.settings,
    })
  end,
}

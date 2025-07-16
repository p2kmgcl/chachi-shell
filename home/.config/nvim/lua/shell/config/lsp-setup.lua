vim.lsp.config("bash-language-server", vim.lsp.config.bashls)
vim.lsp.enable("bash-language-server")

vim.lsp.config("dockerfile-language-server", vim.lsp.config.dockerls)
vim.lsp.enable("dockerfile-language-server")

vim.lsp.config("fish-lsp", vim.lsp.config.fish_lsp)
vim.lsp.enable("fish-lsp")

vim.lsp.config("json-lsp", vim.lsp.config.jsonls)
vim.lsp.enable("json-lsp")

vim.lsp.config("tombi", {})
vim.lsp.enable("tombi")

vim.lsp.config("yaml-language-server", vim.lsp.config.yamlls)
vim.lsp.enable("yaml-language-server")

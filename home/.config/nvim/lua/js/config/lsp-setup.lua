vim.lsp.config("eslint-lsp", vim.lsp.config.eslint)
vim.lsp.config("eslint-lsp", { settings = { nodePath = ".yarn/sdks" } })
vim.lsp.enable("eslint-lsp")

vim.lsp.config("css-lsp", vim.lsp.config.cssls)
vim.lsp.enable("css-lsp")

vim.lsp.config("html-lsp", vim.lsp.config.html)
vim.lsp.enable("html-lsp")

vim.lsp.config("stylelint-lsp", vim.lsp.config.stylelint_lsp)
vim.lsp.enable("stylelint-lsp")

vim.lsp.config("tailwindcss-language-server", vim.lsp.config.tailwindcss)
vim.lsp.enable("tailwindcss-language-server")

return {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml' },
    settings = {
        yaml = {
            schemastore = { enable = false, url = '' },
            schemas = require('schemastore').yaml.schemas(),
        },
    },
}

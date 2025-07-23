vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('options')
require('lazy-setup')

local require_all = require('helpers.require-all')
require_all('keymaps')
require_all('setup')
require_all('autocmds')

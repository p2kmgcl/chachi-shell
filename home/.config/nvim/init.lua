vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require('options')
require('lazy-setup')
require('a-side.a-side')

local require_all = require('helpers.require-all')
require_all('keymaps')
require_all('setup')
require_all('autocmds')

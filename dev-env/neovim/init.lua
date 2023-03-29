-------------------------------------------------------------------------------
-- Cheatsheet. Some of this elements have been extracted
-- from the following
-------------------------------------------------------------------------------
-- https://vim.rtorr.com/
-- https://devhints.io/vim
-------------------------------------------------------------------------------
-- Windows
-------------------------------------------------------------------------------
-- [NORMAL] [Ctrl-w_s] - Split window.
-- [NORMAL] [Ctrl-w_v] - Split window vertically.
-- [NORMAL] [Ctrl-w_q] - Close a window.
-- [NORMAL] [Ctrl-w_o] - Close all but current window (same than :only).
-- [NORMAL] [Ctrl-w_T] - Move current split to a new tab.
-------------------------------------------------------------------------------
-- Tabs
-------------------------------------------------------------------------------
-- [:tab] - Create new tab.
-- [:tab *] - Outputs the given command in a new tab.
-- [NORMAL] [gt] - Move to next tab.
-- [NORMAL] [gT] - Move to previous tab.
-------------------------------------------------------------------------------
-- Motion
-------------------------------------------------------------------------------
-- [NORMAL] [o] - Append a new line.
-- [NORMAL] [O] - Prepend a new line.
-- [NORMAL] [Ctrl-o] - Move to previous position.
-- [NORMAL] [Ctrl-i] - Move to next position.
-- [NORMAL] [Ctrl-u] - Move 1/2 screen up.
-- [NORMAL] [Ctrl-d] - Move 1/2 screen down.
-- [NORMAL] [gg] -  Move to the beginning of the document.
-- [NORMAL] [G] - Move to the end of the document.
-- [NORMAL] [zz] - Center cursor on screen.
-------------------------------------------------------------------------------
-- Macros
-------------------------------------------------------------------------------
-- [NORMAL] [qa] - Start recording "a" macro.
-- [NORMAL] [q] - Stop recording.
-- [NORMAL] [@a] - Run "a" macro.
-- [NORMAL] [@@] - Rerun last macro.
-------------------------------------------------------------------------------
-- Extra
-------------------------------------------------------------------------------
-- [NORMAL] [K] - Show docs (run again to focus docs).
-- [VISUAL] [p] - Replaces current selection with clipboard.
-------------------------------------------------------------------------------

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use { -- Package manager
    'wbthomason/packer.nvim'
  }

  use { -- Color scheme
    "catppuccin/nvim", as = "catppuccin"
  }

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines

  use { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  use { -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available.
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make',
    cond = vim.fn.executable 'make' == 1
  }

  use { -- Nice file tree
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use { -- Key mapping help
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 0

      require("which-key").setup {
        key_labels = {
          ["<space>"] = " ",
        }
      }
    end
  }

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Remove line numbers from terminal
local termopen_group = vim.api.nvim_create_augroup('TermOpen', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal nonumber',
  group = termopen_group,
})

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

vim.opt.clipboard = 'unnamedplus' -- Use GUI clipboard
vim.o.hlsearch = false -- Set highlight on search
vim.wo.relativenumber = true -- Make line numbers default
vim.wo.number = true -- Make line numbers default
vim.o.mouse = 'a' -- Enable mouse mode
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = false -- Save undo history
vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.smartcase = true
vim.o.updatetime = 250 -- Decrease update time
vim.wo.signcolumn = 'yes'
vim.o.termguicolors = true -- Set colorscheme
vim.cmd [[colorscheme catppuccin-latte]]
vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.wrap = false -- Long lines wrapping

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- [[ Basic Keymaps ]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    path_display = {
      "truncate"
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzily search in current buffer' })

require("which-key").register({
  ["<leader>s"] = { name = "Search" },
})
vim.keymap.set('n', '<leader>sf',
  require('telescope.builtin').find_files, { desc = 'Files' }
)
vim.keymap.set('n', '<leader>sh',
  require('telescope.builtin').help_tags, { desc = 'Help' }
)
vim.keymap.set('n', '<leader>sw',
  require('telescope.builtin').grep_string, { desc = 'Current word' }
)
vim.keymap.set('n', '<leader>sg',
  require('telescope.builtin').live_grep, { desc = 'Grep' }
)
vim.keymap.set('n', '<leader>sd',
  require('telescope.builtin').diagnostics, { desc = 'Diagnostics' }
)

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'javascript', 'lua', 'rust', 'tsx', 'typescript', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<leader>cc',
      node_incremental = '<leader>cN',
      scope_incremental = '<leader>cM',
      node_decremental = '<leader>cn',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
require("which-key").register({ ["<leader>d"] = { name = "Diagnostic" } })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = 'Open floating menu' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open in loc list' })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  require("which-key").register({ ["<leader>c"] = { name = "Code action" } })
  nmap('<leader>cr', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>cn', vim.lsp.buf.formatting, 'Format')
  nmap('<leader>ca', vim.lsp.buf.code_action, 'Other action')

  require("which-key").register({ ["<leader>g"] = { name = "Go to" } })
  nmap('<leader>gd', vim.lsp.buf.definition, 'Definition')
  nmap('<leader>gr', require('telescope.builtin').lsp_references, 'References')
  nmap('<leader>gI', vim.lsp.buf.implementation, 'Implementation')
  nmap('<leader>gT', vim.lsp.buf.type_definition, 'Type definition')
  nmap('<leader>gD', vim.lsp.buf.declaration, 'Declaration')
  nmap('<leader>gs', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
  nmap('<leader>gS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

local servers = {
  bashls = {},
  cssls = {},
  eslint = {},
  html = {},
  jdtls = {},
  jsonls = {},
  lua_ls = {},
  rust_analyzer = {},
  stylelint_lsp = {},
  tailwindcss = {},
  tsserver = {},
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs( -4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable( -1) then
        luasnip.jump( -1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- nvim-tree setup
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = {
      min = 20,
      max = 50,
    },
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
    side = 'right',
    centralize_selection = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  update_focused_file = {
    enable = true
  },
})

vim.keymap.set('n', '<leader>t', function()
  local api = require('nvim-tree.api')
  api.tree.toggle({ find_file = true })
end,
  { desc = 'Toggle tree' }
)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

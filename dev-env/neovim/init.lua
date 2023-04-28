-------------------------------------------------------------------------------
-- OLa ------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- Install packer
local packer_install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(packer_install_path)) > 0 then
  packer_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path }
  vim.cmd [[packadd packer.nvim]]
end

-------------------------------------------------------------------------------
-- Plugins --------------------------------------------------------------------
-------------------------------------------------------------------------------

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use { -- Lovely fuzzy finder.
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      local telescope = require('telescope')
      local telescope_builtin = require('telescope.builtin')

      telescope.setup {
        defaults = {
          path_display = { 'truncate' },
          layout_strategy = 'horizontal',
          layout_config = {
            height = 0.95,
            width = 0.95,
            preview_width = 90,
            preview_cutoff = 160,
          },
        },
        pickers = {
          commands = {
            theme = 'dropdown'
          }
        }
      }

      vim.keymap.set('n', '<C-p>', telescope_builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<C-e>', telescope_builtin.buffers, { desc = 'Find buffer' })
      vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, { desc = 'Find grep' })
      vim.keymap.set('n', '<leader>/', telescope_builtin.current_buffer_fuzzy_find, { desc = 'Find in buffer' })

      vim.keymap.set('n', '<leader>fbc', telescope_builtin.git_bcommits, { desc = 'Find buffer commits' })
      vim.keymap.set('n', '<leader>fc', telescope_builtin.commands, { desc = 'Find commands' })
      vim.keymap.set('n', '<leader>fg', telescope_builtin.git_files, { desc = 'Find git files' })
      vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Find help' })
      vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = 'Find keymaps' })
      vim.keymap.set('n', '<leader>fs', telescope_builtin.treesitter, { desc = 'Find symbol' })
    end
  }

  use { -- Syntax highlighting
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "bash",
          "css",
          "html",
          "java",
          "javascript",
          "json",
          "lua",
          "python",
          "rust",
          "scss",
          "sql",
          "typescript",
          "vimdoc",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = false,
        },
        indent = {
          enable = true,
        },
      })
    end
  }

  use { -- Undo tree
    "mbbill/undotree",
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end
  }

  use { -- Git
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", '<leader>gs', vim.cmd.Git)
    end
  }

  use { -- Git signs
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '█' },
          change       = { text = '█' },
          delete       = { text = '█' },
          topdelete    = { text = '█' },
          changedelete = { text = '█' },
          untracked    = { text = '█' },
        },
      })
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end

  use {
    'neovim/nvim-lspconfig',
    requires = {
      -- Default config
      { 'VonHeikemen/lsp-zero.nvim' },
      -- Completion
      { 'hrsh7th/nvim-cmp' },
      { 'L3MON4D3/LuaSnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      -- Nice UI feedback on the bottom right
      { 'j-hui/fidget.nvim' },
    },
    config = function()
      local lspzero = require('lsp-zero')
      local lspconfig = require('lspconfig')
      local cmp = require('cmp')
      local cmp_lsp = require('cmp_nvim_lsp')
      local fidget = require('fidget')

      lspzero.preset('recommended')

      lspzero.set_preferences({
        sign_icons = {}
      })

      lspzero.setup_nvim_cmp({
        mapping = lspzero.defaults.cmp_mappings({
          ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        })
      })

      lspzero.on_attach(function(_, bufnr)
        local opts = { buffer = bufnr, remap = false }
        local telescope_builtin = require('telescope.builtin')

        lspzero.default_keymaps({ buffer = bufnr })

        vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, opts)
        vim.keymap.set('n', 'gr', telescope_builtin.lsp_references, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('n', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
      end)

      cmp.setup({
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
      })

      lspconfig.rust_analyzer.setup({
        capabilities = cmp_lsp.default_capabilities(),
      })

      lspconfig.tsserver.setup({
        root_dir = lspconfig.util.root_pattern("package.json"),
        capabilities = cmp_lsp.default_capabilities(),
        single_file_support = false,
        init_options = {
          lint = true,
        },
      })

      lspconfig.denols.setup({
        root_dir = lspconfig.util.root_pattern("deno.json"),
        single_file_support = false,
        init_options = {
          lint = true,
        },
      })

      lspconfig.lua_ls.setup({
        capabilities = cmp_lsp.default_capabilities(),
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      fidget.setup()
      lspzero.setup()
    end
  }

  use { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end
  }

  use { -- Nice file tree
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local tree = require('nvim-tree')
      local api = require('nvim-tree.api')

      tree.setup {
        sort_by = "case_sensitive",
        view = {
          width = { min = 30, max = 60 },
          side = 'right',
          centralize_selection = true,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        update_focused_file = {
          enable = true
        },
      }

      vim.keymap.set('n', '<leader>t', function() api.tree.toggle { find_file = true } end)
    end
  }

  use { -- Seamless tmux navigation
    'christoomey/vim-tmux-navigator'
  }

  use { -- Nice line
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'catppuccin/nvim', as = 'catppuccin' },
    },
    config = function()
      require('catppuccin').setup({
        flavour = 'latte',
        custom_highlights = function(colors)
          return {
            ColorColumn = { bg = colors.mantle },
            CursorLine = { bg = colors.mantle },
            NvimTreeNormal = { bg = colors.crust },
            WinSeparator = { bg = colors.crust, fg = colors.crust },
          }
        end
      });

      local color_columns = '81'
      for i = 82, 500 do color_columns = color_columns .. ',' .. i end
      vim.opt.colorcolumn = color_columns -- Manual max line width

      vim.cmd.colorscheme 'catppuccin'

      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'catppuccin',
          component_separators = '',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'diff', 'encoding', 'fileformat', 'filetype' },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
      })
    end
  }
end)

-------------------------------------------------------------------------------
-- Packer setup ---------------------------------------------------------------
-------------------------------------------------------------------------------

-- Automagically rebuild packer on lua change.
local packer_compile_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    vim.api.nvim_command 'luafile %'
    require('packer').compile()
  end,
  group = packer_compile_group,
  pattern = '*.lua',
})

-- Warn if packer is installing.
if packer_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-------------------------------------------------------------------------------
-- Settings -------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.opt.nu = true                                         -- Line numbers
vim.opt.relativenumber = true                             -- Relative line numbers
vim.opt.expandtab = true                                  -- Indent with spaces
vim.opt.smartindent = true                                -- Change indent on the fly
vim.opt.wrap = false                                      -- Text wrap
vim.opt.swapfile = false                                  -- Swap files are evil
vim.opt.backup = false                                    -- Backups are evil too
vim.opt.undodir = os.getenv("HOME") .. "/.neovim-undodir" -- Infinite undo
vim.opt.undofile = true                                   -- Infinite undo
vim.opt.hlsearch = false                                  -- Highlight words during search
vim.opt.incsearch = true                                  -- Feedback during search
vim.opt.termguicolors = true                              -- More colors
vim.opt.scrolloff = 999                                   -- Center cursor
vim.opt.signcolumn = 'yes'                                -- Symbols in line numbers
vim.opt.isfname:append('@-@')                             -- TODO
vim.opt.updatetime = 50                                   -- Faster updates
vim.opt.clipboard = 'unnamedplus'                         -- Use GUI clipboard
vim.opt.ignorecase = true                                 -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true                                  -- Take into account case only if needed
vim.opt.cursorline = true                                 -- Highlight current line
vim.opt.cmdheight = 0                                     -- No command line

vim.g.mapleader = ','

-- Visual move lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Paste or delete without losing clipboard
vim.keymap.set('n', '<leader>p', "\"_dP")
vim.keymap.set('n', '<leader>d', "\"_d")
vim.keymap.set('v', '<leader>d', "\"_d")

-- Format current buffer
vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = false, timeout_ms = 5000 }) end)

-- Rename current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Allow existing terminal with Esc
vim.keymap.set('t', '<Esc>', '<C-\\><C-N>')

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-------------------------------------------------------------------------------
-- Automation -----------------------------------------------------------------
-------------------------------------------------------------------------------

-- Remove line numbers from terminal
local term_line_numbers_group = vim.api.nvim_create_augroup('TermLineNumbers', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal nonumber',
  group = term_line_numbers_group,
})

-- Fold diffs in commit view
local fold_commits_group = vim.api.nvim_create_augroup('FoldCommits', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = "git",
  group = fold_commits_group,
  command = "setlocal foldenable foldmethod=syntax foldlevel=0",
})

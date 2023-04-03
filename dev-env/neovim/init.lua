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
                    path_display = {
                        'truncate',
                    },
                },
                pickers = {
                    commands = {
                        theme = 'dropdown'
                    }
                }
            }

            vim.keymap.set('n', '<C-p>', telescope_builtin.git_files, { desc = 'Find git files' })
            vim.keymap.set('n', '<C-e>', telescope_builtin.buffers, { desc = 'Find buffer' })
            vim.keymap.set('n', '<C-f>', telescope_builtin.live_grep, { desc = 'Find grep' })

            vim.keymap.set('n', '<leader>fc', telescope_builtin.commands, { desc = 'Find commands' })
            vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Find files' })
            vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = 'Find help' })
            vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = 'Find keymaps' })
            vim.keymap.set('n', '<leader>fs', telescope_builtin.treesitter, { desc = 'Find symbol' })
        end
    }

    use { -- Color scheme
        "catppuccin/nvim", as = "catppuccin"
    }

    use { -- Syntax highlighting
        "nvim-treesitter/nvim-treesitter",
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "vimdoc", "javascript", "typescript", "lua", "rust" },
                sync_install = false,
                auto_install = true,
                highlight = { enable = true },
            }
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

    if packer_bootstrap then
        require('packer').sync()
    end

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            { 'neovim/nvim-lspconfig' },
            { 'j-hui/fidget.nvim' },
            {
                'williamboman/mason.nvim',
                run = function() pcall(vim.cmd, 'MasonUpdate') end
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
            { 'simrat39/rust-tools.nvim' },
        },
        config = function()
            local lsp = require('lsp-zero')
            local lsp_config = require('lspconfig')
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            local fidget = require('fidget')
            local rust_tools = require('rust-tools')

            lsp.preset('recommended')

            lsp.ensure_installed({
                'tsserver',
                'eslint',
                'lua_ls',
                'rust_analyzer'
            })

            local cmp_mappings = lsp.defaults.cmp_mappings({
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            })

            lsp.set_preferences({
                sign_icons = {}
            })

            lsp.setup_nvim_cmp({
                mapping = cmp_mappings
            })

            lsp.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr, remap = false }

                lsp.default_keymaps({ buffer = bufnr })

                vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set('n', '[d', function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set('n', ']d', function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
                vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set('n', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
            end)

            lsp_config.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        hint = {
                            enable = true
                        }
                    }
                }
            }

            rust_tools.setup = {
                tools = {
                    inlay_hints = {
                        auto = true,
                        show_parameter_hints = true,
                    }
                },
                server = {
                    on_attach = lsp.on_attach,
                },
            }

            fidget.setup()
            lsp.setup()
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
            }

            vim.keymap.set('n', '<leader>t', function() api.tree.toggle { find_file = true } end)
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
vim.opt.tabstop = 4                                       -- Indent
vim.opt.softtabstop = 4                                   -- Indent
vim.opt.shiftwidth = 4                                    -- Indent
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
vim.cmd [[colorscheme catppuccin-latte]]                  -- Set colorscheme
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })         -- Transparent bg
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })    -- Transparent floating bg
vim.opt.scrolloff = 999                                   -- Center cursor
vim.opt.signcolumn = 'yes'                                -- Symbols in line numbers
vim.opt.isfname:append('@-@')                             -- TODO
vim.opt.updatetime = 50                                   -- Faster updates
vim.opt.colorcolumn = '80'                                -- Manual max line width
vim.opt.clipboard = 'unnamedplus'                         -- Use GUI clipboard
vim.opt.ignorecase = true                                 -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smartcase = true                                  -- Take into account case only if needed

-------------------------------------------------------------------------------
-- Keybindings ----------------------------------------------------------------
-------------------------------------------------------------------------------

-- Windows
-- [NORMAL] [Ctrl-w_s] - Split window.
-- [NORMAL] [Ctrl-w_v] - Split window vertically.
-- [NORMAL] [Ctrl-w_q] - Close a window.
-- [NORMAL] [Ctrl-w_o] - Close all but current window (same than :only).
-- [NORMAL] [Ctrl-w_T] - Move current split to a new tab.
-- [NORMAL] [Ctrl-w_=] - Resive all windows to have same size.

-- Tabs
-- [:tab] - Create new tab.
-- [:tab *] - Outputs the given command in a new tab.
-- [NORMAL] [gt] - Move to next tab.
-- [NORMAL] [gT] - Move to previous tab.
-- [:tabclose] - Closes current tab.

-- Motion
-- [NORMAL] [o] - Append a new line.
-- [NORMAL] [O] - Prepend a new line.
-- [NORMAL] [Ctrl-o] - Move to previous position.
-- [NORMAL] [Ctrl-i] - Move to next position.
-- [NORMAL] [Ctrl-u] - Move 1/2 screen up.
-- [NORMAL] [Ctrl-d] - Move 1/2 screen down.
-- [NORMAL] [gg] -  Move to the beginning of the document.
-- [NORMAL] [G] - Move to the end of the document.
-- [NORMAL] [zz] - Center cursor on screen.

-- Folding
-- [NORMAL] [zo] - Open fold.
-- [NORMAL] [zc] - Close fold.

-- Macros
-- [NORMAL] [qa] - Start recording "a" macro.
-- [NORMAL] [q] - Stop recording.
-- [NORMAL] [@a] - Run "a" macro.
-- [NORMAL] [@@] - Rerun last macro.

-- Extra
-- [NORMAL] [K] - Show docs (run again to focus docs).
-- [VISUAL] [p] - Replaces current selection with clipboard.

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
local termopen_group = vim.api.nvim_create_augroup('TermOpen', { clear = true })
vim.api.nvim_create_autocmd('TermOpen', {
    command = 'setlocal nonumber',
    group = termopen_group,
})

-- Fold diffs in commit view
local fugitive_commit_fold_group = vim.api.nvim_create_augroup('FugitiveCommitFold', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = "git",
    command = 'setlocal foldmethod=syntax',
    group = fugitive_commit_fold_group,
})

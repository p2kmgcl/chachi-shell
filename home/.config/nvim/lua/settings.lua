vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.conceallevel = 0 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.grepprg = "rg --vimgrep --hidden --ignore-vcs --ignore-global --iglob !.git/*" -- Search hidden files
vim.opt.mouse = "" -- Disallow mouse events
vim.opt.showmode = false -- Do not show mode, it's already in status line
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.spelllang = "" -- No spellcheck
vim.opt.swapfile = false -- No swap files
vim.opt.termguicolors = true -- Use term GUI colors (needed for notifications)
vim.opt.updatetime = 250 -- Reduce updatetime
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Globals
vim.g.have_nerd_font = true -- Use nerd font icons

-- Nice popups
vim.opt.pumblend = 10 -- Popup blend
vim.opt.winblend = 10 -- Window blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup

-- Beautiful gutter
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Default split position
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Keep current line visible and in the center of the screen
vim.opt.cursorline = true
vim.opt.scrolloff = 99 -- Keep cursor in the middle of screen

-- Disabled until long file names handling is fixed https://github.com/neovim/neovim/issues/7073
-- Workaround from vim-undodir-file.lua
vim.opt.undofile = true

-- Decrease mapped sequence wait time. Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Better search in file
vim.opt.hlsearch = true
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smartcase = true

local map = vim.keymap.set

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Close current tab
map("n", "<leader>Q", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- Disable arrow keys in normal mode
map("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
map("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
map("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
map("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Search Result" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("v", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("n", "d", '"_d', { noremap = true, desc = "Delete without yank" })
map("v", "d", '"_d', { noremap = true, desc = "Delete without yank" })

map("n", "<leader>tn", function()
  if vim.api.nvim_get_option_value("number", { scope = "local" }) then
    vim.api.nvim_set_option_value("number", false, { scope = "local" })
  else
    vim.api.nvim_set_option_value("number", true, { scope = "local" })
  end
end, { desc = "[T]oggle Line [N]umbers" })

map("n", "<leader>tr", function()
  if vim.api.nvim_get_option_value("relativenumber", { scope = "local" }) then
    vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
  else
    vim.api.nvim_set_option_value("relativenumber", true, { scope = "local" })
  end
end, { desc = "[T]oggle [R]elative Line Numbers" })

map("n", "<leader>tw", function()
  if vim.api.nvim_get_option_value("wrap", { scope = "local" }) then
    vim.api.nvim_set_option_value("wrap", false, { scope = "local" })
  else
    vim.api.nvim_set_option_value("wrap", true, { scope = "local" })
  end
end, { desc = "[T]oggle [W]rap" })

map("n", "[t", function()
  vim.cmd("tabprevious")
end, { desc = "Previous [t]ab" })
map("n", "]t", function()
  vim.cmd("tabnext")
end, { desc = "Next [t]ab" })

map("n", "<C-w>Q", function()
  vim.cmd("tabclose")
end, { desc = "Quit a tab" })

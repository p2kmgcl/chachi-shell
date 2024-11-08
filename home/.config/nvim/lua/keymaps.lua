local map = vim.keymap.set

-- Set highlight on search, but clear on pressing <Esc> in normal mode
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Close current tab
map("n", "<leader>Q", "<cmd>tabclose<CR>", { desc = "Close current tab" })

-- Diagnostic keymaps
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "]d", diagnostic_goto(true), { desc = "Next [D]iagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Previous [D]iagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[C]ode [D]iagnostics" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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

-- change text without updating yank
map("n", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("v", "c", '"_c', { noremap = true, desc = "Change without yank" })
map("n", "d", '"_d', { noremap = true, desc = "Delete without yank" })
map("v", "d", '"_d', { noremap = true, desc = "Delete without yank" })

-- open new terminal
map("n", "<leader>nt", "<cmd>terminal<CR><cmd>setlocal nonumber norelativenumber<CR>i", { desc = "[N]ew [t]erminal" })

-- toggle wrap
map("n", "<leader>tw", function()
  if vim.api.nvim_get_option_value("wrap", { scope = "local" }) then
    vim.api.nvim_set_option_value("wrap", false, { scope = "local" })
  else
    vim.api.nvim_set_option_value("wrap", true, { scope = "local" })
  end
end, { desc = "[T]oggle [W]rap" })

-- run proton client
map(
  "n",
  "<leader>rc",
  '<cmd>term cd /Users/p2kmgcl/Projects/proton-clients && yarn start-all --applications "proton-account proton-mail proton-calendar" --api proton.black --port 8443<CR><cmd>setlocal nonumber norelativenumber<CR>i',
  { desc = "[R]un Proton [C]lient" }
)

-- run proton desktop
map(
  "n",
  "<leader>rd",
  "<cmd>term cd /Users/p2kmgcl/Projects/proton-clients/applications/inbox-desktop && yarn start<CR><cmd>setlocal nonumber norelativenumber<CR>i",
  { desc = "[R]un Proton [D]esktop" }
)

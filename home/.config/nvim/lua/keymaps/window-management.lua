local tmux_directions = { h = "L", j = "D", k = "U", l = "R" }

local function navigate(dir)
  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  if vim.api.nvim_get_current_win() == before and vim.env.TMUX then
    vim.fn.system("tmux select-pane -" .. tmux_directions[dir])
  end
end

vim.keymap.set("n", "<C-h>", function() navigate("h") end, { desc = "Go to Left Window" })
vim.keymap.set("n", "<C-j>", function() navigate("j") end, { desc = "Go to Lower Window" })
vim.keymap.set("n", "<C-k>", function() navigate("k") end, { desc = "Go to Upper Window" })
vim.keymap.set("n", "<C-l>", function() navigate("l") end, { desc = "Go to Right Window" })
vim.keymap.set("i", "<C-h>", "<Esc><C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("i", "<C-j>", "<Esc><C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("i", "<C-k>", "<Esc><C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("i", "<C-l>", "<Esc><C-w>l", { desc = "Go to Right Window", remap = true })

local tmux_resize = { h = "-L 8", j = "-D 4", k = "-U 4", l = "-R 8" }

local resize = function(key)
  local amount = 10

  vim.keymap.set("n", "<M-" .. key .. ">", function()
    local win = vim.api.nvim_get_current_win()

    -- Check for a neighbor in this direction; fall through to tmux if none
    vim.cmd("wincmd " .. key)
    local has_neighbor = vim.api.nvim_get_current_win() ~= win
    vim.api.nvim_set_current_win(win)

    if not has_neighbor and vim.env.TMUX then
      vim.fn.system("tmux resize-pane " .. tmux_resize[key])
      return
    end

    if key == "h" then
      vim.cmd("wincmd h")
      vim.cmd("vertical resize -" .. amount)
    elseif key == "j" then
      vim.cmd("wincmd k")
      vim.cmd("resize +" .. amount)
    elseif key == "k" then
      vim.cmd("wincmd k")
      vim.cmd("resize -" .. amount)
    elseif key == "l" then
      vim.cmd("wincmd h")
      vim.cmd("vertical resize +" .. amount)
    end
    vim.api.nvim_set_current_win(win)
  end)
end

resize("h")
resize("j")
resize("k")
resize("l")

-- Move window position (Alt-Shift)
vim.keymap.set("n", "<M-S-h>", "<C-w>H", { desc = "Move Window Left" })
vim.keymap.set("n", "<M-S-j>", "<C-w>J", { desc = "Move Window Down" })
vim.keymap.set("n", "<M-S-k>", "<C-w>K", { desc = "Move Window Up" })
vim.keymap.set("n", "<M-S-l>", "<C-w>L", { desc = "Move Window Right" })

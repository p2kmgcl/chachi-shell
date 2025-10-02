vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

local resize = function(key)
  local amount = 10

  vim.keymap.set("n", "<M-" .. key .. ">", function()
    local win = vim.api.nvim_get_current_win()
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

local terminal_buffers = { [1] = nil, [2] = nil, [3] = nil }

local function toggle_terminal(id)
  local existing_buf = terminal_buffers[id]
  if existing_buf then
    vim.cmd("buffer " .. existing_buf)
  else
    vim.cmd("terminal")
    local buf = vim.fn.bufnr()
    vim.cmd("file Terminal " .. id)
    terminal_buffers[id] = buf
  end
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<A-1>", function()
  toggle_terminal(1)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<A-2>", function()
  toggle_terminal(2)
end, { noremap = true, silent = true })
vim.keymap.set("n", "<A-3>", function()
  toggle_terminal(3)
end, { noremap = true, silent = true })
vim.keymap.set("t", "<A-1>", function()
  toggle_terminal(1)
end, { noremap = true, silent = true })
vim.keymap.set("t", "<A-2>", function()
  toggle_terminal(2)
end, { noremap = true, silent = true })
vim.keymap.set("t", "<A-3>", function()
  toggle_terminal(3)
end, { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

local last_buf = nil
local prev_buf = nil

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local curr = vim.api.nvim_get_current_buf()
    if last_buf and last_buf ~= curr then
      if vim.api.nvim_buf_is_valid(last_buf) then
        prev_buf = last_buf
      else
        local alt = vim.fn.bufnr("#")
        if alt > 0 and alt ~= curr then
          prev_buf = alt
        end
      end
    end
    last_buf = curr
  end,
})

local function terminal_ctrl_o()
  vim.cmd("stopinsert")
  local current_buf = vim.api.nvim_get_current_buf()
  if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) and prev_buf ~= current_buf then
    vim.cmd("buffer " .. prev_buf)
  else
    local alt = vim.fn.bufnr("#")
    if alt > 0 and alt ~= current_buf then
      vim.cmd("buffer " .. alt)
    else
      vim.cmd("normal! <C-o>")
    end
  end
end

vim.keymap.set("t", "<C-o>", terminal_ctrl_o, { noremap = true, silent = true })

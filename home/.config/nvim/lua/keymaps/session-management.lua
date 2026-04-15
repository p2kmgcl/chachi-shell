local session_dir = vim.fn.stdpath("state") .. "/sessions"

local function session_file()
  vim.fn.mkdir(session_dir, "p")
  local cwd = vim.fn.getcwd():gsub("/", "%%")
  return session_dir .. "/" .. cwd .. ".vim"
end

vim.keymap.set("n", "<leader>qq", function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
    vim.cmd("qa")
    return
  end
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
  vim.cmd("qa")
end, { desc = "Save session and quit" })

vim.keymap.set("n", "<leader>qs", function()
  local path = session_file()
  if vim.fn.filereadable(path) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(path))
    local cwd = vim.fn.getcwd(-1, -1)
    vim.api.nvim_set_current_dir(cwd)
    vim.api.nvim_exec_autocmds("DirChanged", {
      modeline = false,
      data = { scope = "global", cwd = cwd },
    })
  else
    vim.notify("No session found", vim.log.levels.WARN)
  end
end, { desc = "Restore last session" })

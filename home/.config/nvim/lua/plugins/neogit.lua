local generating_commit = false

local function commit_with_generated_message()
  if generating_commit then
    return
  end

  local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
  local hook = config_home .. "/git/global-hooks/prepare-commit-msg"
  if vim.fn.executable(hook) ~= 1 then
    vim.notify("Commit message generator not found: " .. hook, vim.log.levels.WARN)
    return
  end

  local git = require("neogit.lib.git")
  local worktree = git.repo.worktree_root
  local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
  local fd, draft = vim.uv.fs_mkstemp(vim.fn.tempname() .. "XXXXXX")
  if not fd then
    vim.notify("Could not create a commit message draft", vim.log.levels.ERROR)
    return
  end
  vim.uv.fs_close(fd)
  generating_commit = true

  local function finish(message, level)
    vim.uv.fs_unlink(draft)
    generating_commit = false
    if message then
      vim.notify(message, level)
    end
  end

  local open_editor = require("neogit.lib.async").void(function(result)
    if result.code ~= 0 then
      local detail = vim.trim(result.stderr or "")
      return finish("Commit message generation failed" .. (detail ~= "" and ": " .. detail or ""), vim.log.levels.ERROR)
    end
    local ok, lines = pcall(vim.fn.readfile, draft)
    if not ok or vim.trim(table.concat(lines, "\n")) == "" then
      return finish("No commit message generated. Stage changes first.", vim.log.levels.WARN)
    end
    if
      vim.api.nvim_get_current_win() ~= win
      or vim.api.nvim_get_current_buf() ~= buf
      or git.repo.worktree_root ~= worktree
    then
      return finish("Commit draft discarded because you left the Neogit status view", vim.log.levels.WARN)
    end

    local opened, err = pcall(function()
      require("neogit.client").wrap(git.cli.commit.edit.args("--file=" .. draft), {
        autocmd = "NeogitCommitComplete",
        msg = { success = "Committed", fail = "Commit did not complete" },
        interactive = true,
        show_diff = require("neogit.config").values.commit_editor.show_staged_diff,
      })
    end)
    if opened then
      finish()
    else
      finish(tostring(err), vim.log.levels.ERROR)
    end
  end)

  local on_exit = vim.schedule_wrap(open_editor)
  local started, err = pcall(vim.system, { hook, draft }, { cwd = worktree, text = true }, on_exit)
  if not started then
    return finish(tostring(err), vim.log.levels.ERROR)
  end
  vim.notify("Generating commit message from staged changes…")
end

return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {
    graph_style = "unicode",
    mappings = { status = { C = commit_with_generated_message } },
    signs = {
      item = { "", "" },
      section = { "", "" },
    },
  },
}

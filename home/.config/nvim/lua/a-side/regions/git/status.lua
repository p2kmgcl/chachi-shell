local M = {}

local STATUS_CMD = {
  'git', '--no-optional-locks', 'status',
  '--short', '--branch',
  '--untracked-files=normal',
  '--ignore-submodules=dirty',
}

function M.resolve(cwd, callback)
  vim.system(
    { 'git', '-C', cwd, 'rev-parse', '--show-toplevel', '--absolute-git-dir' },
    { text = true },
    function(out)
      vim.schedule(function()
        if out.code ~= 0 then
          callback(nil)
          return
        end
        local lines = vim.split(vim.trim(out.stdout or ''), '\n', { plain = true })
        if #lines < 2 or lines[1] == '' or lines[2] == '' then
          callback(nil)
          return
        end
        callback({ toplevel = lines[1], gitdir = lines[2] })
      end)
    end
  )
end

function M.run(toplevel, callback)
  vim.system(STATUS_CMD, { text = true, cwd = toplevel }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        local err = vim.split(vim.trim(out.stderr or 'git error'), '\n', { plain = true })[1] or 'git error'
        callback({ ok = false, err = err })
        return
      end
      local lines = {}
      for _, line in ipairs(vim.split(out.stdout or '', '\n', { plain = true })) do
        if line ~= '' then lines[#lines + 1] = line end
      end
      callback({ ok = true, lines = lines })
    end)
  end)
end

return M

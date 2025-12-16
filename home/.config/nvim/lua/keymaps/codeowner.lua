vim.keymap.set("n", "<leader>co", function()
  local buf_name = vim.api.nvim_buf_get_name(0)

  if not (buf_name and vim.uv.fs_stat(buf_name)) then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  local github_dir = vim.fs.find(".github", {
    path = buf_name,
    type = "directory",
    upward = true,
    limit = 1,
  })[1]

  if not github_dir then
    vim.notify("No .github directory found", vim.log.levels.WARN)
    return
  end

  local codeowners_path = vim.fs.joinpath(github_dir, "CODEOWNERS")
  if not vim.uv.fs_stat(codeowners_path) then
    vim.notify("No CODEOWNERS file found", vim.log.levels.WARN)
    return
  end

  local project_root = github_dir:match("(.*)/%.github$")
  local relative_path = buf_name:sub(#project_root + 2)

  local get_buffer_codeowner = require("helpers.get-buffer-codeowner")
  local codeowner = get_buffer_codeowner(buf_name)

  if not codeowner then
    vim.notify("No codeowner found for: " .. vim.fn.fnamemodify(buf_name, ":~:."), vim.log.levels.INFO)
    return
  end

  vim.cmd("edit " .. vim.fn.fnameescape(codeowners_path))

  local function search_for_owner()
    vim.fn.cursor(1, 1)
    local search_owner = vim.fn.escape(codeowner, "/\\")
    if vim.fn.search(search_owner, "w") > 0 then
      vim.cmd("normal! zz")
      return true
    end
    return false
  end

  local function match_pattern(pattern, path)
    if pattern == "*" then
      return true
    end

    local clean = pattern:sub(1, 1) == "/" and pattern:sub(2) or pattern
    local regex = clean:gsub("%*%*", "\001")
    regex = regex:gsub("([%(%)%.%+%-%?%[%]%^%$%%])", "%%%1")
    regex = regex:gsub("%%%*", "[^/]*")
    regex = regex:gsub("\001", ".*")

    return clean:match("/$") and path:match("^" .. regex)
      or clean:match("/") and path:match("^" .. regex .. "/")
      or (path:match("[^/]+$") or path):match("^" .. regex .. "$")
  end

  local function search_for_pattern()
    vim.fn.cursor(1, 1)
    local line_num = 1
    for line in io.lines(codeowners_path) do
      if not vim.startswith(line, "#") and line ~= "" then
        local pattern, candidate = line:match("^(%S+)%s+(%S+)")
        if pattern and candidate == codeowner and match_pattern(pattern, relative_path) then
          vim.fn.cursor(line_num, 1)
          vim.cmd("normal! zz")
          return true
        end
      end
      line_num = line_num + 1
    end
    return false
  end

  if not search_for_pattern() then
    search_for_owner()
  end
end, { desc = "Open CODEOWNERS file at matching rule" })

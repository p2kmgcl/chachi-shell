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

return function(file_path)
  if not (file_path and vim.uv.fs_stat(file_path)) then
    return
  end

  local github_dir = vim.fs.find(".github", {
    path = file_path,
    type = "directory",
    upward = true,
    limit = 1,
  })[1]
  if not github_dir then
    return
  end

  local codeowners_path = vim.fs.joinpath(github_dir, "CODEOWNERS")
  if not vim.uv.fs_stat(codeowners_path) then
    return
  end

  local relative_path = file_path:sub(#github_dir:match("(.*)/%.github$") + 2)
  local owner

  for line in io.lines(codeowners_path) do
    if not vim.startswith(line, "#") and line ~= "" then
      local pattern, candidate = line:match("^(%S+)%s+(%S+)")
      if pattern and candidate and match_pattern(pattern, relative_path) then
        owner = candidate
      end
    end
  end

  return owner
end

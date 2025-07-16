return function(file_path)
  local results = {}
  local modules = {}

  local lua_path = vim.fn.stdpath("config") .. "/lua"
  local file_parts = vim.split(file_path, "/", { plain = true })
  local file_name = file_parts[#file_parts]
  local file_list = vim.fs.find(file_name, { type = "file", limit = math.huge, path = lua_path })

  for _, file in ipairs(file_list) do
    local module = file:match("lua/(.+)/" .. vim.pesc(file_path) .. "$")
    if module then
      local result = assert(loadfile(file))()
      table.insert(results, result)
      table.insert(modules, module)
    end
  end

  assert(#modules > 0, "No modules found for pattern " .. file_path)
  return results
end

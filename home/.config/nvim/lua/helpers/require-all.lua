return function(dir)
  local full_path = vim.fn.stdpath("config") .. "/lua/" .. dir
  local files = vim.fn.readdir(full_path)
  local required_files = {}

  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      local module = dir .. "." .. file:sub(1, -5)
      require(module)
      table.insert(required_files, module)
    end
  end

  assert(#required_files > 0, "No modules found in dir" .. dir)
end

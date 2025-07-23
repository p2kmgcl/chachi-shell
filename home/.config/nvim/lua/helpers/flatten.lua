return function(nested)
  local flat = {}
  for _, sublist in ipairs(nested) do
    for key, value in pairs(sublist) do
      if type(key) == "number" then
        table.insert(flat, value)
      else
        flat[key] = value
      end
    end
  end
  return flat
end

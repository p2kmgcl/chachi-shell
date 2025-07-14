return function(nested)
  local flat = {}
  for _, sublist in ipairs(nested) do
    for _, value in ipairs(sublist) do
      table.insert(flat, value)
    end
  end
  return flat
end

-- Get the package/module name for the current file
return function(file_path)
  if file_path == "" then
    return ""
  end

  -- Check if it's a terminal buffer
  if vim.bo.buftype == "terminal" then
    return ""
  end

  -- Find the closest config file
  local find_closest_config = require("helpers.find-closest-config")
  local closest = find_closest_config(file_path)

  if not closest then
    -- Final fallback to directory name
    local parent_dir = vim.fn.fnamemodify(file_path, ":h:t")
    if parent_dir ~= "." and parent_dir ~= "" then
      return parent_dir
    end
    return ""
  end

  -- Helper function to get directory name as fallback
  local function get_dir_name(config_file)
    local package_dir = vim.fn.fnamemodify(config_file, ":h")
    return vim.fn.fnamemodify(package_dir, ":t")
  end

  -- Parse name based on config type
  local config_file = closest.file
  local config_type = closest.type

  -- JSON-based configs (package.json, composer.json, deno.json)
  if config_type == "node" or config_type == "deno" or config_type == "php" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local json_str = table.concat(content, "\n")
      local name_match = string.match(json_str, '"name"%s*:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- TOML-based configs (Cargo.toml, pyproject.toml, bunfig.toml)
  if config_type == "rust" or config_type == "python-pyproject" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local toml_str = table.concat(content, "\n")
      local name_match = string.match(toml_str, "name%s*=%s*[\"']([^\"']+)[\"']")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- Go modules
  if config_type == "go" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local mod_str = table.concat(content, "\n")
      local name_match = string.match(mod_str, "module%s+([^\n\r%s]+)")
      if name_match then
        return vim.fn.fnamemodify(name_match:gsub("%s+$", ""), ":t")
      end
    end
    return get_dir_name(config_file)
  end

  -- Maven (pom.xml)
  if config_type == "java-maven" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local xml_str = table.concat(content, "\n")
      local name_match = string.match(xml_str, "<artifactId>([^<]+)</artifactId>")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- YAML-based configs (pubspec.yaml, shard.yml)
  if config_type == "dart" or config_type == "crystal" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local yaml_str = table.concat(content, "\n")
      local name_match = string.match(yaml_str, "name:%s*([^\n\r]+)")
      if name_match then
        return name_match:gsub("^%s*", ""):gsub("%s*$", "")
      end
    end
    return get_dir_name(config_file)
  end

  -- Swift Package.swift
  if config_type == "swift" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local swift_str = table.concat(content, "\n")
      local name_match = string.match(swift_str, 'name:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- Elixir mix.exs
  if config_type == "elixir" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local elixir_str = table.concat(content, "\n")
      local name_match = string.match(elixir_str, "app:%s*:([^,\n\r%s]+)")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- Clojure project.clj
  if config_type == "clojure-lein" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local clj_str = table.concat(content, "\n")
      local name_match = string.match(clj_str, "%(defproject%s+([^%s]+)")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- Bazel workspace
  if config_type == "bazel-workspace" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local workspace_str = table.concat(content, "\n")
      local name_match = string.match(workspace_str, "workspace%s*%(.-name%s*=%s*[\"']([^\"']+)[\"']")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(config_file)
  end

  -- Docker Compose
  if config_type == "docker-compose" then
    local ok, content = pcall(vim.fn.readfile, config_file)
    if ok and #content > 0 then
      local compose_str = table.concat(content, "\n")
      -- Try to find project name or first service name
      local project_match = string.match(compose_str, "name:%s*([^\n\r]+)")
      if project_match then
        return project_match:gsub("^%s*", ""):gsub("%s*$", "")
      end

      -- Fallback to first service name
      local service_match = string.match(compose_str, "services:%s*\n%s*([^:\n\r]+):")
      if service_match then
        return service_match:gsub("^%s*", ""):gsub("%s*$", "")
      end
    end
    return get_dir_name(config_file)
  end

  -- File-based naming (*.csproj, *.gemspec, *.cabal, etc.)
  if
    config_type == "csharp-project"
    or config_type == "ruby-gemspec"
    or config_type == "haskell-cabal"
    or config_type == "lua"
    or config_type == "nim"
  then
    return vim.fn.fnamemodify(config_file, ":t:r")
  end

  -- Default fallback to directory name
  return get_dir_name(config_file)
end

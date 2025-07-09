-- Get the package/module name for the current file
return function(file_path)
  if file_path == "" then
    return ""
  end

  local file_dir = vim.fn.fnamemodify(file_path, ":h")

  -- Helper function to get directory name as fallback
  local function get_dir_name(config_file)
    local package_dir = vim.fn.fnamemodify(config_file, ":h")
    return vim.fn.fnamemodify(package_dir, ":t")
  end

  -- JavaScript/TypeScript ecosystems
  -- Deno
  local deno_json = vim.fn.findfile("deno.json", file_dir .. ";")
  if deno_json == "" then
    deno_json = vim.fn.findfile("deno.jsonc", file_dir .. ";")
  end
  if deno_json ~= "" then
    local ok, content = pcall(vim.fn.readfile, deno_json)
    if ok and #content > 0 then
      local json_str = table.concat(content, "\n")
      local name_match = string.match(json_str, '"name"%s*:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(deno_json)
  end

  -- Bun
  local bunfig_toml = vim.fn.findfile("bunfig.toml", file_dir .. ";")
  if bunfig_toml ~= "" then
    return get_dir_name(bunfig_toml)
  end
  local bun_lockb = vim.fn.findfile("bun.lockb", file_dir .. ";")
  if bun_lockb ~= "" then
    return get_dir_name(bun_lockb)
  end

  -- Package.json (Node.js/npm/yarn/pnpm)
  local package_json = vim.fn.findfile("package.json", file_dir .. ";")
  if package_json ~= "" then
    local ok, content = pcall(vim.fn.readfile, package_json)
    if ok and #content > 0 then
      local json_str = table.concat(content, "\n")
      local name_match = string.match(json_str, '"name"%s*:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(package_json)
  end

  -- Rust
  local cargo_toml = vim.fn.findfile("Cargo.toml", file_dir .. ";")
  if cargo_toml ~= "" then
    local ok, content = pcall(vim.fn.readfile, cargo_toml)
    if ok and #content > 0 then
      local toml_str = table.concat(content, "\n")
      local name_match = string.match(toml_str, "name%s*=%s*[\"']([^\"']+)[\"']")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(cargo_toml)
  end

  -- Python
  local pyproject_toml = vim.fn.findfile("pyproject.toml", file_dir .. ";")
  if pyproject_toml ~= "" then
    local ok, content = pcall(vim.fn.readfile, pyproject_toml)
    if ok and #content > 0 then
      local toml_str = table.concat(content, "\n")
      local name_match = string.match(toml_str, "name%s*=%s*[\"']([^\"']+)[\"']")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(pyproject_toml)
  end

  local pipfile = vim.fn.findfile("Pipfile", file_dir .. ";")
  if pipfile ~= "" then
    return get_dir_name(pipfile)
  end

  local setup_py = vim.fn.findfile("setup.py", file_dir .. ";")
  if setup_py ~= "" then
    return get_dir_name(setup_py)
  end

  -- Go
  local go_mod = vim.fn.findfile("go.mod", file_dir .. ";")
  if go_mod ~= "" then
    local ok, content = pcall(vim.fn.readfile, go_mod)
    if ok and #content > 0 then
      local mod_str = table.concat(content, "\n")
      local name_match = string.match(mod_str, "module%s+([^\n\r%s]+)")
      if name_match then
        return vim.fn.fnamemodify(name_match:gsub("%s+$", ""), ":t")
      end
    end
    return get_dir_name(go_mod)
  end

  -- Java/JVM
  local pom_xml = vim.fn.findfile("pom.xml", file_dir .. ";")
  if pom_xml ~= "" then
    local ok, content = pcall(vim.fn.readfile, pom_xml)
    if ok and #content > 0 then
      local xml_str = table.concat(content, "\n")
      local name_match = string.match(xml_str, "<artifactId>([^<]+)</artifactId>")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(pom_xml)
  end

  local build_gradle = vim.fn.findfile("build.gradle", file_dir .. ";")
  if build_gradle == "" then
    build_gradle = vim.fn.findfile("build.gradle.kts", file_dir .. ";")
  end
  if build_gradle ~= "" then
    return get_dir_name(build_gradle)
  end

  local build_sbt = vim.fn.findfile("build.sbt", file_dir .. ";")
  if build_sbt ~= "" then
    return get_dir_name(build_sbt)
  end

  -- C#/.NET
  local csproj = vim.fn.glob(file_dir .. "/*.csproj")
  if csproj ~= "" then
    return vim.fn.fnamemodify(csproj, ":t:r")
  end

  -- PHP
  local composer_json = vim.fn.findfile("composer.json", file_dir .. ";")
  if composer_json ~= "" then
    local ok, content = pcall(vim.fn.readfile, composer_json)
    if ok and #content > 0 then
      local json_str = table.concat(content, "\n")
      local name_match = string.match(json_str, '"name"%s*:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(composer_json)
  end

  -- Ruby
  local gemfile = vim.fn.findfile("Gemfile", file_dir .. ";")
  if gemfile ~= "" then
    return get_dir_name(gemfile)
  end

  local gemspec = vim.fn.glob(file_dir .. "/*.gemspec")
  if gemspec ~= "" then
    return vim.fn.fnamemodify(gemspec, ":t:r")
  end

  -- Dart/Flutter
  local pubspec_yaml = vim.fn.findfile("pubspec.yaml", file_dir .. ";")
  if pubspec_yaml ~= "" then
    local ok, content = pcall(vim.fn.readfile, pubspec_yaml)
    if ok and #content > 0 then
      local yaml_str = table.concat(content, "\n")
      local name_match = string.match(yaml_str, "name:%s*([^\n\r]+)")
      if name_match then
        return name_match:gsub("^%s*", ""):gsub("%s*$", "")
      end
    end
    return get_dir_name(pubspec_yaml)
  end

  -- Swift
  local package_swift = vim.fn.findfile("Package.swift", file_dir .. ";")
  if package_swift ~= "" then
    local ok, content = pcall(vim.fn.readfile, package_swift)
    if ok and #content > 0 then
      local swift_str = table.concat(content, "\n")
      local name_match = string.match(swift_str, 'name:%s*"([^"]+)"')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(package_swift)
  end

  -- Elixir
  local mix_exs = vim.fn.findfile("mix.exs", file_dir .. ";")
  if mix_exs ~= "" then
    local ok, content = pcall(vim.fn.readfile, mix_exs)
    if ok and #content > 0 then
      local elixir_str = table.concat(content, "\n")
      local name_match = string.match(elixir_str, 'app:%s*:([^,\n\r%s]+)')
      if name_match then
        return name_match
      end
    end
    return get_dir_name(mix_exs)
  end

  -- Clojure
  local project_clj = vim.fn.findfile("project.clj", file_dir .. ";")
  if project_clj ~= "" then
    local ok, content = pcall(vim.fn.readfile, project_clj)
    if ok and #content > 0 then
      local clj_str = table.concat(content, "\n")
      local name_match = string.match(clj_str, "%(defproject%s+([^%s]+)")
      if name_match then
        return name_match
      end
    end
    return get_dir_name(project_clj)
  end

  -- Haskell
  local cabal_file = vim.fn.glob(file_dir .. "/*.cabal")
  if cabal_file ~= "" then
    return vim.fn.fnamemodify(cabal_file, ":t:r")
  end

  -- Lua
  local rockspec = vim.fn.glob(file_dir .. "/*.rockspec")
  if rockspec ~= "" then
    return vim.fn.fnamemodify(rockspec, ":t:r")
  end

  -- Nim
  local nimble_file = vim.fn.glob(file_dir .. "/*.nimble")
  if nimble_file ~= "" then
    return vim.fn.fnamemodify(nimble_file, ":t:r")
  end

  -- Crystal
  local shard_yml = vim.fn.findfile("shard.yml", file_dir .. ";")
  if shard_yml ~= "" then
    local ok, content = pcall(vim.fn.readfile, shard_yml)
    if ok and #content > 0 then
      local yaml_str = table.concat(content, "\n")
      local name_match = string.match(yaml_str, "name:%s*([^\n\r]+)")
      if name_match then
        return name_match:gsub("^%s*", ""):gsub("%s*$", "")
      end
    end
    return get_dir_name(shard_yml)
  end

  -- For other files, show the immediate parent directory
  local parent_dir = vim.fn.fnamemodify(file_path, ":h:t")
  if parent_dir ~= "." and parent_dir ~= "" then
    return parent_dir
  end

  return ""
end

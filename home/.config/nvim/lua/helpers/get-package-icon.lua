-- Get the appropriate icon for the project type
return function(file_path)
  if file_path == "" then
    return ""
  end

  local file_dir = vim.fn.fnamemodify(file_path, ":h")

  -- JavaScript/TypeScript ecosystems
  if vim.fn.findfile("deno.json", file_dir .. ";") ~= "" or vim.fn.findfile("deno.jsonc", file_dir .. ";") ~= "" then
    return "🦕"
  end
  if vim.fn.findfile("bun.lockb", file_dir .. ";") ~= "" or vim.fn.findfile("bunfig.toml", file_dir .. ";") ~= "" then
    return "🥖"
  end
  if vim.fn.findfile("yarn.lock", file_dir .. ";") ~= "" or vim.fn.findfile(".yarnrc", file_dir .. ";") ~= "" then
    return "🧶"
  end
  if vim.fn.findfile("pnpm-lock.yaml", file_dir .. ";") ~= "" or vim.fn.findfile(".pnpmrc", file_dir .. ";") ~= "" then
    return "📦"
  end
  if vim.fn.findfile("package.json", file_dir .. ";") ~= "" then
    return "📦"
  end

  -- Rust
  if vim.fn.findfile("Cargo.toml", file_dir .. ";") ~= "" then
    return "🦀"
  end

  -- Python
  if vim.fn.findfile("pyproject.toml", file_dir .. ";") ~= "" then
    return "🐍"
  end
  if vim.fn.findfile("Pipfile", file_dir .. ";") ~= "" then
    return "🐍"
  end
  if vim.fn.findfile("poetry.lock", file_dir .. ";") ~= "" then
    return "🐍"
  end
  if vim.fn.findfile("requirements.txt", file_dir .. ";") ~= "" then
    return "🐍"
  end
  if vim.fn.findfile("conda.yaml", file_dir .. ";") ~= "" or vim.fn.findfile("environment.yml", file_dir .. ";") ~= "" then
    return "🐍"
  end
  if vim.fn.findfile("setup.py", file_dir .. ";") ~= "" then
    return "🐍"
  end

  -- Go
  if vim.fn.findfile("go.mod", file_dir .. ";") ~= "" then
    return "🐹"
  end

  -- Java/JVM
  if vim.fn.findfile("pom.xml", file_dir .. ";") ~= "" then
    return "☕"
  end
  if vim.fn.findfile("build.gradle", file_dir .. ";") ~= "" or vim.fn.findfile("build.gradle.kts", file_dir .. ";") ~= "" then
    return "☕"
  end
  if vim.fn.findfile("build.sbt", file_dir .. ";") ~= "" then
    return "☕"
  end

  -- C#/.NET
  if vim.fn.glob(file_dir .. "/*.csproj") ~= "" or vim.fn.glob(file_dir .. "/*.sln") ~= "" then
    return "🔷"
  end
  if vim.fn.findfile("project.json", file_dir .. ";") ~= "" then
    return "🔷"
  end

  -- PHP
  if vim.fn.findfile("composer.json", file_dir .. ";") ~= "" then
    return "🐘"
  end

  -- Ruby
  if vim.fn.findfile("Gemfile", file_dir .. ";") ~= "" then
    return "💎"
  end
  if vim.fn.glob(file_dir .. "/*.gemspec") ~= "" then
    return "💎"
  end

  -- Dart/Flutter
  if vim.fn.findfile("pubspec.yaml", file_dir .. ";") ~= "" then
    return "🎯"
  end

  -- Swift
  if vim.fn.findfile("Package.swift", file_dir .. ";") ~= "" then
    return "🦉"
  end
  if vim.fn.glob(file_dir .. "/*.xcodeproj") ~= "" then
    return "🦉"
  end

  -- Elixir
  if vim.fn.findfile("mix.exs", file_dir .. ";") ~= "" then
    return "💜"
  end

  -- Clojure
  if vim.fn.findfile("project.clj", file_dir .. ";") ~= "" then
    return "🟢"
  end
  if vim.fn.findfile("deps.edn", file_dir .. ";") ~= "" then
    return "🟢"
  end

  -- Haskell
  if vim.fn.glob(file_dir .. "/*.cabal") ~= "" then
    return "🎭"
  end
  if vim.fn.findfile("stack.yaml", file_dir .. ";") ~= "" then
    return "🎭"
  end

  -- Lua
  if vim.fn.glob(file_dir .. "/*.rockspec") ~= "" then
    return "🌙"
  end

  -- Zig
  if vim.fn.findfile("build.zig", file_dir .. ";") ~= "" then
    return "⚡"
  end

  -- Nim
  if vim.fn.glob(file_dir .. "/*.nimble") ~= "" then
    return "👑"
  end

  -- Crystal
  if vim.fn.findfile("shard.yml", file_dir .. ";") ~= "" then
    return "💎"
  end

  -- OCaml
  if vim.fn.findfile("dune-project", file_dir .. ";") ~= "" then
    return "🐪"
  end

  -- Erlang
  if vim.fn.findfile("rebar.config", file_dir .. ";") ~= "" then
    return "📡"
  end

  -- Docker
  if vim.fn.findfile("Dockerfile", file_dir .. ";") ~= "" then
    return "🐳"
  end

  -- Bazel (check first for more specific icon)
  if vim.fn.findfile("BUILD", file_dir .. ";") ~= "" or 
     vim.fn.findfile("BUILD.bazel", file_dir .. ";") ~= "" or
     vim.fn.findfile("WORKSPACE", file_dir .. ";") ~= "" or
     vim.fn.findfile("WORKSPACE.bazel", file_dir .. ";") ~= "" or
     vim.fn.findfile(".bazelrc", file_dir .. ";") ~= "" then
    return "🏗️"
  end

  -- Other build systems
  if vim.fn.findfile("CMakeLists.txt", file_dir .. ";") ~= "" then
    return "🔧"
  end
  if vim.fn.findfile("meson.build", file_dir .. ";") ~= "" then
    return "🔧"
  end
  if vim.fn.findfile("Makefile", file_dir .. ";") ~= "" then
    return "🔧"
  end

  -- For other files, show folder icon
  local parent_dir = vim.fn.fnamemodify(file_path, ":h:t")
  if parent_dir ~= "." and parent_dir ~= "" then
    return "📁"
  end

  return ""
end
-- Get config info for a specific directory
return function(directory)
  -- Define all possible config files with their types
  local configs = {
    -- JavaScript/TypeScript ecosystems (order by specificity)
    { files = { "deno.json", "deno.jsonc" }, type = "deno" },
    { files = { "bun.lockb", "bunfig.toml" }, type = "bun" },
    { files = { "yarn.lock", ".yarnrc" }, type = "yarn" },
    { files = { "pnpm-lock.yaml", ".pnpmrc" }, type = "pnpm" },
    { files = { "package.json" }, type = "node" },

    -- Other languages
    { files = { "Cargo.toml" }, type = "rust" },
    { files = { "pyproject.toml" }, type = "python-pyproject" },
    { files = { "Pipfile" }, type = "python-pipfile" },
    { files = { "poetry.lock" }, type = "python-poetry" },
    { files = { "requirements.txt" }, type = "python-requirements" },
    { files = { "conda.yaml", "environment.yml" }, type = "python-conda" },
    { files = { "setup.py" }, type = "python-setup" },
    { files = { "go.mod" }, type = "go" },
    { files = { "pom.xml" }, type = "java-maven" },
    { files = { "build.gradle", "build.gradle.kts" }, type = "java-gradle" },
    { files = { "build.sbt" }, type = "scala-sbt" },
    { files = { "composer.json" }, type = "php" },
    { files = { "Gemfile" }, type = "ruby-gemfile" },
    { files = { "pubspec.yaml" }, type = "dart" },
    { files = { "Package.swift" }, type = "swift" },
    { files = { "mix.exs" }, type = "elixir" },
    { files = { "project.clj" }, type = "clojure-lein" },
    { files = { "deps.edn" }, type = "clojure-deps" },
    { files = { "stack.yaml" }, type = "haskell-stack" },
    { files = { "build.zig" }, type = "zig" },
    { files = { "shard.yml" }, type = "crystal" },
    { files = { "dune-project" }, type = "ocaml" },
    { files = { "rebar.config" }, type = "erlang" },
    { files = { "Dockerfile" }, type = "docker" },
    { files = { "docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml" }, type = "docker-compose" },

    -- Bazel
    { files = { "WORKSPACE", "WORKSPACE.bazel" }, type = "bazel-workspace" },
    { files = { "BUILD", "BUILD.bazel" }, type = "bazel-build" },
    { files = { ".bazelrc" }, type = "bazel-config" },

    -- Other build systems
    { files = { "CMakeLists.txt" }, type = "cmake" },
    { files = { "meson.build" }, type = "meson" },
    { files = { "Makefile" }, type = "make" },
  }

  -- Check for config files in directory
  for _, config in ipairs(configs) do
    for _, filename in ipairs(config.files) do
      local config_path = directory .. "/" .. filename
      if vim.fn.filereadable(config_path) == 1 then
        return {
          type = config.type,
          file = config_path,
        }
      end
    end
  end

  -- Check for glob patterns
  local patterns = {
    { pattern = "/*.csproj", type = "csharp-project" },
    { pattern = "/*.sln", type = "csharp-solution" },
    { pattern = "/*.cabal", type = "haskell-cabal" },
    { pattern = "/*.rockspec", type = "lua" },
    { pattern = "/*.nimble", type = "nim" },
    { pattern = "/*.gemspec", type = "ruby-gemspec" },
    { pattern = "/*.xcodeproj", type = "swift-xcode" },
  }

  for _, p in ipairs(patterns) do
    local found = vim.fn.glob(directory .. p.pattern)
    if found ~= "" then
      return {
        type = p.type,
        file = found,
      }
    end
  end

  return nil
end
-- Get the appropriate icon for the project type
return function(file_path)
  if file_path == "" then
    return ""
  end

  -- Check if it's a terminal buffer
  if vim.bo.buftype == "terminal" then
    return "🖥️"
  end

  -- Find the closest config file
  local find_closest_config = require("helpers.find-closest-config")
  local closest = find_closest_config(file_path)

  if not closest then
    -- Final fallback to folder icon
    local parent_dir = vim.fn.fnamemodify(file_path, ":h:t")
    if parent_dir ~= "." and parent_dir ~= "" then
      return "📁"
    end
    return ""
  end

  -- Map config types to icons
  local icons = {
    -- JavaScript/TypeScript ecosystems
    deno = "🦕",
    bun = "🥖",
    yarn = "🧶",
    pnpm = "📦",
    node = "📦",

    -- Other languages
    rust = "🦀",
    ["python-pyproject"] = "🐍",
    ["python-pipfile"] = "🐍",
    ["python-poetry"] = "🐍",
    ["python-requirements"] = "🐍",
    ["python-conda"] = "🐍",
    ["python-setup"] = "🐍",
    go = "🐹",
    ["java-maven"] = "☕",
    ["java-gradle"] = "☕",
    ["scala-sbt"] = "☕",
    php = "🐘",
    ["ruby-gemfile"] = "💎",
    ["ruby-gemspec"] = "💎",
    dart = "🎯",
    swift = "🦉",
    ["swift-xcode"] = "🦉",
    elixir = "💜",
    ["clojure-lein"] = "🟢",
    ["clojure-deps"] = "🟢",
    ["haskell-stack"] = "🎭",
    ["haskell-cabal"] = "🎭",
    zig = "⚡",
    nim = "👑",
    crystal = "💎",
    lua = "🌙",
    ocaml = "🐪",
    erlang = "📡",
    docker = "🐳",
    ["docker-compose"] = "🐙",

    -- Bazel
    ["bazel-workspace"] = "🏗️",
    ["bazel-build"] = "🏗️",
    ["bazel-config"] = "🏗️",

    -- C#/.NET
    ["csharp-project"] = "🔷",
    ["csharp-solution"] = "🔷",

    -- Other build systems
    cmake = "🔧",
    meson = "🔧",
    make = "🔧",
  }

  return icons[closest.type] or "📁"
end

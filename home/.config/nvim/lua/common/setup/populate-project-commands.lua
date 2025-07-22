local function get_project_commands()
  local get_project_root = require("common.helpers.get-project-root")
  local get_dir_config = require("common.helpers.get-dir-config")
  local current_file = vim.fn.expand("%:p")
  local project_root = get_project_root(current_file)
  local config = get_dir_config(project_root)

  if not config then
    return {}
  end

  local commands = {}

  if config.type == "node" or config.type == "yarn" or config.type == "pnpm" or config.type == "bun" then
    local manager = config.type == "yarn" and "yarn"
      or config.type == "pnpm" and "pnpm"
      or config.type == "bun" and "bun"
      or "npm"

    local common_scripts = {
      "build",
      "check",
      "clean",
      "deploy",
      "dev",
      "format",
      "install",
      "lint",
      "preview",
      "serve",
      "start",
      "test",
      "typecheck",
      "update",
      "watch",
    }

    for _, script in ipairs(common_scripts) do
      local cmd = manager == "yarn" and ("yarn " .. script)
        or manager == "npm" and ("npm run " .. script)
        or (manager .. " run " .. script)

      table.insert(commands, { name = script, cmd = cmd, cwd = project_root })
    end
  elseif config.type == "rust" then
    commands = {
      { name = "build", cmd = "cargo build", cwd = project_root },
      { name = "check", cmd = "cargo check", cwd = project_root },
      { name = "clippy", cmd = "cargo clippy", cwd = project_root },
      { name = "fmt", cmd = "cargo fmt", cwd = project_root },
      { name = "run", cmd = "cargo run", cwd = project_root },
      { name = "test", cmd = "cargo test", cwd = project_root },
    }
  elseif config.type == "go" then
    commands = {
      { name = "build", cmd = "go build", cwd = project_root },
      { name = "fmt", cmd = "go fmt ./...", cwd = project_root },
      { name = "mod-tidy", cmd = "go mod tidy", cwd = project_root },
      { name = "run", cmd = "go run .", cwd = project_root },
      { name = "test", cmd = "go test ./...", cwd = project_root },
      { name = "vet", cmd = "go vet ./...", cwd = project_root },
    }
  elseif config.type:match("^python") then
    if config.type == "python-pyproject" then
      commands = {
        { name = "format", cmd = "python -m black .", cwd = project_root },
        { name = "install", cmd = "pip install -e .", cwd = project_root },
        { name = "lint", cmd = "python -m flake8", cwd = project_root },
        { name = "test", cmd = "python -m pytest", cwd = project_root },
      }
    else
      commands = {
        { name = "install", cmd = "pip install -r requirements.txt", cwd = project_root },
        { name = "run", cmd = "python main.py", cwd = project_root },
        { name = "test", cmd = "python -m pytest", cwd = project_root },
      }
    end
  elseif config.type == "java-maven" then
    commands = {
      { name = "clean", cmd = "mvn clean", cwd = project_root },
      { name = "compile", cmd = "mvn compile", cwd = project_root },
      { name = "install", cmd = "mvn install", cwd = project_root },
      { name = "package", cmd = "mvn package", cwd = project_root },
      { name = "test", cmd = "mvn test", cwd = project_root },
    }
  elseif config.type == "java-gradle" then
    commands = {
      { name = "build", cmd = "./gradlew build", cwd = project_root },
      { name = "clean", cmd = "./gradlew clean", cwd = project_root },
      { name = "run", cmd = "./gradlew run", cwd = project_root },
      { name = "test", cmd = "./gradlew test", cwd = project_root },
    }
  elseif config.type == "docker-compose" then
    commands = {
      { name = "build", cmd = "docker-compose build", cwd = project_root },
      { name = "down", cmd = "docker-compose down", cwd = project_root },
      { name = "logs", cmd = "docker-compose logs -f", cwd = project_root },
      { name = "restart", cmd = "docker-compose restart", cwd = project_root },
      { name = "up", cmd = "docker-compose up -d", cwd = project_root },
    }
  elseif config.type == "make" then
    commands = {
      { name = "build", cmd = "make", cwd = project_root },
      { name = "clean", cmd = "make clean", cwd = project_root },
      { name = "install", cmd = "make install", cwd = project_root },
      { name = "test", cmd = "make test", cwd = project_root },
    }
  end

  return commands
end

local function run_command(name, cmd, cwd)
  vim.cmd.enew()
  vim.fn.jobstart(cmd, {
    term = true,
    cwd = cwd,
  })
  vim.api.nvim_buf_set_name(0, name)
  vim.cmd.startinsert()
end

local function populate_project_commands()
  local commands = get_project_commands()
  if #commands == 0 then
    return
  end

  for _, mapping in ipairs(vim.api.nvim_get_keymap("n")) do
    if mapping.lhs and mapping.lhs:match("^<leader>x") and #mapping.lhs > 9 then
      pcall(vim.keymap.del, "n", mapping.lhs)
    end
  end

  local keys = "abcdefghijklmnopqrstuvwxyz1234567890"
  local which_key_spec = {}

  for i, command in ipairs(commands) do
    if i <= #keys then
      local key = keys:sub(i, i)
      local keymap = "<leader>x" .. key

      vim.keymap.set("n", keymap, function()
        run_command(command.name, command.cmd, command.cwd)
      end, {
        desc = command.name,
        silent = true,
      })

      table.insert(which_key_spec, {
        keymap,
        desc = command.name,
      })
    end
  end

  local ok, wk = pcall(require, "which-key")
  if ok then
    table.insert(which_key_spec, 1, { "<leader>x", group = "Run" })
    wk.add(which_key_spec)
  end
end

local augroup = vim.api.nvim_create_augroup("ProjectCommands", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    if vim.b.project_commands_loaded then
      return
    end

    if vim.bo.buftype ~= "" or vim.bo.filetype == "" then
      return
    end

    vim.b.project_commands_loaded = true
    populate_project_commands()
  end,
})

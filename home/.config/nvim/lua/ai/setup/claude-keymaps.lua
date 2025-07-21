local function get_editor_context()
  local context = {}

  -- Current buffer info
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  context.current_buffer = {
    id = current_buf,
    name = vim.api.nvim_buf_get_name(current_buf),
    filetype = vim.bo[current_buf].filetype,
    modified = vim.bo[current_buf].modified,
    line_count = vim.api.nvim_buf_line_count(current_buf),
  }

  -- Cursor position
  local cursor = vim.api.nvim_win_get_cursor(current_win)
  context.cursor_position = {
    line = cursor[1],
    column = cursor[2] + 1, -- Convert to 1-based
  }

  -- Open buffers
  context.open_buffers = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name ~= "" then
        table.insert(context.open_buffers, {
          id = buf,
          name = buf_name,
          filetype = vim.bo[buf].filetype,
          modified = vim.bo[buf].modified,
        })
      end
    end
  end

  -- LSP information
  context.lsp_active_clients = {}
  local clients = vim.lsp.get_active_clients({ bufnr = current_buf })
  for _, client in ipairs(clients) do
    table.insert(context.lsp_active_clients, {
      name = client.name,
      id = client.id,
      root_dir = client.config.root_dir,
    })
  end

  -- Diagnostics
  context.diagnostics = {
    errors = #vim.diagnostic.get(current_buf, { severity = vim.diagnostic.severity.ERROR }),
    warnings = #vim.diagnostic.get(current_buf, { severity = vim.diagnostic.severity.WARN }),
    info = #vim.diagnostic.get(current_buf, { severity = vim.diagnostic.severity.INFO }),
    hints = #vim.diagnostic.get(current_buf, { severity = vim.diagnostic.severity.HINT }),
  }

  -- Working directory
  context.cwd = vim.fn.getcwd()

  -- Visual selection (check for active visual mode or recent selection marks)
  local mode = vim.fn.mode()
  local start_pos, end_pos
  if string.match(mode, "[vV\022]") then
    start_pos = vim.fn.getpos(".")
    end_pos = vim.fn.getpos("v")
    if start_pos[2] > end_pos[2] or (start_pos[2] == end_pos[2] and start_pos[3] > end_pos[3]) then
      start_pos, end_pos = end_pos, start_pos
    end
  else
    start_pos = vim.fn.getpos("'<")
    end_pos = vim.fn.getpos("'>")
  end
  if start_pos[2] > 0 and end_pos[2] > 0 and (start_pos[2] ~= end_pos[2] or start_pos[3] ~= end_pos[3]) then
    context.selection = {
      start_line = start_pos[2],
      start_col = start_pos[3],
      end_line = end_pos[2],
      end_col = end_pos[3],
    }
  else
    context.selection = {
      start_line = 0,
      start_col = 0,
      end_line = 0,
      end_col = 0,
    }
  end

  return context
end

local function create_context_file(context)
  local temp_file = vim.fn.tempname() .. "_nvim_context.json"
  local json_content = vim.fn.json_encode(context)
  vim.fn.writefile({ json_content }, temp_file)
  return temp_file
end

vim.keymap.set({ "n", "v" }, "<leader>.", function()
  vim.ui.input({ prompt = "Enter your text: " }, function(prompt)
    if prompt then
      local context = get_editor_context()
      local context_file = create_context_file(context)

      local prompt_prefix = table.concat({
        "You are running from NeoVIM on a splitted window.",
        "All existing editor information can be accessed from NVIM_CONTEXT_FILE environment variable.",
        "Use that information to enhance your response. The context is provided via environment variable, not a file path.",
        "Active LSP servers are available in the context.",
        "Never spin a new LSP server if you are not able to connect.",
        "You can try reading editor files to get more context.",
        "When I refer to 'this', 'that', 'here', or similar contextual terms, I'm referring to:",
        "- The currently selected text (if any selection exists)",
        "- The current line/function/block where my cursor is positioned",
        "- The current file being edited",
        "Use the context information (NVIM_CONTEXT_FILE env variable) to understand what I'm referring to.",
        "Here is my prompt:",
      }, " ")

      local allowed_tools = {
        "Bash(echo:*)",
        "Bash(nvim:*)",
        "Bash(lua:*)",
      }

      local tools_str = ""
      for i, tool in ipairs(allowed_tools) do
        tools_str = tools_str .. "'" .. tool .. "'"
        if i < #allowed_tools then
          tools_str = tools_str .. " "
        end
      end

      local shell_cmd = string.format(
        'NVIM_CONTEXT_FILE="%s" claude --add-dir "%s" --allowedTools %s -- "%s"',
        context_file,
        vim.fs.dirname(context_file),
        tools_str,
        prompt_prefix .. " " .. prompt
      )

      print("Shell command: " .. shell_cmd)
      vim.cmd.vsplit()
      vim.cmd.enew()
      vim.fn.jobstart(shell_cmd, {
        term = true,
        on_exit = function()
          vim.api.nvim_buf_delete(0, { force = true })
        end,
      })
      vim.api.nvim_buf_set_name(0, "claude")
      vim.cmd.startinsert()
    end
  end)
end, { desc = "Claude with editor context" })

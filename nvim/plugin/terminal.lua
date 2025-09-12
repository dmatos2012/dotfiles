local TermCommand = {}

TermCommand.config = {
  commands_by_ft = {
    python = {
      "uv run {file}",
      "pytest",
      "black {file}",
      "ruff check {file}",
    },
    ocaml = {
      "dune exec {project_name} t.olox",
      "dune build",
      -- "dune test",
      -- "dune exec ./{project_name}.exe",
    },
  },
}

TermCommand.core = {}

---A robust function to find the job ID of the most recently used terminal.
function TermCommand.core.find_terminal_job_id()
  -- Get all windows in the current tab page.
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- Iterate through the windows in reverse order (from most to least recent).
  -- This is a reliable way to find the last-opened terminal.
  for i = #wins, 1, -1 do
    local win_id = wins[i]
    local buf_nr = vim.api.nvim_win_get_buf(win_id)

    -- Check if the window contains a valid terminal buffer.
    if vim.api.nvim_buf_is_valid(buf_nr) and vim.bo[buf_nr].buftype == 'terminal' then
      local job_id = vim.api.nvim_buf_get_var(buf_nr, 'terminal_job_id')

      -- Ensure the job ID is valid and that the job is still running.
      -- vim.fn.jobwait with a timeout of 0 returns -1 for running jobs.
      if job_id and job_id > 0 and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
        -- Found a valid, running terminal. Return its job ID.
        return job_id
      end
    end
  end

  -- If no suitable terminal was found after checking all windows.
  return nil
end

---Sends a command string to the active terminal to be executed.
function TermCommand.core.send_to_terminal(cmd)
  local term_job_id = TermCommand.core.find_terminal_job_id()

  if not term_job_id then
    vim.notify("No active terminal found.", vim.log.levels.WARN, { timeout = 2000 })
    return
  end

  vim.fn.chansend(term_job_id, cmd .. "\r")
  vim.notify("→ " .. cmd, vim.log.levels.INFO, { timeout = 1500 })
end

---Runs a command in a new, centered floating terminal window.
function TermCommand.core.execute_in_float(command)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  vim.fn.termopen(command, {
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, 100)
      else
        vim.notify("Command failed with exit code: " .. exit_code, vim.log.levels.WARN)
      end
    end,
  })

  vim.cmd('startinsert')
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = buf, silent = true })
  vim.keymap.set('t', 'q', [[<Cmd>close<CR>]], { buffer = buf, silent = true, desc = "Close terminal" })
end

-- ============================================================================
-- User Interface
-- ============================================================================

TermCommand.ui = {}

---Creates a beautiful floating command palette window
function TermCommand.ui.create_command_palette(commands, execution_fn)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Calculate dimensions for a nice looking palette
  local width = math.min(60, math.floor(vim.o.columns * 0.6))
  local height = math.min(#commands + 4, math.floor(vim.o.lines * 0.4))
  local row = math.floor((vim.o.lines - height) / 2) - 2
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create the floating window with professional styling
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Run Command ',
    title_pos = 'center',
  })

  -- Set buffer options
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'TermCommandPalette'

  -- Disable various options for clean look
  vim.wo[win].cursorline = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].wrap = false
  vim.wo[win].spell = false
  vim.wo[win].list = false
  vim.wo[win].signcolumn = 'no'

  -- Add content to buffer with nice formatting
  local lines = {}
  table.insert(lines, "") -- Empty line for padding
  for i, cmd in ipairs(commands) do
    table.insert(lines, string.format(" %d. %s", i, cmd))
  end
  table.insert(lines, "") -- Empty line
  table.insert(lines, " c. Type custom command")
  table.insert(lines, "") -- Empty line for padding

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Make buffer readonly
  vim.bo[buf].readonly = true
  vim.bo[buf].modifiable = false

  -- Set cursor to first command
  vim.api.nvim_win_set_cursor(win, { 2, 0 })

  -- Define keymaps for the palette
  local function close_palette()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function execute_selection()
    local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
    local selected_cmd = nil

    -- Determine what was selected based on cursor position
    if cursor_line >= 2 and cursor_line <= #commands + 1 then
      selected_cmd = commands[cursor_line - 1]
    elseif cursor_line == #commands + 3 then
      -- Custom command selected
      close_palette()
      vim.ui.input({
        prompt = "Enter custom command: ",
      }, function(custom_input)
        if custom_input and custom_input ~= "" then
          execution_fn(custom_input)
        end
      end)
      return
    end

    if selected_cmd then
      close_palette()
      execution_fn(selected_cmd)
    end
  end

  -- Set up keymaps
  local keymap_opts = { buffer = buf, silent = true, nowait = true }

  -- Close palette
  vim.keymap.set('n', '<Esc>', close_palette, keymap_opts)
  vim.keymap.set('n', 'q', close_palette, keymap_opts)

  -- Execute selection
  vim.keymap.set('n', '<CR>', execute_selection, keymap_opts)
  vim.keymap.set('n', '<Space>', execute_selection, keymap_opts)

  -- Navigation
  vim.keymap.set('n', 'j', function()
    local current_line = vim.api.nvim_win_get_cursor(win)[1]
    local max_line = #commands + 3
    if current_line < max_line then
      vim.api.nvim_win_set_cursor(win, { current_line + 1, 0 })
    end
  end, keymap_opts)

  vim.keymap.set('n', 'k', function()
    local current_line = vim.api.nvim_win_get_cursor(win)[1]
    if current_line > 2 then
      vim.api.nvim_win_set_cursor(win, { current_line - 1, 0 })
    end
  end, keymap_opts)

  -- Number key shortcuts
  for i = 1, math.min(9, #commands) do
    vim.keymap.set('n', tostring(i), function()
      close_palette()
      execution_fn(commands[i])
    end, keymap_opts)
  end

  -- Custom command shortcut
  vim.keymap.set('n', 'c', function()
    close_palette()
    vim.ui.input({
      prompt = "Enter custom command: ",
    }, function(custom_input)
      if custom_input and custom_input ~= "" then
        execution_fn(custom_input)
      end
    end)
  end, keymap_opts)

  return win
end

---Gets the OCaml/Dune project name by reading dune-project or falling back to directory name
function TermCommand.core.get_project_name()
  -- First try to read from dune-project file
  local dune_project = vim.fn.findfile("dune-project", ".;")
  if dune_project ~= "" then
    local file = io.open(dune_project, "r")
    if file then
      for line in file:lines() do
        local name = line:match("^%s*%(name%s+([^%)]+)%)")
        if name then
          file:close()
          return name:gsub("%s+", "") -- Remove any whitespace
        end
      end
      file:close()
    end
  end

  -- Fallback to current directory name
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ":t")
end

---Shows a command palette to select or type a command
function TermCommand.ui.show_command_palette(execution_fn)
  local filetype = vim.bo.filetype
  local command_templates = TermCommand.config.commands_by_ft[filetype]

  if not command_templates or #command_templates == 0 then
    vim.notify("No commands configured for filetype: " .. filetype, vim.log.levels.WARN)
    return
  end

  local file_name = vim.fn.expand("%:t")
  local file_name_no_ext = vim.fn.expand("%:t:r")
  local project_name = nil

  -- Only get project name for OCaml files
  if filetype == "ocaml" then
    project_name = TermCommand.core.get_project_name()
  end

  local final_commands = {}
  for _, template in ipairs(command_templates) do
    local cmd = template
        :gsub("{file}", file_name)
        :gsub("{file_no_ext}", file_name_no_ext)

    -- Only substitute project_name for OCaml
    if project_name then
      cmd = cmd:gsub("{project_name}", project_name)
    end

    table.insert(final_commands, cmd)
  end

  TermCommand.ui.create_command_palette(final_commands, execution_fn)
end

-- ============================================================================
-- Autocommands
-- ============================================================================

TermCommand.autocmds = {}

function TermCommand.autocmds.setup()
  local term_group = vim.api.nvim_create_augroup("CustomTermSetup", { clear = true })
  local set = vim.opt_local

  vim.api.nvim_create_autocmd("TermOpen", {
    group = term_group,
    callback = function()
      set.number = false
      set.relativenumber = false
      set.scrolloff = 0
    end,
  })

  vim.api.nvim_create_autocmd('TermRequest', {
    group = term_group,
    callback = function(ev)
      local dir, n = string.gsub(ev.data.sequence, '^%c]7;file://[^/]*', '')
      if n > 0 and vim.fn.isdirectory(dir) == 1 then
        vim.cmd.lcd(dir)
      end
      if string.match(ev.data.sequence, '^%c]133;A') then
        local lnum = ev.data.cursor[1]
        vim.api.nvim_buf_set_extmark(ev.buf, vim.api.nvim_create_namespace('term-prompt'), lnum - 1, 0, {
          sign_text = '∙',
          sign_hl_group = 'SpecialChar',
        })
      end
    end,
  })
end

-- ============================================================================
-- Keymaps
-- ============================================================================

TermCommand.keymaps = {}

function TermCommand.keymaps.setup()
  vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })

  -- Fixed keymap - changed from <space>st to <leader>st
  vim.keymap.set("n", "<leader>st", function()
    vim.cmd.new()
    vim.cmd.wincmd "J"
    vim.api.nvim_win_set_height(0, 12)
    vim.cmd.term()
    vim.cmd('startinsert')
  end, { desc = "Open [S]plit [T]erminal (Horizontal)" })

  vim.keymap.set("n", "<leader>sv", function()
    vim.cmd.new()
    vim.cmd.wincmd "L"
    vim.wo.winfixwidth = true
    vim.cmd.term()
    vim.cmd('startinsert')
  end, { desc = "Open [S]plit [V]ertical Terminal" })

  -- This is the main command palette that should work from any buffer
  vim.keymap.set("n", "<leader>r", function()
    TermCommand.ui.show_command_palette(function(cmd)
      -- First try to send to existing terminal
      local term_job_id = TermCommand.core.find_terminal_job_id()
      if term_job_id then
        vim.fn.chansend(term_job_id, cmd .. "\r")
        -- Use silent notification to avoid "press enter to continue"
        vim.notify("→ " .. cmd, vim.log.levels.INFO, { timeout = 1500 })
      else
        -- Create horizontal split terminal silently
        vim.cmd.new()
        vim.cmd.wincmd "J"
        vim.api.nvim_win_set_height(0, 12)
        vim.cmd.term()

        -- Wait a bit for terminal to initialize, then send command
        vim.defer_fn(function()
          local new_term_job_id = TermCommand.core.find_terminal_job_id()
          if new_term_job_id then
            vim.fn.chansend(new_term_job_id, cmd .. "\r")
            vim.notify("→ " .. cmd, vim.log.levels.INFO, { timeout = 1500 })
          else
            vim.notify("Failed to create terminal", vim.log.levels.ERROR, { timeout = 3000 })
          end
        end, 100)
      end
    end)
  end, { desc = "Run [P]roject Command in Terminal" })

  -- vim.keymap.set("n", "<leader>rs", function()
  --   local current_file = vim.api.nvim_buf_get_name(0)
  --   if current_file == "" then
  --     vim.notify("Cannot run: Buffer is not saved to a file.", vim.log.levels.WARN)
  --     return
  --   end
  --   local cmd = "uv run textual run --dev " .. current_file
  --   TermCommand.core.execute_in_float(cmd)
  -- end, { desc = "Run [S]erver in float" })
end

-- ============================================================================
-- Initial setup calls
-- ============================================================================

TermCommand.autocmds.setup()
TermCommand.keymaps.setup()

return TermCommand

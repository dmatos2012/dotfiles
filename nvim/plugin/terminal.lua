-- ============================================================================
-- Terminal utilities
-- ============================================================================

local run_commands = {
  python = "uv run %",
  rust   = "cargo r",
}

local function with_shell(shell, fn)
  local prev = vim.o.shell
  vim.o.shell = shell
  local ok, err = pcall(fn)
  vim.o.shell = prev
  if not ok then error(err) end
end

---Returns the job ID of the most recently used running terminal, or nil.
local function find_terminal_job_id()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for i = #wins, 1, -1 do
    local buf = vim.api.nvim_win_get_buf(wins[i])
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
      local ok, job_id = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
      if ok and job_id and job_id > 0 and vim.fn.jobwait({ job_id }, 0)[1] == -1 then
        return job_id
      end
    end
  end
end

---Sends a command to the active terminal, opening a horizontal split first if needed.
local function send_to_terminal(cmd)
  local job_id = find_terminal_job_id()

  if job_id then
    vim.fn.chansend(job_id, cmd .. "\r")
  else
    vim.cmd.new()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 12)
    with_shell("nu", function() vim.cmd.term() end)
    vim.cmd("startinsert")
    vim.defer_fn(function()
      local new_job_id = find_terminal_job_id()
      if new_job_id then
        vim.fn.chansend(new_job_id, cmd .. "\r")
      end
    end, 150)
  end
end

-- ============================================================================
-- Autocommands
-- ============================================================================

local term_group = vim.api.nvim_create_augroup("CustomTermSetup", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- OSC 7 (cwd tracking) + OSC 133 (prompt marks)
vim.api.nvim_create_autocmd("TermRequest", {
  group = term_group,
  callback = function(ev)
    local dir, n = string.gsub(ev.data.sequence, "^%c]7;file://[^/]*", "")
    if n > 0 and vim.fn.isdirectory(dir) == 1 then
      vim.cmd.lcd(dir)
    end
    if string.match(ev.data.sequence, "^%c]133;A") then
      local lnum = ev.data.cursor[1]
      vim.api.nvim_buf_set_extmark(ev.buf, vim.api.nvim_create_namespace("term-prompt"), lnum - 1, 0, {
        sign_text = "∙",
        sign_hl_group = "SpecialChar",
      })
    end
  end,
})

-- ============================================================================
-- Keymaps
-- ============================================================================

vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<leader>st", function()
  vim.cmd.new()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 12)
  with_shell("nu", function() vim.cmd.term() end)
  vim.cmd("startinsert")
end, { desc = "Open split terminal (horizontal)" })

vim.keymap.set("n", "<leader>sv", function()
  vim.cmd.new()
  vim.cmd.wincmd("L")
  vim.wo.winfixwidth = true
  with_shell("nu", function() vim.cmd.term() end)
  vim.cmd("startinsert")
end, { desc = "Open split terminal (vertical)" })

---Parses a justfile and returns a list of public recipe names.
local function get_just_recipes()
  local justfile = vim.fn.findfile("justfile", ".;") ~= "" and vim.fn.findfile("justfile", ".;")
    or vim.fn.findfile("Justfile", ".;")
  if not justfile or justfile == "" then return nil end

  local recipes = {}
  for line in io.lines(justfile) do
    -- Recipe lines: start with a non-whitespace, non-comment, non-@ identifier followed by optional args then ':'
    local name = line:match("^([a-zA-Z][a-zA-Z0-9_%-]*)%s*[^:]-%:")
    if name then
      table.insert(recipes, name)
    end
  end
  return #recipes > 0 and recipes or nil
end

vim.keymap.set("n", "<leader>j", function()
  local recipes = get_just_recipes()
  if not recipes then
    vim.notify("No justfile found", vim.log.levels.WARN)
    return
  end
  vim.ui.select(recipes, { prompt = "just" }, function(choice)
    if choice then
      send_to_terminal("just " .. choice)
    end
  end)
end, { desc = "Run just recipe" })

vim.keymap.set("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local template = run_commands[ft]
  if not template then
    vim.notify("No run command for filetype: " .. ft, vim.log.levels.WARN)
    return
  end
  local cmd = template:gsub("%%", vim.fn.expand("%:p"))
  send_to_terminal(cmd)
end, { desc = "Run current file" })

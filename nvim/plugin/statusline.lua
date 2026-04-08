_G.custom_statusline = function()
  local mode_map = {
    ['n']   = 'NORMAL',
    ['i']   = 'INSERT',
    ['v']   = 'VISUAL',
    ['V']   = 'V-LINE',
    ['\22'] = 'V-BLOCK',
    ['c']   = 'COMMAND',
    ['R']   = 'REPLACE',
    ['t']   = 'TERMINAL',
  }
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_str = mode_map[current_mode] or current_mode

  local git_str = ""
  local dict = vim.b.gitsigns_status_dict
  if dict and dict.head then
    local stats = {}
    if dict.added and dict.added > 0 then table.insert(stats, "+" .. dict.added) end
    if dict.changed and dict.changed > 0 then table.insert(stats, "~" .. dict.changed) end
    if dict.removed and dict.removed > 0 then table.insert(stats, "-" .. dict.removed) end

    if #stats > 0 then
      git_str = dict.head .. "[" .. table.concat(stats, ",") .. "]"
    else
      git_str = dict.head
    end
  end

  local file_name = "%f"
  local modified = "%m"
  local readonly = "%r"
  local align = "%="
  local truncate = "%<"

  local ok, _ = pcall(vim.diagnostic.get, 0)
  local lsp_status = ""
  if ok then
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if errors > 0 or warnings > 0 then
      lsp_status = string.format("E:%d W:%d ", errors, warnings)
    end
  end

  local ft = vim.bo.filetype
  local filetype = ft == "" and "" or ("[" .. ft .. "] ")

  local location = "%l:%c"
  local percentage = "%p%%"

  return string.format(
    "[%s] %s %s %s%s%s%s %s %s%s%s %s ",
    mode_str, git_str,
    align,
    truncate, file_name, modified, readonly,
    align,
    lsp_status, filetype, percentage, location
  )
end

vim.opt.statusline = "%!v:lua.custom_statusline()"

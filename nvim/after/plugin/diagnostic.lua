vim.diagnostic.config({ virtual_text = true })
-- Toggle virtual text
-- virtual_lines for toggling virtual lines
vim.keymap.set("n", "gK", function()
  local new_config = not vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = new_config })
end, { desc = "Toggle diagnostic virtual_text" })


vim.keymap.set("n", "<space>sl", function()
  vim.diagnostic.open_float(0, { scope = "line" })
end)

local severity_levels = {
  vim.diagnostic.severity.ERROR,
  vim.diagnostic.severity.WARN,
  vim.diagnostic.severity.INFO,
  vim.diagnostic.severity.HINT,
}

local get_highest_error_severity = function()
  for _, level in ipairs(severity_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level } })
    if #diags > 0 then
      return level, diags
    end
  end
end


local set = vim.keymap.set
-- ]d and [d override the default neovim by going to highest error severity
-- instead of the next one, which might be a hint.
set("n", "]d", function()
  vim.diagnostic.goto_next { severity = get_highest_error_severity(), wrap = true, float = true }
end)

set("n", "[d", function()
  vim.diagnostic.goto_prev { severity = get_highest_error_severity(), wrap = true, float = true }
end)

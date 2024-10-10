vim.diagnostic.config {
  underline = true,
  virtual_text = {
    prefix = "",
    severity = nil,
    source = "if_many",
    format = nil,
  },
  signs = true,
  severity_sort = true,
  update_in_insert = false,
}

-- Go to the next diagnostic, but prefer going to errors first
-- In general, I pretty much never want to go to the next hint
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

-- Maybe move these mappings to `mappings.lua`
-- For now we leave them here
--
local set = vim.keymap.set
set("n", "<space>dn", function()
  vim.diagnostic.goto_next { severity = get_highest_error_severity(), wrap = true, float = true }
end)

set("n", "<space>dp", function()
  vim.diagnostic.goto_prev { severity = get_highest_error_severity(), wrap = true, float = true }
end)

set("n", "<space>sl", function()
  vim.diagnostic.open_float(0, { scope = "line" })
end)

local lsp_path = vim.fn.stdpath("config") .. "/after/lsp"
for _, file in pairs((vim.fn.readdir(lsp_path))) do
  local name = file:gsub("%.lua$", "")
  vim.lsp.enable(name)
end

-- Use ui2 even tho is experimental
-- using default values
require("vim._core.ui2").enable({})

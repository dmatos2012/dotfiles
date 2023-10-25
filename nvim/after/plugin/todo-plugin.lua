if not pcall(require, "todo") then
  return
end
require("todo").setup {
  hl_color = "#000000"
}

-- require("todo").export()
-- local todo = require("todo")
-- todo.create_export_md()
-- require("todo").export()

-- vim.api.nvim_create_autocmd({"TextChanged", "BufEnter", "TextChangedI"}, {command = "lua require('todo').update_highlight()"})


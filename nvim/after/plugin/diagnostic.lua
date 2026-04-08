vim.diagnostic.config({ virtual_text = true })
-- Toggle virtual lines
-- vim.keymap.set("n", "gK", function()
-- 	local new_config = not vim.diagnostic.config().virtual_lines
-- 	vim.diagnostic.config({ virtual_lines = new_config })
-- end, { desc = "Toggle diagnostic virtual_lines" })

-- Toggle virtual text

vim.keymap.set("n", "<space>sl", function()
  vim.diagnostic.open_float(0, { scope = "line" })
end)

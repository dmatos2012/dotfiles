local append_data = function(_, data)
  if data then
    vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(),-1,-1, false, data)
  end
end
text = {output = {}}
text["output"] = {"yes"}
vim.api.nvim_create_user_command("Kahlua", function() 
  file_name = vim.api.nvim_buf_get_name(0) -- curr buf
  vim.cmd('split')
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win,buf)
  -- vim.cmd('new')
  vim.fn.jobstart({"python", file_name}, {
    stdout_buffered = true,
    on_stdout = append_data,
    on_stderr = append_data,
  })
end, {})


vim.api.nvim_set_keymap("n", "<space>rp", '<cmd>:Kahlua<CR>', { noremap = true })

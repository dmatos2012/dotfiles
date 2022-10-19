-- vim.api.nvim_create_autocmd("BufWritePost", {
--   group = vim.api.nvim_create_augroup("david-post", {clear = true}),
--   pattern = "*.py",
--   callback = function()
--     local append_data = function(_, data)
--       if data then
--         -- vim.cmd('new')
--         -- vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(),-1,-1,false, data)
--         vim.api.nvim_buf_set_lines(vim.api.vim_get_current_buf(),-1,-1,false, data)
--       end
--     end
--     -- vim.api.nvim_buf_set_lines(output_bufnr, 0,-1, false, {"file output:" })
--     command = {"python", vim.api.nvim_buf_get_name(0)}
--     -- vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0,-1, false, {"file output:" })
--     vim.fn.jobstart(command, {
--       stdout_buffered = true,
--       on_stdout = append_data,
--       on_stderr = append_data,
--     })
--   end,
-- })


-- vim.api.cmd.new()
-- buf = vim.api.nvim_create_buf(0,1)
-- print(buf)


vim.cmd('vsplit')
local win = vim.api.nvim_get_current_win()
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_win_set_buf(win, buf)

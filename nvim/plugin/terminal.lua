local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0

    vim.bo.filetype = "terminal"
  end,
})

local job_id = 0

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<space>st", function()
  vim.cmd.new()
  vim.cmd.wincmd "J"
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
  job_id = vim.bo.channel
end)

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<space>sv", function()
  vim.cmd.new()
  vim.cmd.wincmd "H"
  -- We dont set height or width since we want it evenly
  vim.wo.winfixwidth = true
  vim.cmd.term()
  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>p", function()
  vim.fn.chansend(job_id, "do { python3 hi.py }\r\n")
  -- vim.fn.chansend(job_id, { "python3 hi.py\r\n" })
end)

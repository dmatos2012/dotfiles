-- Create a dedicated augroup for all terminal-related autocommands.
-- Using { clear = true } prevents duplicating autocommands if you reload your config.
local term_group = vim.api.nvim_create_augroup("custom-term-setup", { clear = true })

local set = vim.opt_local

-- Autocommand 1: Set local settings when a terminal buffer opens.
vim.api.nvim_create_autocmd("TermOpen", {
  group = term_group,
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
    vim.bo.filetype = "terminal"
    -- Optional: You could add the keymaps from the reference here too
    -- if you want them to be terminal-buffer-local.
    -- vim.cmd('nnoremap <silent><buffer> <cr> i<cr><c-\\><c-n>')
  end,
})

vim.api.nvim_create_autocmd('TermRequest', {
  group = term_group,
  callback = function(ev)
    local dir, n = string.gsub(ev.data.sequence, '^%c]7;file://[^/]*', '')

    if n > 0 then
      if vim.fn.isdirectory(dir) == 1 then
        vim.cmd.lcd(dir)
      end
    end

    if string.match(ev.data.sequence, '^%c]133;A') then
      local lnum = ev.data.cursor[1]
      vim.api.nvim_buf_set_extmark(ev.buf, vim.api.nvim_create_namespace('term-prompt'), lnum - 1, 0, {
        sign_text = '∙',
        sign_hl_group = 'SpecialChar',
      })
    end
  end,
})

-- The rest of your keymaps and config remain the same.
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
end)

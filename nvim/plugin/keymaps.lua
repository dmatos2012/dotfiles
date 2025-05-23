local set = vim.keymap.set
local k = vim.keycode

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

set("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

-- Toggle hlsearch if it's on, otherwise just do "enter"
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return k "<CR>"
  end
end, { expr = true })

-- Normally these are not good mappings, but I have left/right on my thumb
-- cluster, so navigating tabs is quite easy this way.
set("n", "<left>", "gT")
set("n", "<right>", "gt")

-- There are builtin keymaps for this now, but I like that it shows
-- the float when I navigate to the error - so I override them.
set("n", "]d", vim.diagnostic.goto_next)
set("n", "[d", vim.diagnostic.goto_prev)

-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")

set("n", "<M-j>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! ]c]]
  else
    vim.cmd [[m .+1<CR>==]]
  end
end)

set("n", "<M-k>", function()
  if vim.opt.diff:get() then
    vim.cmd [[normal! [c]]
  else
    vim.cmd [[m .-2<CR>==]]
  end
end)

set("n", "<space>tt", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
end)

-- -- Telescope related
-- Use FZF instead
local fzf = require "fzf-lua"
-- local builtin = require "telescope.builtin"
set("n", "<leader>ft", fzf.files, {})
set("n", "<leader>fo", fzf.oldfiles, {})
set("n", "<leader>fg", fzf.live_grep, {})
-- This doesnt work yet for me
set("x", "<leader>fg", fzf.grep_visual, {})
-- create grep_visual using mode "x"
-- set("n", "<leader>fg", fzf.grep_visual, {})
-- set("n", "<leader>fb", builtin.buffers, {})
-- set("n", "<leader>fh", builtin.help_tags, {})
-- set("n", "<leader>to", builtin.colorscheme, {})
--
-- Fat fingers commands
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Helpful delete/change into blackhole buffer
-- nmap <leader>d "_d
-- nmap <leader>c "_c
-- nmap <space>d "_d
-- nmap <space>c "_c

-- Change nmap above to the function above `set`
set("n", "<leader>d", '"_d', {})
set("n", "<leader>c", '"_c', {})

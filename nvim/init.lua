--[[
-- Setup initial configuration,
-- 
-- Primarily just download and execute lazy.nvim
--]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable builtin plugins
require "custom.disable_builtin"

-- Use specific pynvim version to speed up python startup
-- It really speeds it up by 100ms (quite the difference)
vim.g.python3_host_prog = "/home/david/.venvs/pynvim_venv/bin/python"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

-- Add lazy to the `runtimepath`, this allows us to `require` it.
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Set up lazy, and load my `lua/custom/plugins/` folder
require("lazy").setup({ import = "custom/plugins" }, {
  change_detection = {
    notify = false,
  },
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      source = "📄",
      start = "🚀",
      task = "📌",
    },
  },
})

-- Jump To last position on file. see :help last-position-jump. Seen on reddit/neovim by justinmk
vim.cmd [[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]


-- Apparently sets autosave, seen on reddit by justinkmk
-- https://github.com/justinmk/config/blob/c3e8dcd8b8e179fd9d3a16572b2d7c9be55c5104/.config/nvim/init.lua#L80
vim.cmd [[autocmd BufHidden,FocusLost,WinLeave,CursorHold * if &buftype=='' && filereadable(expand('%:p')) | silent lockmarks update ++p | endif]]

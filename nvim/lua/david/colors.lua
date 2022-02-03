local colors = require("colorbuddy.color").colors

local ns_david = vim.api.nvim_create_namespace "david_colors"
local ns_david_2 = vim.api.nvim_create_namespace "david_colors_2"

vim.api.nvim_set_decoration_provider(ns_david, {
  on_start = function(_, tick)
  end,

  on_buf = function(_, bufnr, tick)
  end,

  on_win = function(_, winid, bufnr, topline, botline)
  end,

  on_line = function(_, winid, bufnr, row)
    if row == 10 then
      vim.api.nvim_set_hl_ns(ns_david_2)
    else
      vim.api.nvim_set_hl_ns(ns_david)
    end
  end,

  on_end = function(_, tick)
  end,
})

vim.api.nvim_set_hl(ns_david, "LuaFunctionCall", {
  foreground = colors.green:to_rgb(),
  background = nil,
  reverse = false,
  underline = false,
})

vim.api.nvim_set_hl_ns(ns_david)

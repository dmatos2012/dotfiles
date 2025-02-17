require("supermaven-nvim").setup {
  keymaps = {
    accept_suggestion = "<M-n>",
    clear_suggestion = "<M-]>",
    accept_word = "<M-j>",
  },
  -- ignore_filetypes = { cpp = true },
  -- Try to practice and learn
  ignore_filetypes = { cpp = true, rust = true, rescript = true, ocaml = true, elixir = true },
  -- color = {
  --   suggestion_color = "#ffffff",
  --   cterm = 244,
  -- },
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more manual control
  -- condition = function()
  --   return false
  -- end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
}

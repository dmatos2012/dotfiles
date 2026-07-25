vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "blink.cmp",
  group = vim.api.nvim_create_augroup("blink_build", { clear = true }),
  callback = function(ev)
    if ev.data.kind == "install" or ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("blink.cmp")
      end
      require("blink.cmp").build():pwait()
    end
  end,
})

-- blink.lib is a required dependency of blink.cmp 2.0+
vim.pack.add({ { src = "https://github.com/saghen/blink.lib" } })
vim.pack.add({ { src = "https://github.com/Saghen/blink.cmp" } })

-- Plugin setup
require("blink.cmp").setup({
  -- enabled = function() return not vim.tbl_contains({ "lua", "markdown" }, vim.bo.filetype) end,
  sources = {
    per_filetype = {
      sql = { "snippets", "dadbod", "buffer" },
    },
    providers = {
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
    }
  },
  fuzzy = { implementation = "prefer_rust" },
  keymap = {
    ["<C-n>"] = { "show_and_insert", "select_next" },
    ["<C-p>"] = { "show_and_insert", "select_prev" },
    ["<C-j>"] = { "select_and_accept" },
  },
  -- providers = {
  --   dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
  -- }

})

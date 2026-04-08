return {
  cmd = { "emmylua_ls" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  },
  filetypes = { "lua" },
  root_markers = { ".emmyrc.json", ".luarc.json", ".git" },
}

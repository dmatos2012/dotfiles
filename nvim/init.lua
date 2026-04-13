local lsp_path = vim.fn.stdpath("config") .. "/after/lsp"
for _, file in pairs((vim.fn.readdir(lsp_path))) do
  local name = file:gsub("%.lua$", "")
  vim.lsp.enable(name)
end

-- Jump To last position on file. see :help last-position-jump. Seen on reddit/neovim by justinmk
vim.cmd [[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]

-- Change *.tcss(textual) to use the css ft
vim.filetype.add {
  extension = {
    tcss = "css",
  },
}

-- Use ui2 even tho is experimental
require("vim._core.ui2").enable({})

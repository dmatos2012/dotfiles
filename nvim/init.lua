-- require "impatient"
vim.g.mapleader = " "
vim.g.snippets = "luasnip"
require "david.globals"
require "david.disable_builtin"
-- Force loading of astronauta first.
vim.cmd [[runtime plugin/astronauta.vim]]
require "david.lsp"
require "david.telescope.setup"
require "david.telescope.mappings"

-- Jump To last position on file. see :help last-position-jump. Seen on reddit/neovim by justinmk
vim.cmd [[autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]



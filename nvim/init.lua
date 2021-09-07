pcall(require, "impatient")
vim.g.mapleader = " "
vim.g.snippets = "luasnip"
require "david.globals"
require "david.disable_builtin"
-- Force loading of astronauta first.
vim.cmd [[runtime plugin/astronauta.vim]]
require "david.lsp"
require "david.telescope.setup"
require "david.telescope.mappings"

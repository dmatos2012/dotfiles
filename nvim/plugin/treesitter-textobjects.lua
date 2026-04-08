vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

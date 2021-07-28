vim.g.nvchad_theme = "gruvchad"

local present, base16 = pcall(require, "base16")

if present then
    base16(base16.themes["gruvchad"], true)
    require "highlights"
    return true
else
    return false
end

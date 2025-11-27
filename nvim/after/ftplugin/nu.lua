local set = vim.opt
set.commentstring = "# %s"
-- Set the width for an indent operation (like >> or auto-indent) to 2 spaces
vim.opt_local.shiftwidth = 2
-- Make the Tab key on the keyboard behave as if it's inserting 2 spaces
vim.opt_local.softtabstop = 2
-- Tell Vim that a tab character in the file should be displayed as 2 columns wide
vim.opt_local.tabstop = 2

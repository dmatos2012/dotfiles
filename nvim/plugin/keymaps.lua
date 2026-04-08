local set = vim.keymap.set
local k = vim.keycode

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")


-- Toggle hlsearch if it's on, otherwise just do "enter"
set("n", "<CR>", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.v.hlsearch == 1 then
    vim.cmd.nohl()
    return ""
  else
    return k "<CR>"
  end
end, { expr = true })


-- Gotta see if this works out for me
-- and doesnt interfere with other commands
-- Shift-L to go to next tab, Shift-H to go to previous
-- Alternatively, I could use <Leader>number, but can
-- maybe come later
vim.keymap.set('n', 'L', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', 'H', ':tabprev<CR>', { silent = true })

-- Fat fingers commands
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

-- Change nmap above to the function above `set`
set("n", "<leader>d", '"_d', {})
set("n", "<leader>c", '"_c', {})

-- Lets try these changes to avoid doing constantly `:w, :wq` and its variants

-- Mapping for saving the current file
set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write/Save file" })

-- for saving and quitting
-- Commenting because there is huge delay because of the <leader>w cmd
-- set("n", "<leader>wq", "<cmd>wq<CR>", { desc = "Save and quit" })

-- for quitting without saving
set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- to force quit
set("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force quit" })

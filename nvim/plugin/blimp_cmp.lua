-- From https://github.com/saghen/blink.cmp/issues/2142
-- Create an event to build `blink.cmp` with `cargo build --release`.
-- This event should be defined *before* the `vim.pack.add` call
-- so it runs automatically after the plugin is installed.
vim.api.nvim_create_autocmd("PackChanged", {
	pattern = "blink.cmp",
	group = vim.api.nvim_create_augroup("blink_update", { clear = true }),
	callback = function(e)
		if e.data.kind == "update" then
			-- Recommended way to access plugin files inside `PackChanged` event
			-- vim.cmd [[packadd blink.cmp]]
			vim.cmd.packadd({ args = { e.data.spec.name }, bang = false })
			-- Build the plugin from source
			-- vim.cmd [[BlinkCmp build]]
			require("blink.cmp.fuzzy.build").build()
		end
	end,
})

-- Install/load the plugin
vim.pack.add({ { src = "https://github.com/Saghen/blink.cmp" } })

-- This autocmd doesn’t work for the first installation
-- vim.api.nvim_create_autocmd("PackChanged", {
--   pattern = "blink.cmp",
--   group = vim.api.nvim_create_augroup("blink_update_2", { clear = true }),
--   callback = function()
--     vim.print("Doesn't work")
--   end,
-- })

-- Plugin setup
require("blink.cmp").setup({
	keymap = {
		["<C-n>"] = { "show_and_insert", "select_next" },
		["<C-p>"] = { "show_and_insert", "select_prev" },
		["<C-j>"] = { "select_and_accept" },
	},
})

-- Prevent attach of LSP or anything on "Big Files"
-- Big files are files that are larger than 500KB
-- That way is possible to load them without nvim freezing.
local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup

-- Disable certain features when opening large files
local big_file = autogroup("BigFile", { clear = true })
vim.filetype.add {
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and vim.fn.getfsize(path) > 1024 * 500
            and "bigfile"
          or nil -- bigger than 500KB
      end,
    },
  },
}

autocmd({ "FileType" }, {
  group = big_file,
  pattern = "bigfile",
  callback = function(ev)
    vim.cmd "syntax off"
    -- vim.cmd "UfoDetach"
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
    end)
  end,
})

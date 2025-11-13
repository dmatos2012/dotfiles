local M = {}
local function get_installed_colorschemes()
  -- Because we searched for both .vim and .lua files, there might be duplicates, so we need to use a set
  local colorscheme_set = {}
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/"

  -- Find all .vim and .lua files inside any 'colors' subdirectory
  local cmd = "find " .. lazy_path .. " -path '*/colors/*.vim' -o -path '*/colors/*.lua'"
  local handle = io.popen(cmd)
  if handle then
    for line in handle:lines() do
      -- Get the filename without the path and extension, e.g., "catppuccin-mocha"
      local name = vim.fn.fnamemodify(line, ":t:r")
      colorscheme_set[name] = true
    end
    handle:close()
  end

  local colorschemes = {}
  for cs_name in pairs(colorscheme_set) do
    table.insert(colorschemes, cs_name)
  end
  table.sort(colorschemes)
  return colorschemes
end

function M.show_colorschemes()
  require('fzf-lua').fzf_exec(get_installed_colorschemes(), {
    prompt = 'Colorschemes> ',
    -- Using fzf-native preview its like this below
    -- Just shows the output of whatever cmd I give it
    -- fzf_opts = {
    --   ['--preview-window'] = 'nohidden,down,50%',
    --   ['--preview'] = function(items)
    --     local contents = {}
    --     vim.tbl_map(function(x)
    --       table.insert(contents, "colorscheme " .. x)
    --     end, items)
    --     return contents
    --   end
    --
    -- },
    actions = {
      ['default'] = function(selected)
        local cs_name = selected[1]
        vim.cmd.highlight("clear")
        vim.cmd.syntax("reset")
        vim.cmd.colorscheme(cs_name)
      end,
    },
  })
end

return M
-- vim.keymap.set("n", "<leader>tc", function()
--   show_colorschemes()
-- end, { desc = "Theme chooser (live preview)" })

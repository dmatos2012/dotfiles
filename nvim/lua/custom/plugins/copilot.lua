-- Temporarily disable bc yeah, we are not getting copilot again
-- anything soon
-- return {}
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        --  otherwise you have to do it manually,
        -- and it just doesnt work
        auto_trigger = true,
        keymap = {
          -- Lets leave default for now of alt-l,
          -- bit uncomfortable but will do
          -- accept = "<C-y>"
        },

      },
      filetypes = {
        rust = false,
        ocaml = false,
        css = false,
        sql = false,
        zig = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            -- disable for .env files
            return false
          end
          return true
        end,
      }
    })
  end,
}

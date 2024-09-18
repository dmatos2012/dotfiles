return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup {
      log_level = "off", -- set to off to disable logging completely
      condition = function()
        return false
      end,
    }
  end,
}

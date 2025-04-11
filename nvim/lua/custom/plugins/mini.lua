return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup()
      require("mini.hipatterns").setup()
      require("mini.surround").setup()
      require("mini.move").setup()
      require("mini.bufremove").setup()
    end,
  },
}

return {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  build = function()
    require("nvim-treesitter.install").update { with_sync = true }()
  end,
}

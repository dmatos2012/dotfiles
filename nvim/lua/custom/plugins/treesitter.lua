return {
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/nvim-treesitter-textobjects",
  -- "nvim-treesitter/nvim-treesitter-refactor",
  build = function()
    require("nvim-treesitter.install").update { with_sync = true }()
  end,
}

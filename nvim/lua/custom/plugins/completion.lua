--     use "lukas-reineke/cmp-under-comparator"
return {
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "onsails/lspkind-nvim" },
  { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
  { "tamago324/cmp-zsh" },

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
          },
          filetypes = {
            python = true,
            rust = true,
            ["*"] = false,
          },
        })
      end,
  },
  -- waaaay too slow disable
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end,
  -- },
}

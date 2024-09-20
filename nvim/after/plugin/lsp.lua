local lsp = require "lspconfig"
lsp.graphql.setup {}
local conform = require "conform"
conform.setup {
  formatters_by_ft = {
    -- this is pretty slow but does the job
    graphql = { "prettier" },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}

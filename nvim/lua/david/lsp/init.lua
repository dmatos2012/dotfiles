local imap = require("david.keymap").imap
local nmap = require("david.keymap").nmap

local has_lsp, lspconfig = pcall(require, "lspconfig")
if not has_lsp then
  return
end


local lspconfig_util = require "lspconfig.util"

local ok, nvim_status = pcall(require, "lsp-status")
if not ok then
  nvim_status = nil
end

local telescope_mapper = require "david.telescope.mappings"
local handlers = require "david.lsp.handlers"


-- Can set this lower if needed.
-- require("vim.lsp.log").set_level "debug"
-- require("vim.lsp.log").set_level "trace"

local status = require "david.lsp.status"
if status then
  status.activate()
end

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local augroup_format = vim.api.nvim_create_augroup("my_lsp_format", { clear = true })
local autocmd_format = function(async, filter)
  vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format { async = async, filter = filter }
    end,
  })
end

local filetype_attach = setmetatable({

  rust = function()
    -- vim.cmd [[
    --   autocmd BufEnter,BufWritePost <buffer> :lua require('lsp_extensions.inlay_hints').request {aligned = true, prefix = " » "}
    -- ]]

    telescope_mapper("<space>wf", "lsp_workspace_symbols", {
      ignore_filename = true,
      query = "#",
    }, true)

    autocmd_format(false)
  end,
}, {
  __index = function()
    return function() end
  end,
})

local buf_nnoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  nmap(opts)
end

local buf_inoremap = function(opts)
  if opts[3] == nil then
    opts[3] = {}
  end
  opts[3].buffer = 0

  imap(opts)
end

local custom_attach = function(client)
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")

  if nvim_status then
    nvim_status.on_attach(client)
  end

  buf_inoremap { "<c-s>", vim.lsp.buf.signature_help }

  buf_nnoremap { "<space>cr", vim.lsp.buf.rename }
  buf_nnoremap { "<space>ca", vim.lsp.buf.code_action }

  buf_nnoremap { "gd", vim.lsp.buf.definition }
  buf_nnoremap { "gD", vim.lsp.buf.declaration }
  buf_nnoremap { "gT", vim.lsp.buf.type_definition }

  buf_nnoremap { "<space>gI", handlers.implementation }
  buf_nnoremap { "<space>lr", "<cmd>lua R('david.lsp.codelens').run()<CR>" }
  buf_nnoremap { "<space>rr", "LspRestart" }

  telescope_mapper("gr", "lsp_references", nil, true)
  telescope_mapper("gI", "lsp_implementations", nil, true)
  telescope_mapper("<space>wd", "lsp_document_symbols", { ignore_filename = true }, true)
  telescope_mapper("<space>ww", "lsp_dynamic_workspace_symbols", { ignore_filename = true }, true)

  if filetype ~= "lua" then
    buf_nnoremap { "K", vim.lsp.buf.hover, { desc = "lsp:hover" } }
  end

  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  if client.server_capabilities.codeLensProvider then
    if filetype ~= "elm" then
      vim.cmd [[
        augroup lsp_document_codelens
          au! * <buffer>
          autocmd BufEnter ++once         <buffer> lua require"vim.lsp.codelens".refresh()
          autocmd BufWritePost,CursorHold <buffer> lua require"vim.lsp.codelens".refresh()
        augroup END
      ]]
    end
  end

  -- Attach any filetype specific options to the client
  filetype_attach[filetype](client)
end

local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
if nvim_status then
  updated_capabilities = vim.tbl_deep_extend("keep", updated_capabilities, nvim_status.capabilities)
end
updated_capabilities.textDocument.codeLens = { dynamicRegistration = false }
updated_capabilities = require("cmp_nvim_lsp").update_capabilities(updated_capabilities)

-- TODO: check if this is the problem.
updated_capabilities.textDocument.completion.completionItem.insertReplaceSupport = false

-- vim.lsp.buf_request(0, "textDocument/codeLens", { textDocument = vim.lsp.util.make_text_document_params() })

local servers = {
  pylsp = true,
  bashls = true,
  vimls = true,
  html = true,
  yamlls = true,

  rust_analyzer = {
    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
  },

}

local setup_server = function(server, config)
  if not config then
    return
  end

  if type(config) ~= "table" then
    config = {}
  end

  config = vim.tbl_deep_extend("force", {
    on_init = custom_init,
    on_attach = custom_attach,
    capabilities = updated_capabilities,
    flags = {
      debounce_text_changes = nil,
    },
  }, config)

  lspconfig[server].setup(config)
end

require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


for server, config in pairs(servers) do
  setup_server(server, config)
end


--[ An example of using functions...
-- 0. nil -> do default (could be enabled or disabled)
-- 1. false -> disable it
-- 2. true -> enable, use defaults
-- 3. table -> enable, with (some) overrides
-- 4. function -> can return any of above
--
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, method, params, client_id, bufnr, config)
--   local uri = params.uri
--
--   vim.lsp.with(
--     vim.lsp.diagnostic.on_publish_diagnostics, {
--       underline = true,
--       virtual_text = true,
--       signs = sign_decider,
--       update_in_insert = false,
--     }
--   )(err, method, params, client_id, bufnr, config)
--
--   bufnr = bufnr or vim.uri_to_bufnr(uri)
--
--   if bufnr == vim.api.nvim_get_current_buf() then
--     vim.lsp.diagnostic.set_loclist { open_loclist = false }
--   end
-- end
--]]

-- python graveyard
-- lspconfig.pyls.setup {
--   plugins = {
--     pyls_mypy = {
--       enabled = true,
--       live_mode = false
--     }
--   },
--   on_init = custom_init,
--   on_attach = custom_attach,
--   capabilities = updated_capabilities,
-- }

-- lspconfig.jedi_language_server.setup {
--   on_init = custom_init,
--   on_attach = custom_attach,
--   capabilities = updated_capabilities,
-- }

-- Set up null-ls
local use_null = true
if use_null then
  require("null-ls").setup {
    sources = {
      -- require("null-ls").builtins.formatting.stylua,
      -- require("null-ls").builtins.diagnostics.eslint,
      -- require("null-ls").builtins.completion.spell,
      -- require("null-ls").builtins.diagnostics.selene,
      require("null-ls").builtins.formatting.prettierd,
    },
  }
end

return {
  on_init = custom_init,
  on_attach = custom_attach,
  capabilities = updated_capabilities,
}

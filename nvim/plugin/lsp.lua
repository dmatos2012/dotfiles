-- TOOD: Add my keybindings here
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- Setup keybindings
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

    -- Enable auto-format on save
    -- usually not needed if server supports willSaveWaitUntil
    -- Apparently ZLS supports willSaveWaitUntil but doesnt format,
    -- so we comment out that part
    if
    -- not client:supports_method("textDocument/willSaveWaitUntil")
    -- and client:supports_method("textDocument/formatting")
        client:supports_method("textDocument/formatting")
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
          -- Ruff specific `Organize Imports` code action
          if client.name == "ruff" then
            vim.lsp.buf.code_action({
              context = {
                title = "Organize Imports",
                -- We could also add source.fixAll.ruff but maybe we leave it like this
                only = { "source.organizeImports.ruff" },
                diagnostics = {},
              },
              apply = true,
            })
          end
        end,
      })
    end
  end,
})

-- group = vim.api.nvim_create_augroup("UserLspProgress", {}),
--
vim.api.nvim_create_autocmd('LspProgress', {
  -- buffer = buf,
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

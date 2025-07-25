return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      -- "williamboman/mason.nvim",
      -- "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      -- Autoformatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require("neodev").setup {
        -- library = {
        --   plugins = { "nvim-dap-ui" },
        --   types = true,
        -- },
      }

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local servers = {
        bashls = true,
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },
        rust_analyzer = true,
        pyright = true,
        -- graphql is in after/plugin
        -- graphql = true,
        rescriptls = true,
        -- TODO: Reenable elixirls once 
        -- i get most packages working with nix
        -- elixirls = {
        --   cmd = { "/home/david/build/elixir-ls/language_server.sh" },
        -- },
        ocamllsp = {
          -- manual_install = true,
          -- cmd = { "dune", "tools", "exec", "ocamllsp" },
          settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
            syntaxDocumentation = { enable = true },
          },
          server_capabilities = {
            semanticTokensProvider = false,
          },
        },
        zls = true,
        html = true,
        ts_ls = true,
        cssls = true,
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        clangd = {
          -- TODO: Could include cmd, but not sure those were all relevant flags.
          --    looks like something i would have added while i was floundering
          init_options = { clangdFileStatus = true },
          filetypes = { "c" },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      -- require("mason").setup()
      -- local ensure_installed = {
      --   "stylua",
      -- }

      -- vim.list_extend(ensure_installed, servers_to_install)
      -- require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          -- local builtin = require "telescope.builtin"
          local fzf = require "fzf-lua"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "fd", fzf.lsp_document_diagnostics, { buffer = 0 })
          vim.keymap.set("n", "fD", fzf.lsp_workspace_diagnostics)
          vim.keymap.set("n", "ca", fzf.lsp_code_actions)
          vim.keymap.set("n", "gd", fzf.lsp_definitions)
          vim.keymap.set("n", "gr", fzf.lsp_references)
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
          -- vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      -- Autoformatting Setup
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          -- graphql = { "prettier" },
        },
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          require("conform").format {
            bufnr = args.buf,
            lsp_fallback = true,
            quiet = true,
          }
        end,
      })
    end,
  },
}

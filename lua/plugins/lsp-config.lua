return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local cargotom = require("config.cargotom")

      local function map(bufnr, mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          silent = true,
          noremap = true,
          desc = desc,
        })
      end

      local on_attach = function(client, bufnr)
        map(bufnr, "n", "K", vim.lsp.buf.hover, "LSP Hover")
        map(bufnr, "n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map(bufnr, "n", "<leader>cr", vim.lsp.buf.rename, "Rename Symbol")

        if client:supports_method("textDocument/formatting") then
          map(bufnr, { "n", "v" }, "<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format Buffer")
        end
      end

      local servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = true,
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            javascript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              completeUnimported = true,
              gofumpt = true,
              semanticTokens = true,
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        yamlls = {
          -- Helm values are handled by helm_ls, which provides their schema.
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        },
        helm_ls = {},
      }

      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          capabilities,
          server_config.capabilities or {}
        )
        server_config.on_attach = on_attach
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
      end

      cargotom.configure_lsp(capabilities, on_attach)
    end,
  },
}

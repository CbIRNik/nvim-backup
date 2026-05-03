return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      go = { "goimports", "gofumpt", "gofmt" },
      rust = { "rustfmt" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
  },
}
